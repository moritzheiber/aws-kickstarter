package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestVpcModule(t *testing.T) {
	awsRegion := aws.GetRandomStableRegion(t, []string{allowedRegion}, nil)

	t.Run("aws_vpc", func(t *testing.T) {
		options := &terraform.Options{
			TerraformDir: "../scenarios/vpc",
			EnvVars: map[string]string{
				"AWS_DEFAULT_REGION": awsRegion,
				"AWS_REGION":         awsRegion,
			},
		}

		defer terraform.Destroy(t, options)
		terraform.InitAndApply(t, options)
	})
}
