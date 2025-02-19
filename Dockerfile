FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y expect curl jq

# Install Huawei Cloud CLI
RUN curl -sSL https://ap-southeast-3-hwcloudcli.obs.ap-southeast-3.myhuaweicloud.com/cli/latest/hcloud_install.sh -o ./hcloud_install.sh && bash ./hcloud_install.sh -y

# Copy script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
