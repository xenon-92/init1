# This dockerfile is similar to Dockerfile2.txt but has curl,bash nad jq installed in the runtime stage.
# BUILD STAGE

FROM golang:1.21 AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /init1


# RUNTIME STAGE and add curl, jq and bash
FROM alpine:latest
RUN apk add --update --no-cache curl jq bash
WORKDIR /root/
# Copy only the compiled binary from the builder stage
COPY --from=builder /init1 ./compiled/
CMD [ "./compiled/init1" ]