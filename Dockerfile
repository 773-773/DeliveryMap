# ベース：軽量 Alpine Linux
FROM alpine:3.18

WORKDIR /app

# 必要パッケージ
RUN apk add --no-cache wget unzip bash ca-certificates

# PocketBase の安定版
ARG PB_VERSION=0.24.4
ENV PB_FILE=pocketbase_${PB_VERSION}_linux_amd64.zip

RUN wget -O pocketbase.zip "https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/${PB_FILE}" \
    && unzip pocketbase.zip -d . \
    && rm pocketbase.zip \
    && chmod +x /app/pocketbase

# 公開フォルダ
COPY pb_public /app/pb_public

# メールテンプレート（hooks）
COPY pb_hooks /app/pb_hooks
RUN chmod -R 755 /app/pb_hooks

# start.sh をコピー
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# PocketBase データ永続化
VOLUME /app/pb_data

EXPOSE 8080

# start.sh で PocketBase 起動
ENTRYPOINT ["sh", "/app/start.sh"]
