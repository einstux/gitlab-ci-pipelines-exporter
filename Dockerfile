##
# BUILD CONTAINER
##

FROM alpine:3.23@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 as certs

RUN \
apk add --no-cache ca-certificates

##
# RELEASE CONTAINER
##

FROM busybox:1.37-glibc@sha256:3f9777e7e82e8591542f72b965ec7db7e8b3bdb59692976af1bb9b2850b05a4e

WORKDIR /

COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ARG TARGETPLATFORM
COPY ${TARGETPLATFORM}/gitlab-ci-pipelines-exporter /usr/local/bin/

# Run as nobody user
USER 65534

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/gitlab-ci-pipelines-exporter"]
CMD ["run"]
