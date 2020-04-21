FROM ubuntu:bionic-20200219

# Define applications versions to be installed
ARG TERRAFORM_VERSION="0.7.5"
ARG PACKER_VERSION="1.5.4"
ARG AWSCLI_VERSION="1.18.41"


LABEL terraform_version=${TERRAFORM_VERSION}
LABEL aws_cli_version=${AWSCLI_VERSION}

# Put defined applications versions as env. variables 
ENV DEBIAN_FRONTEND=noninteractive
ENV AWSCLI_VERSION=${AWSCLI_VERSION}
ENV TERRAFORM_VERSION=${TERRAFORM_VERSION}
ENV PACKER_VERSION=${PACKER_VERSION}

# Install defined applications versions
RUN apt-get update \
&& apt-get install -y ansible curl git rsync python3 python3-pip python3-boto unzip \
&& pip3 install --upgrade awscli==${AWSCLI_VERSION} \
&& curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& curl -LO https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
&& unzip '*.zip' -d /usr/local/bin \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* *.zip

# Keep container up (in that case for 2days)
CMD ["sleep", "2d"]