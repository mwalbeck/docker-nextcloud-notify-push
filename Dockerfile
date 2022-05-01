FROM ekidd/rust-musl-builder:1.57.0@sha256:c18dbd9fcf3a4c0c66b8aacea5cf977ee38193efd7e98a55ee7bf9cd9954b221 as build

# renovate: datasource=github-tags depName=nextcloud/notify_push versioning=semver
ENV NOTIFY_PUSH_VERSION v0.4.0

RUN set -ex; \
    git clone --branch $NOTIFY_PUSH_VERSION https://github.com/nextcloud/notify_push.git .; \
    cargo build --release --target=x86_64-unknown-linux-musl;

FROM scratch

COPY --from=build /home/rust/src/target/x86_64-unknown-linux-musl/release/notify_push /

EXPOSE 7867

USER 33

CMD ["/notify_push", "/config/config.php"]
