package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestConfigModule(t *testing.T) {
	bucketPrefix := "aws-config"
	awsRegion := aws.GetRandomStableRegion(t, []string{allowedRegion}, nil)

	t.Run("aws_config", func(t *testing.T) {
		options := &terraform.Options{
			TerraformDir: "../scenarios/config",
			EnvVars: map[string]string{
				"AWS_DEFAULT_REGION": awsRegion,
				"AWS_REGION":         awsRegion,
			},
		}

		defer terraform.Destroy(t, options)
		terraform.InitAndApply(t, options)

		ConfigS3BucketARN := terraform.Output(t, options, "config_s3_bucket_arn")

		// The prefix we've given should match
		assert.Contains(t, ConfigS3BucketARN, bucketPrefix)
	})
}
