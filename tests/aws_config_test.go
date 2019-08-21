package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestConfigModule(t *testing.T) {

	allowedRegion := []string{"eu-central-1"}
	bucketPrefix := "my-test-bucket"

	awsRegion := aws.GetRandomStableRegion(t, allowedRegion, nil)

	t.Run("aws_config", func(t *testing.T) {
		options := &terraform.Options{
			TerraformDir: "../scenarios/config",
			Vars: map[string]interface{}{
				"bucket_prefix": bucketPrefix,
			},
			EnvVars: map[string]string{
				"AWS_DEFAULT_REGION": awsRegion,
				"AWS_REGION":         awsRegion,
			},
		}

		defer terraform.Destroy(t, options)
		terraform.InitAndApply(t, options)

		ConfigS3BucketID := terraform.Output(t, options, "config_s3_bucket_id")

		// The prefix we've given should match
		assert.Contains(t, ConfigS3BucketID, bucketPrefix)

		// The S3 bucket should actually exist
		aws.AssertS3BucketExists(
			t,
			awsRegion,
			ConfigS3BucketID,
		)
	})
}
