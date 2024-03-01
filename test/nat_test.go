package test

import (
	"os"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestNatInstance(t *testing.T) {
	t.Parallel()

	// Get current region from CodeBuild
	region := os.Getenv("AWS_REGION")
	if region == "" {
		region = "us-west-2"
	}

	// Typical Terraform variables
	vars := map[string]interface{}{
		"region": region,
	}

	// If TESTING_SSM_ROLE is set, we will use it to pass it to the
	// instance running the tests. We don't want to be too permissive.
	testing_ssm_role := os.Getenv("TESTING_SSM_ROLE")
	if testing_ssm_role != "" {
		vars["testing_ssm_role"] = testing_ssm_role
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "..",
		Vars:         vars,
		NoColor:      true,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Wait until all instances are registered in the inventory
	instanceIdsString := terraform.OutputList(t, terraformOptions, "test-instances-ids")
	for _, instanceId := range instanceIdsString {
		aws.WaitForSsmInstance(t, region, instanceId, 2*time.Minute)
	}

	ssmClient := aws.NewSsmClient(t, region)
	publicIp := terraform.Output(t, terraformOptions, "public-ip")
	err := runTestDocument(t, ssmClient, "TestInternetConnectivity", publicIp)
	if err != nil {
		t.Log(err)
		t.Fail()
	}
}
