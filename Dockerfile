FROM rust:1.88.0-bullseye@sha256:3f1357462f45bc05d87b57947b58f7643250f1bff197c3e8cdaf764430f74f5a as build

# renovate: datasource=github-tags depName=nextcloud/notify_push versioning=semver
ENV NOTIFY_PUSH_VERSION v1.1.0

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
