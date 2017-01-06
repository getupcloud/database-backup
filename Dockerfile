FROM openshift/origin

MAINTAINER Diego Castro <diego.castro@getupcloud.com>

ENV HOME=/data \
    KUBECONFIG=/data/.kubeconfig \
    WRITE_KUBECONFIG=1 \
    CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts

RUN mkdir -p ${HOME} && \
    chmod 777 ${HOME} && \
    INSTALL_PKGS="nodejs npm telnet" && \
    yum install -y epel-release && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    yum clean all -y && \
    npm install -g azure-cli && \
    npm cache clean

#Install AWSCLI
RUN cd /tmp && curl -O https://bootstrap.pypa.io/get-pip.py && python get-pip.py && pip install awscli

ADD root /

VOLUME ${HOME}

USER 1000

CMD ["run_aws"]
