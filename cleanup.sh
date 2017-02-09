#!/bin/bash
# cleanup.sh - cleanup the CloudFormation stack and the CodeDeploy
#   application after a successful or failed test.
#   Cleanup removes all stack and CodeDeploy resources
# Usage: 
#   (1) Run the "aws configure" command and, when prompted, provide
#       the AWS Access Key ID and AWS Secret Access Key of an IAM user
#       with sufficient permissions as described in CodeDeployTutorial.doc
#   (2) cd to the "tutorial" directory containing this script and
#       give the command "./cleanup.sh"
echo "Starting cleanup of old resources"
# Clean up any previous CloudFormation stack from this tutorial
aws cloudformation delete-stack --stack-name "cdtutorialStack"
# Clean up any previous CodeDeploy artifacts from this tutorial
aws deploy delete-application --application-name cdtutorialMyApp
echo "Sleeping 3 minutes to allow time for cleanup to complete"
sleep 180
echo "End of cleanup script"
