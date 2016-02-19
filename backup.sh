#!/bin/bash -x

usage() {
cat << EOF
usage: $0 options

Backup your Database Pod

OPTIONS:
   -h | --help      Show this message
   -e      Engine (mysql|postgresql|mongodb)
   -k      Storage Account Key
   -c      Storage Account Container
   -a      Storage Account Name
EOF
}

backup() {

  if [ $# -eq 2 ]; then
    oc create -f - <<EOF
    #cat <<EOF
apiVersion: v1
kind: Pod
metadata:
  generateName: backup-${ENGINE}
spec:
  containers:
  - image: getupcloud/backup:latest
    imagePullPolicy: Always
    name: backup
    volumeMounts:
    - name: empty
      mountPath: /data
    env:
      - name: DB_HOST
        value: ${DB_HOST}
      - name: MYSQL_USER
        value: ${MYSQL_USER}
      - name: MYSQL_PASSWORD
        value: ${MYSQL_PASSWORD}
      - name: POSTGRESQL_USER
        value: ${POSTGRESQL_USER}
      - name: POSTGRESQL_PASSWORD
        value: ${POSTGRESQL_PASSWORD}
      - name: POSTGRESQL_DATABASE
        value: ${POSTGRESQL_DATABASE}
      - name: MONGODB_USER
        value: ${MONGODB_USER}
      - name: MONGODB_PASSWORD
        value: ${MONGODB_PASSWORD}
      - name: MONGODB_DATABASE
        value: ${MONGODB_DATABASE}
      - name: AZURE_KEY
        value: ${AZURE_KEY}
      - name: AZURE_NAME
        value: ${AZURE_NAME}
      - name: AZURE_NAME
        value: ${AZURE_NAME}        
      - name: POD
        value: $1
      - name: NAMESPACE
        value: $2
      - name: ENGINE
        value: ${ENGINE}
  dnsPolicy: ClusterFirst
  nodeSelector:
    role: infra
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
    -e)
      ENGINE=$2
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

case $ENGINE in
  mysql)
  unset pods || true
  pods=$(oc get pods -l name=mysql -o jsonpath --template='{.items[*].metadata.name}')
  if [ ! -z "$pods" ]; then
    for pod in $pods; do
      unset namespace DB_HOST MYSQL_PASSWORD MYSQL_USER || true
      eval export $(oc get pods $pod -n $namespace -o jsonpath \
        --template='namespace={..namespace} DB_HOST={.status.podIP} MYSQL_USER={.spec.containers[0].env[?(@.name=="MYSQL_USER")].value} MYSQL_PASSWORD={.spec.containers[0].env[?(@.name=="MYSQL_PASSWORD")].value}')
      backup $pod $namespace
    done
  else
    echo "No pods Found!"
  fi
  ;;
  postgresql)
  unset pods || true 
  pods=$(oc get pods -l name=postgresql -o jsonpath --template='{.items[*].metadata.name}')
  if [ ! -z "$pods" ]; then
    for pod in $pods; do
      unset namespace DB_HOST POSTGRESQL_USER POSTGRESQL_PASSWORD POSTGRESQL_DATABASE || true
      eval export $(oc get pods $pod -o jsonpath \
      --template='namespace={..namespace} DB_HOST={.status.podIP} POSTGRESQL_USER={.spec.containers[0].env[?(@.name=="POSTGRESQL_USER")].value} POSTGRESQL_PASSWORD={.spec.containers[0].env[?(@.name=="POSTGRESQL_PASSWORD")].value} POSTGRESQL_DATABASE={.spec.containers[0].env[?(@.name=="POSTGRESQL_DATABASE")].value}')
      backup $pod $namespace
    done
  else
    echo "No pods Found!"
  fi
  ;;
  mongodb)
  unset pods || true
  pods=$(oc get pods -l name=mongodb -o jsonpath --template='{.items[*].metadata.name}')
  if [ ! -z "$pods" ]; then
    for pod in $pods; do
      unset namespace DB_HOST MONGODB_USER MONGODB_PASSWORD MONGODB_DATABASE  || true
      eval export $(oc get pods $pod -o jsonpath \
        --template='namespace={..namespace} DB_HOST={.status.podIP} MONGODB_USER={.spec.containers[0].env[?(@.name=="MONGODB_USER")].value} MONGODB_PASSWORD={.spec.containers[0].env[?(@.name=="MONGODB_PASSWORD")].value} MONGODB_DATABASE={.spec.containers[0].env[?(@.name=="MONGODB_DATABASE")].value}')
      backup $pod $namespace
    done
  else
    echo "No pods Found!"
  fi
  ;;
esac