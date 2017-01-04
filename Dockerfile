FROM openshift/origin

MAINTAINER Diego Castro <diego.castro@getupcloud.com>

ENV HOME=/data \
    KUBECONFIG=/data/.kubeconfig \
    WRITE_KUBECONFIG=1

RUN INSTALL_PKGS="nodejs npm telnet" && \
    yum install -y epel-release && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    yum clean all -y

RUN mkdir -p ${HOME} && chmod 777 ${HOME}

ADD root /

ENV CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts \
#ENABLED_COLLECTIONS=""

#ENV BASH_ENV=${CONTAINER_SCRIPTS_PATH}/scl_enable \
#    ENV=${CONTAINER_SCRIPTS_PATH}/scl_enable \
#    PROMPT_COMMAND=". ${CONTAINER_SCRIPTS_PATH}/scl_enable"

VOLUME ${HOME}

RUN npm install -g azure-cli

USER 1000

ENTRYPOINT ["container-entrypoint"]
CMD ["run"]
