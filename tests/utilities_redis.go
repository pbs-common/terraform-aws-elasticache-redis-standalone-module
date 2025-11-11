package test

import (
	"encoding/json"
	"fmt"
	"strconv"
	"testing"

	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/lambda"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func testRedis(t *testing.T, variant string) {
	t.Parallel()

	terraformDir := fmt.Sprintf("../examples/%s", variant)

	terraformOptions := &terraform.Options{
		TerraformDir: terraformDir,
		LockTimeout:  "5m",
		Upgrade:      true,
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	name := terraform.Output(t, terraformOptions, "name")
	arn := terraform.Output(t, terraformOptions, "arn")
	SGIDs := terraform.Output(t, terraformOptions, "sg_ids")
	engineVersionActual := terraform.Output(t, terraformOptions, "engine_version_actual")
	memberClusters := terraform.Output(t, terraformOptions, "member_clusters")
	primaryEndpointAddress := terraform.Output(t, terraformOptions, "primary_endpoint_address")
	readerEndpointAddress := terraform.Output(t, terraformOptions, "reader_endpoint_address")

	accountID := getAWSAccountID(t)
	region := getAWSRegion(t)

	expectedName := fmt.Sprintf("ex-tf-redis-%s", variant)
	expectedARN := fmt.Sprintf("arn:aws:elasticache:%s:%s:replicationgroup:%s", region, accountID, expectedName)
	expectedMinimumEngineVersionActual := 6.2
	expectedMemberClusters := fmt.Sprintf("[%s-001 %s-002]", expectedName, expectedName)
	expectedPartialPrimaryEndpointAddress := expectedName
	expectedPartialReaderEndpointAddress := expectedName

	engineVersionActualFloat, _ := strconv.ParseFloat(engineVersionActual, 64)

	assert.Equal(t, expectedName, name)
	assert.Equal(t, expectedARN, arn)
	assert.NotNil(t, SGIDs)
	assert.GreaterOrEqual(t, engineVersionActualFloat, expectedMinimumEngineVersionActual)
	assert.Equal(t, expectedMemberClusters, memberClusters)
	assert.Contains(t, primaryEndpointAddress, expectedPartialPrimaryEndpointAddress)
	assert.Contains(t, readerEndpointAddress, expectedPartialReaderEndpointAddress)

	if variant == "lambda" {
		expectedLambdaName := expectedName
		lambdaName := terraform.Output(t, terraformOptions, "lambda_name")
		assert.Equal(t, expectedLambdaName, lambdaName)

		sess, err := session.NewSessionWithOptions(session.Options{
			SharedConfigState: session.SharedConfigEnable,
		})
		if err != nil {
			t.Fatalf("Failed to create AWS session: %v", err)
		}

		lambdaSvc := lambda.New(sess)

		invokeOutput, err := lambdaSvc.Invoke(&lambda.InvokeInput{
			FunctionName: &lambdaName,
		})

		if err != nil {
			t.Fatal(err)
		}

		var lambdaResp struct {
			Result string `json:"result"`
			Error  string `json:"error"`
		}

		err = json.Unmarshal(invokeOutput.Payload, &lambdaResp)

		if err != nil {
			t.Fatal(err)
		}

		if *invokeOutput.StatusCode != 200 {
			t.Logf("lambda response: %v", lambdaResp)
			t.Fatalf("Expected status code 200, got %d", *invokeOutput.StatusCode)
		}

		if lambdaResp.Result == "failure" {
			t.Logf("lambda response: %v", lambdaResp)
			t.Fatalf("Expected result 'success', got 'failure'")
		}
	}
}
