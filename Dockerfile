# ベース：軽量 Alpine Linux
FROM alpine:3.18

# 作業ディレクトリ
WORKDIR /app

# 必要パッケージ
RUN apk add --no-cache wget unzip bash ca-certificates

# PocketBase バージョン
ARG PB_VERSION=0.24.4
ENV PB_FILE=pocketbase_${PB_VERSION}_linux_amd64.zip

# PocketBase 本体ダウンロード
RUN wget -O pocketbase.zip "https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/${PB_FILE}" \
    && unzip pocketbase.zip -d . \
    && rm pocketbase.zip \
    && chmod +x /app/pocketbase

# 公開フォルダと Hooks をコピー
COPY pb_public /app/pb_public
COPY pb_hooks  /app/pb_hooks

# start.sh をコピー
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# パーミッション
RUN chmod -R 755 /app/pb_hooks

# 永続データ
VOLUME /app/pb_data

# ポート
EXPOSE 8080

# 起動
ENTRYPOINT ["/app/start.sh"]
