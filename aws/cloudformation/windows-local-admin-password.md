Deploy a windows server with AutoScalingGroup that sets the admin password from secretsmanager.

Adapted from: https://aws.amazon.com/blogs/security/how-to-eliminate-ec2-keypairs-password-retrieval-provisioned-windows-instances-secrets-manager-cloudformation/

```
Parameters:
  RadiusAmi:
    Type: AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>
    Default: /aws/service/ami-windows-latest/Windows_Server-2019-English-Full-Base
Resources:
  RadiusLocalAdminPassword:
    Type: AWS::SecretsManager::Secret
    Properties:
      GenerateSecretString:
        SecretStringTemplate: "{ \"Username\": \"Administrator\" }"
        GenerateStringKey: Password
        PasswordLength: 30
        ExcludeCharacters: "\"@'$`"
  RadiusNodeRole:
    Type: AWS::IAM::Role
    Properties:
      Path: "/"
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement:
        - Effect: Allow
          Principal:
            Service:
            - ec2.amazonaws.com
          Action:
          - sts:AssumeRole
      Policies:
      - PolicyName: secrets-manager
        PolicyDocument:
          Version: 2012-10-17
          Statement:
          - Effect: Allow
            Action:
            - secretsmanager:*SecretValue
            - secretsmanager:UpdateSecretVersionStage
            - secretsmanager:DescribeSecret
            Resource: !Ref RadiusLocalAdminPassword
          - Effect: Allow
            Action:
            - secretsmanager:GetRandomPassword
            Resource: "*"
  RadiusSG:
    Type: AWS::EC2::SecurityGroup
    Properties:
      VpcId: !Ref VPCId
      GroupDescription: SG for cluster
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 3389
        ToPort: 3389
  RadiusLaunchTemplate:
    Type: AWS::EC2::LaunchTemplate
    Properties:
      LaunchTemplateData:
        ImageId: !Ref RadiusAmi
        BlockDeviceMappings:
        - DeviceName: xvdg
          Ebs:
            DeleteOnTermination: true
            VolumeSize: 40
            VolumeType: gp2
            Encrypted: true
        InstanceType: t3a.medium
        InstanceInitiatedShutdownBehavior: terminate
        IamInstanceProfile:
          Arn: !GetAtt RadiusInstanceProfile.Arn
        SecurityGroupIds:
        - !Ref RadiusSG
        UserData: !Base64
          "Fn::Join":
          - "\n"
          - - "<powershell>"
            - "Import-Module AWSPowerShell"
            - "Fn::Join":
              - ""
              - - "$password = ((Get-SECSecretValue -SecretId '"
                - !Ref RadiusLocalAdminPassword
                - "').SecretString | ConvertFrom-Json).Password"
            - "net.exe user Administrator $password"
            - "</powershell>"
  RadiusASG:
    Type: AWS::AutoScaling::AutoScalingGroup
    Properties:
      LaunchTemplate:
        LaunchTemplateId: !Ref RadiusLaunchTemplate
        Version: !GetAtt RadiusLaunchTemplate.LatestVersionNumber
      MaxSize: 2
      MinSize: 0
      DesiredCapacity: 1
      VPCZoneIdentifier:
      - !Ref RadiusSubnet1
  RadiusInstanceProfile:
    Type: AWS::IAM::InstanceProfile
    Properties:
      Path: /
      Roles:
      - !Ref RadiusNodeRole
```
