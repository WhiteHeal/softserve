How to create k8s cluster on ec2

    pip install awscli --upgrade --user
    
    curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
    chmod +x kops-linux-amd64
    sudo mv kops-linux-amd64 /usr/local/bin/kops
    
    # kops version: 1.9.0
   
Configure the AWS CLI:
    
    aws configure
    
    AWS Access Key ID [None]: AccessKeyValue
    AWS Secret Access Key [None]: SecretAccessKeyValue
    Default region name [None]: us-east-1
    Default output format [None]:
    
Create an AWS S3 bucket for kops to persist its state    

    bucket_name=imesh-kops-state-store
    aws s3api create-bucket \
    --bucket ${bucket_name} \
    --region us-east-1
    
Enable versioning for the above S3 bucket

    aws s3api put-bucket-versioning --bucket ${bucket_name} --versioning-configuration Status=Enabled
    
Provide a name for the Kubernetes cluster and set the S3 bucket URL in the following environment variables:

    export KOPS_CLUSTER_NAME=imesh.k8s.local
    export KOPS_STATE_STORE=s3://${bucket_name}
    
Create a Kubernetes cluster definition using kops:

    kops create cluster \
    --node-count=2 \
    --node-size=t2.medium \
    --zones=us-east-1a \
    --name=${KOPS_CLUSTER_NAME}
    
    
    export AWS_ACCESS_KEY=AccessKeyValue
    export AWS_SECRET_KEY=SecretAccessKeyValue


Review the Kubernetes cluster definition

    kops edit cluster --name ${KOPS_CLUSTER_NAME}
    
    kops update cluster --name ${KOPS_CLUSTER_NAME} --yes
    kops validate cluster
    
Now, you may need to deploy the Kubernetes dashboard to access the cluster via its web based user interface

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
    
    kops get secrets kube --type secret -oplaintext
    
    kubectl cluster-info
    
    kops get secrets admin --type secret -oplaintext
    
    
useful command

    kubectl config get-contexts
    kubectl config use-context CONTEXT_NAME
    
    kops edit ig nodes --name ${KOPS_CLUSTER_NAME}
    
    kops get ig
    
    
    kops update cluster --yes
    kops rolling-update cluster --cloudonly
    
    
