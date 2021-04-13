# locust_load_test
HTTP request load test container using locust
  
# How to use
Clone this repository.
```
$ git clone https://github.com/borikatsu/locust_load_test.git your-project-dir
```

# Create test cases
Edit a locustfile.py and define your test scenario. Don't know how to write it? [Click here.](https://docs.locust.io/en/stable/#writing-locust-tests)

If you want to use more enviromet valiables in locustfile.py, you can add them following the **ECSEnvLocust** parameter definition in ecs-task.yml.

After writing the test file, upload it to AWS S3.

# Create resources with CloudFormation
You can execute the command shown below using AWS Cli. Or you can also create stacks from the AWS console.
## VPC
```
$ aws cloudformation create-stack \
  --stack-name your-project-vpc \
  --region ap-northeast-1 \
  --template-body file://./cloudFormation/vpc.yml \
  --parameters \
  ParameterKey=PJPrefix,ParameterValue="test" \
  ParameterKey=VPCCIDR,ParameterValue="10.1.0.0/16" \
  ParameterKey=PublicSubnetACIDR,ParameterValue="10.1.10.0/24"
```

## ECS and ECR
```
$ aws cloudformation create-stack \
  --stack-name your-project-ecs \
  --region ap-northeast-1 \
  --template-body file://./cloudFormation/ecs.yml \
  --parameters \
  ParameterKey=PJPrefix,ParameterValue="test" \
  ParameterKey=ECSClusterName,ParameterValue="cluster" \
  ParameterKey=ECRRepositoryName,ParameterValue="locust"
```

## ECS Task definition
```
$ aws cloudformation create-stack \
  --stack-name your-project-task \
  --region ap-northeast-1 \
  --template-body file://./cloudFormation/ecs-task.yml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
  ParameterKey=PJPrefix,ParameterValue="test" \
  ParameterKey=ECSTaskName,ParameterValue="task" \
  ParameterKey=ECSTaskCPUUnit,ParameterValue="256" \
  ParameterKey=ECSTaskMemory,ParameterValue="512" \
  ParameterKey=ECSContainerName,ParameterValue="container" \
  ParameterKey=ECSImageName,ParameterValue="AWSAccountID.dkr.ecr.ap-northeast-1.amazonaws.com/ecr-repository:latest" \
  ParameterKey=ECSEnvLocustTargetPath,ParameterValue="API HOST" \
  ParameterKey=ECSEnvLocustTargetUrl,ParameterValue="HOST"
```

# Build a dokcer image and Push to ECR
Already, you have a ECR repository because CloudFormation has created it from ecs.yml file. So, you push the built image into this repository From local(current folder where Dockerfile resides).

For more information on docker commands – please check the View push commands button on ECR of AWS console.

# Create and run tasks in ECS cluster
Configure the task based on your requirement(number of tasks) and click on RUN TASK to start the load test.
## Settings for the Master
| Item name | Value |
| :--| :-- |
| Launty type | Fargate |
| Number of tasks | 1 |
| Cluster VPC | VPC you created with CloudFormation |
| Subnets | Subnets you created with CloudFormation |
| SecurityGroup | SecurityGroup you created with CloudFormation |

## Settings for the Slave
| Item name | Value |
| :--| :-- |
| Launty type | Fargate |
| Number of tasks | Number needed for your test scenario |
| Cluster VPC | Same as the Master |
| Subnets | Same as the Master |
| SecurityGroup | Same as the Master |
| Container command | /locust/slave.sh |
| LOCUST_MASTER(enviroment valiable) | Master's private IP address |

# Do the load test
Access the Master's public IP address on port 8089 and start the load test using the LOCUST GUI.
