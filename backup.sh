#!/bin/bash -x

usage() {
cat << EOF
usage: $0 options

Backup your Database Pod

OPTIONS:
   -h | --help      Show this message
   -n      Namespace
   -k      Storage Account Key
   -c      Storage Account Container
   -a      Storage Account Name
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
  - image: getupcloud/backup:v2
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
  dnsPolicy: ClusterFirst
  nodeSelector:
    role: infra
  restartPolicy: Never
  serviceAccount: image-pruner
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
    *)
      break
      ;;
  esac
done


if [ -z "$ENGINE" ]; then
    echo "ERROR: I need a engine do backup!. See --help"
    exit 1
fi

if [ -z "$AZURE_KEY" -o -z "AZURE_CONTAINER" -o -z "AZURE_NAME" ]; then
    echo "ERROR: I need the azure credentials! See --help"
    exit 1
fi

backup ${NAMESPACE}