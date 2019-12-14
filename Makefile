build:
	docker run --rm -v "${PWD}":/go/src/helloworld -w /go/src/helloworld -e CGO_ENABLED=0 golang:1.8 go build

docker-image: build
	docker build -t abeeralhussaini20/helloworld .
