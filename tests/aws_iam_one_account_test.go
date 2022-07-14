package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestIamOneAccountModule(t *testing.T) {
	awsRegion := aws.GetRandomStableRegion(t, []string{allowedRegion}, nil)

	t.Run("aws_config", func(t *testing.T) {
		options := &terraform.Options{
			TerraformDir: "../scenarios/iam_one_account",
			EnvVars: map[string]string{
				"AWS_DEFAULT_REGION": awsRegion,
				"AWS_REGION":         awsRegion,
			},
		}

		defer terraform.Destroy(t, options)
		terraform.InitAndApply(t, options)
	})
}
