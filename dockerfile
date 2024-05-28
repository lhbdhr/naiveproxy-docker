FROM golang:alpine as build

WORKDIR /naiveproxy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest && \
    xcaddy build \
    --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive \
    --with github.com/caddy-dns/cloudflare


FROM alpine:latest as run
COPY --from=build /naiveproxy/caddy /usr/local/bin/caddy
RUN apk add --no-cache ca-certificates

EXPOSE 80 443
CMD ["/usr/local/bin/caddy", "run", "--environ", "--config", "/etc/caddy/Caddyfile"]
