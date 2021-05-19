FROM ubuntu:18.04

# Install pacakges
RUN apt-get update
RUN apt-get -y install wget

# Install ansible
RUN apt-get -y install ansible

# Install terraform
RUN wget https://releases.hashicorp.com/terraform/0.15.3/terraform_0.15.3_linux_amd64.zip
RUN unzip terraform_0.15.3_linux_amd64.zip -d /opt/terraform
WORKDIR /opt/terraform
RUN cp terraform /bin

# Install aws
ENV AWS_DEFAULT_REGION='[your region]'
ENV AWS_ACCESS_KEY_ID='[your access key id]'
ENV AWS_SECRET_ACCESS_KEY='[your secret]'
RUN apt-get -y install awscli

# Clear cache
RUN apt-get clean
