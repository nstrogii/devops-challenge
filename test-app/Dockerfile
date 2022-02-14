FROM golang:1.17.7-alpine AS build

ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

WORKDIR /tmp/build

COPY . .

RUN go mod download

RUN go build ./cmd/ops-test-app


FROM alpine:3.9 

COPY --from=build /tmp/build/ops-test-app /app/

RUN adduser -D player && chown -R player:player /app/

USER player

CMD ["/app/ops-test-app"]
