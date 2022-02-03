FROM ekidd/rust-musl-builder:1.57.0@sha256:b90fcece4e1ab9c06e4b89d365c0c03cd495d88c400f270c21e90f3ef7f59cfc as build

# renovate: datasource=github-tags depName=nextcloud/notify_push versioning=semver
ENV NOTIFY_PUSH_VERSION v0.3.0

RUN set -ex; \
    git clone --branch $NOTIFY_PUSH_VERSION https://github.com/nextcloud/notify_push.git .; \
    cargo build --release --target=x86_64-unknown-linux-musl;

FROM scratch

COPY --from=build /home/rust/src/target/x86_64-unknown-linux-musl/release/notify_push /

EXPOSE 7867

USER 33

CMD ["/notify_push", "/config/config.php"]
