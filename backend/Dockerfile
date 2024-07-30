# Step 1
FROM golang:1.22-alpine3.19 as builder

WORKDIR /usr/src/

COPY . .

RUN go mod download && go mod verify

#RUN go build -o ./app .
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o ./app .

#RUN apk add --no-cache ca-certificates

# Step 2

FROM scratch

#RUN rm -rf /var/tmp/* /tmp/* /var/cache/apk/*

COPY --from=builder /usr/src/app /usr/local/bin/

#COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 8080

#USER nobody:nobody

ENTRYPOINT ["app"]
