# ================================
# 🚀 PocketBase 強制反映モード Dockerfile
# ================================

# ベース：軽量 Alpine Linux
FROM alpine:3.18

# 作業ディレクトリ
WORKDIR /app

# 必要パッケージをインストール
RUN apk add --no-cache wget unzip bash ca-certificates

# ✅ PocketBase の安定版を固定（必要なら最新版へ変更可能）
ARG PB_VERSION=0.24.4
ENV PB_FILE=pocketbase_${PB_VERSION}_linux_amd64.zip

# ✅ PocketBase 本体をダウンロードしてセットアップ
RUN wget -O pocketbase.zip "https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/${PB_FILE}" \
    && unzip pocketbase.zip -d . \
    && rm pocketbase.zip \
    && chmod +x /app/pocketbase

# ✅ 公開フォルダとフック（メールテンプレート）を含める
COPY pb_public /app/pb_public
COPY pb_hooks /app/pb_hooks
RUN chmod -R 755 /app/pb_hooks

# ✅ 永続ディスク設定（データ保存用）
VOLUME /app/pb_data

# ✅ ポート設定
EXPOSE 8080

# ✅ PocketBase を直接起動（hooksDir 強制）
ENTRYPOINT ["/app/pocketbase", "serve",
  "--http=0.0.0.0:8080",
  "--dir=/app/pb_data",
  "--publicDir=/app/pb_public",
  "--hooksDir=/app/pb_hooks"]
