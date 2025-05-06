FROM rust:1.86.0-bullseye@sha256:f40b8cc3195deda321031e8dfe23c7d2586e3db7c4103fa36946982d9fd6d588 as build

# renovate: datasource=github-tags depName=nextcloud/notify_push versioning=semver
ENV NOTIFY_PUSH_VERSION v1.0.0

WORKDIR /notify_push

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        musl-dev \
        musl-tools \
    ; \
    git clone --branch $NOTIFY_PUSH_VERSION https://github.com/nextcloud/notify_push.git .; \
    rustup target add x86_64-unknown-linux-musl; \
    cargo build --release --target=x86_64-unknown-linux-musl;

FROM scratch

COPY --from=build /notify_push/target/x86_64-unknown-linux-musl/release/notify_push /

EXPOSE 7867

USER 33

CMD ["/notify_push", "/config/config.php"]
