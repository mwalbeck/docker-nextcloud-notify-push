FROM ekidd/rust-musl-builder:1.57.0@sha256:eacf3ecaec9b24bddd9b9127cadae268eeb88d5cd875c12297a35fc5bcd957da as build

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
