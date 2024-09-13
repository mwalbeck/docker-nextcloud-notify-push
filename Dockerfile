FROM rust:1.81.0-bullseye@sha256:8fae3b1a63a4dcfb6cf277a49fb5967ccbf479b9e9cee4588a077a9cb216e6d4 as build

# renovate: datasource=github-tags depName=nextcloud/notify_push versioning=semver
ENV NOTIFY_PUSH_VERSION v0.7.0

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
