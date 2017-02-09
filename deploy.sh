#!/bin/bash
# deploy.sh - master script to provision an EC2 instance and
#   deploy a test application to it using AWS CloudFormation and CodeDeploy
#   See CodeDeployTutorial.doc for a full explanation.
# Usage: 
#   (1) Run the "aws configure" command and, when prompted, provide
#       the AWS Access Key ID and AWS Secret Access Key of an IAM user
#       with sufficient permissions as described in CodeDeployTutorial.doc
#   (2) cd to the "tutorial" directory containing this script and
#       give the command "./deploy.sh"
# Expected directory structure:
#   tutorial/
#     deploy.sh - this script
#     cleanup.sh - script to cleanup AWS resources
#     cfTemplate.json - CloudFormation template
#     myApp/ - directory with files for the test application
#
# Cleanup any resources left from previous runs (prevents error msgs.)
./cleanup.sh
# Create a zip archive for myApp with no encompassing directory
echo "Creating zip archive for myApp"
cd myApp
zip -qr ../myApp.zip *
cd ..
# Upload the archive to S3
aws s3 cp myApp.zip s3://cdtutorial-uwf
# Run CloudFormation to create the instance
templatebody="file://`pwd`/cfTemplate.json"
#DEBUG aws cloudformation validate-template --template-body $templatebody
echo "Running CloudFormation to create the stack and instance"
aws cloudformation create-stack --stack-name "cdtutorialStack" --template-body $templatebody
echo "Sleeping 3 minutes to allow instance to start"
sleep 180
# Run CodeDeploy to create a CodeDeploy Application for myApp
echo "Starting CodeDeploy operations"
aws deploy create-application --application-name cdtutorialMyApp
# Run CodeDeploy to create a CodeDeploy DeploymentGroup for the instances
aws deploy create-deployment-group --application-name cdtutorialMyApp --deployment-group-name cdtutorialDG --ec2-tag-filters Key=gTag,Value=myApp,Type=KEY_AND_VALUE --service-role-arn arn:aws:iam::987839724330:role/cdtutorialServiceRole 
# Run CodeDeploy to create a CodeDeploy Deployment for this revision of myApp
aws deploy create-deployment --application-name cdtutorialMyApp --deployment-config-name CodeDeployDefault.OneAtATime --deployment-group-name cdtutorialDG --description "cdtutorial deployment" --s3-location bucket=cdtutorial-uwf,bundleType=zip,key=myApp.zip
echo "Deployment complete. To test get instance's IP and point your browser"
echo "to port 8000, e.g.  http://123.45.67.89:8000"

