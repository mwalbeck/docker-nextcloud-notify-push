FROM ekidd/rust-musl-builder:1.50.0 as build

# renovate: datasource=github-tags depName=nextcloud/notify_push versioning=semver
ENV NOTIFY_PUSH_VERSION v0.1.6

RUN set -ex; \
    git clone --branch $NOTIFY_PUSH_VERSION https://github.com/nextcloud/notify_push.git .; \
    cargo build --release --target=x86_64-unknown-linux-musl;

FROM scratch

COPY --from=build /home/rust/src/target/x86_64-unknown-linux-musl/release/notify_push /

EXPOSE 7867

USER 605

CMD ["/notify_push"]
