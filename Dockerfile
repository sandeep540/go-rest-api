FROM golang:1.17 as build-env

WORKDIR /go/src/app
COPY *.go .

RUN go mod init
RUN go get -d -v ./...
RUN go vet -v

RUN CGO_ENABLED=0 go build -o /go/bin/app

FROM gcr.io/distroless/static

COPY --from=build-env /go/bin/app /

ENV GIN_MODE=release                                                                                                      

EXPOSE 8080

CMD ["/app"]

# HEALTHCHECK CMD curl --fail http://localhost:8080/health || exit 1

# docker build -t rest-api .
# docker run -d -p 8000:8000 --name rest-api-container rest-api
