#!/usr/bin/env bash

echo -e "$AWS_ACCESS_KEY\n$AWS_SECRET_KEY\n$region\n" | aws configure
echo "aws configured"

#curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
#chmod +x kops-linux-amd64
#sudo mv kops-linux-amd64 /usr/local/bin/kops
#echo "kops instaled"

aws s3api create-bucket --bucket softserve-demo3-asdfgh  --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1
aws s3api put-bucket-versioning --bucket softserve-demo3-asdfgh --versioning-configuration Status=Enabled
echo "bucket created"

kops create cluster \
--node-count=2 \
--node-size=t2.medium \
--zones=${region}a \
--name=${KOPS_CLUSTER_NAME}

kops update cluster --name ${KOPS_CLUSTER_NAME} --yes


echo "cluster created"


kubectl config get-contexts
kubectl config use-context CONTEXT_NAME

kops edit ig nodes --name ${KOPS_CLUSTER_NAME}

kops get ig


kops update cluster --yes
kops rolling-update cluster