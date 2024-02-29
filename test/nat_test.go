package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
	"testing"
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
}
