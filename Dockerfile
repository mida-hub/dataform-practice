FROM --platform=linux/x86_64 node:20-bookworm-slim

RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
    vim \
    jq \
    python3 \
    python3-pip \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

WORKDIR /usr/app/dataform

RUN npm i -g @dataform/cli@3.0.41
RUN pip3 install sqlfluff==3.5.0 --break-system-packages

# 設定ファイルのコピー先を node ユーザーのホームディレクトリに変更
# 所有者を node:node に設定
COPY --chown=node:node ./settings.json /home/node/.dataform/settings.json
COPY --chown=node:node ./.df-credentials.json /usr/app/dataform/.df-credentials.json

# プロジェクトファイルのコピー
COPY --chown=node:node ./definitions /usr/app/dataform/definitions
COPY --chown=node:node ./includes /usr/app/dataform/includes
COPY --chown=node:node ./workflow_settings.yaml /usr/app/dataform/workflow_settings.yaml
RUN mkdir -p /home/node/.config/gcloud && chown -R node:node /home/node/.config

# ユーザーを切り替え
USER node

ENTRYPOINT ["tail", "-f", "/dev/null"]
