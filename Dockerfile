FROM golang:alpine as builder
RUN apk add --no-cache bash git
RUN go get github.com/bitly/oauth2_proxy
FROM alpine
LABEL com.oauth2_proxy=master
LABEL com.oauth2_proxy.build="Oleksandr Kuznetsov <oleks.kuznetsov@gmail.com>"
# Install CA certificates
RUN apk add --no-cache --virtual=build-dependencies ca-certificates
RUN adduser -S -D -H -h /app appuser
USER appuser
COPY --from=builder /go/bin/oauth2_proxy /app/
WORKDIR /app
# Expose the ports we need and setup the ENTRYPOINT w/ the default argument
# to be pass in.
EXPOSE 8080 4180
ENTRYPOINT [ "./oauth2_proxy" ]
CMD [ "--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180" ]
