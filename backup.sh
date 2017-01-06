#!/bin/bash -x

usage() {
cat << EOF
usage: $0 options

Backup your Database Pod

OPTIONS:
   -h | --help      Show this message
   -n      Namespace
   -k      Azure Storage Account Key
   -c      Azure Storage Account Container
   -a      Azure Storage Account Name
   -l      Location (AZURE or AWS)
   -w      AWS S3 Access Key
   -s      AWS S3 Secret Key 
   -r      AWS S3 Default Region
   -b      AWS S3 Bucket Name 
EOF
}

backup() {

  if [ $# -eq 1 ]; then
    oc create -f - <<EOF
    #cat <<EOF
apiVersion: v1
kind: Pod
metadata:
  generateName: backup-$1
  labels:
    role: backup
spec:
  containers:
  - image: juniorjbn/backup:wip-joao
    imagePullPolicy: Always
    name: backup
    volumeMounts:
    - name: empty
      mountPath: /data
    env:
      - name: AZURE_KEY
        value: ${AZURE_KEY}
      - name: AZURE_NAME
        value: ${AZURE_NAME}
      - name: NAMESPACE
        value: $1
      - name: LOCATION
        value: ${LOCATION}
      - name: AWS_S3_KEY
        value: ${AWS_S3_KEY}
      - name: AWS_S3_SECRET
        value: ${AWS_S3_SECRET}
      - name: AWS_S3_REGION
        value: ${AWS_S3_REGION}
      - name: AWS_S3_BUCKET
        value: ${AWS_S3_BUCKET}
  dnsPolicy: ClusterFirst
  restartPolicy: Never
  volumes:
  - name: empty
    emptyDir: {}
EOF
fi
}

while :
do
  case $1 in
    -h | --help | -\?)
      usage
      exit 0
      ;;
    -n)
      NAMESPACE=$2
      shift 2
      ;;
    -k)
      AZURE_KEY=$2
      shift 2
      ;;
    -c)
      AZURE_CONTAINER=$2
      shift 2
      ;;
    -a)
      AZURE_NAME=$2
      shift 2
      ;;      
    -l)
      LOCATION=$2
      shift 2
      ;;
    -w)
      AWS_S3_KEY=$2
      shift 2
      ;;
    -s)
      AWS_S3_SECRET=$2
      shift 2
      ;;
    -r)
      AWS_S3_REGION=$2
      shift 2
      ;;
    -b)
      AWS_S3_BUCKET=$2
      shift 2
      ;;
    *)
      break
      ;;
  esac
done

if [ -z "$LOCATION" ]; then
    echo "ERROR: I need a location to store your backup! See --help"
    exit 1
fi

#if [ -z "$AZURE_KEY" -o -z "$AZURE_CONTAINER" -o -z "$AZURE_NAME" ]; then
#    echo "ERROR: I need the azure credentials! See --help"
#    exit 1
#fi

if [ -z "$AWS_S3_KEY" -o -z "$AWS_S3_SECRET" -o -z "$AWS_S3_REGION" -o -z "$AWS_S3_BUCKET" ]; then
    echo "ERROR: I need the AWS credentials! See --help"
    exit 1
fi

backup ${NAMESPACE}