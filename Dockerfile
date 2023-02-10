FROM rust:1.67.1-bullseye@sha256:02a53e734724bef4a58d856c694f826aa9e7ea84353516b76d9a6d241e9da60e as build

# renovate: datasource=github-tags depName=nextcloud/notify_push versioning=semver
ENV NOTIFY_PUSH_VERSION v0.5.2

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
