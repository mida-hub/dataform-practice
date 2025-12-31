FROM --platform=linux/x86_64 node:20-bookworm-slim

RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
    vim \
    jq \
    curl \
    gnupg \
    apt-transport-https \
    ca-certificates \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
  && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
  && apt-get update \
  && apt-get install -y google-cloud-cli \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

WORKDIR /usr/app/dataform

RUN npm i -g snowflake-sdk@1.14.0 @dataform/cli@2.6.0

COPY ./definitions /usr/app/dataform/definitions
COPY ./includes /usr/app/dataform/includes
COPY ./dataform.json /usr/app/dataform/dataform.json
COPY ./package.json /usr/app/dataform/package.json
COPY ./package-lock.json /usr/app/dataform/package-lock.json

COPY ./settings.json /root/.dataform/settings.json
COPY ./.df-credentials.json /usr/app/dataform/.df-credentials.json

RUN dataform install .

ENTRYPOINT ["tail", "-f", "/dev/null"]
