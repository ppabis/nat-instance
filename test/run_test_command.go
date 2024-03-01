package test

import (
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ssm"
)

// This function executes the SSM document and waits for the result
// It also compares the expected IP with the actual IP in each instance
func runTestDocument(t *testing.T, client *ssm.SSM, documentName string, expectedIp string) error {
	// Start command execution
	// Target instances with tag "Project: NAT-Test"
	// Pass the expected IP as a parameter

	t.Logf("Submitting command to SSM: document %q with expected IP %q", documentName, expectedIp)
	cmd, err := client.SendCommand(&ssm.SendCommandInput{
		DocumentName: aws.String(documentName),

		Parameters: map[string][]*string{
			"expectedIp": {aws.String(expectedIp)},
		},

		Targets: []*ssm.Target{
			{
				Key:    aws.String("tag:Project"),
				Values: []*string{aws.String("NAT-Test")},
			},
		},
	})

	if err != nil {
		return err
	}

	// Get command invocations - so all the instances that are targeted by the command
	id := cmd.Command.CommandId
	invocations, err := client.ListCommandInvocations(&ssm.ListCommandInvocationsInput{
		CommandId: id,
	})

	if err != nil {
		return err
	}

	// Wait for command to finish
	waitForAllInvocations(t, client, invocations.CommandInvocations)

	// Collect statuses - if any is not Success, the test fails
	status := getCollectiveStatus(t, client, invocations.CommandInvocations)

	if status != "Success" {
		t.Log("😭 Some (or all) instances failed the commands!")
		t.Fail()
	} else {
		t.Log("😄 All instances passed the commands! Hooray!")
	}

	return nil
}

func waitForAllInvocations(t *testing.T, client *ssm.SSM, invocations []*ssm.CommandInvocation) {
	for _, inv := range invocations {
		err := client.WaitUntilCommandExecuted(&ssm.GetCommandInvocationInput{
			CommandId:  inv.CommandId,
			InstanceId: inv.InstanceId,
		})

		if err != nil {
			t.Log(err)
		}
	}
}

func getCollectiveStatus(t *testing.T, client *ssm.SSM, invocations []*ssm.CommandInvocation) string {
	status := "Success"

	for _, inv := range invocations {
		out, err := client.GetCommandInvocation(&ssm.GetCommandInvocationInput{
			CommandId:  inv.CommandId,
			InstanceId: inv.InstanceId,
		})

		if err != nil {
			t.Log(err)
			status = "Failed"
			continue
		}

		if *out.Status != "Success" {
			status = "Failed"
			t.Log("Command failed: ", *out.Status, "\n === Stderr:\n", *out.StandardErrorContent)
			t.Log("\n === Output: ", *out.StandardOutputContent)
		}
	}

	return status
}
