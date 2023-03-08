FROM golang:1.19.2 as builder
WORKDIR /app
RUN go mod init hello
COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /hello

FROM gcr.io/distroless/base-debian11
WORKDIR /
COPY --from=builder /hello /hello
ENV PORT 8080
ENV ENVIRONMENT e2e
USER nonroot:nonroot
CMD ["/hello"]