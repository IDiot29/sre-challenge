FROM golang:1.24-alpine AS builder
RUN apk update && apk add --no-cache git ca-certificates

WORKDIR /app
COPY src/ .
RUN go mod download
RUN go build -o /app/pixelpet

FROM alpine:3.20
WORKDIR /app
RUN apk add --no-cache curl
COPY --from=builder /app/pixelpet /app/pixelpet
EXPOSE 8080
ENTRYPOINT ["/app/pixelpet"]
