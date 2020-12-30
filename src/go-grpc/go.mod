module github.com/instana/test-stacks/cloud-run/composite/go-grpc

go 1.14

require (
	github.com/golang/protobuf v1.4.2
	github.com/instana/go-sensor v1.22.0
	github.com/instana/go-sensor/instrumentation/cloud.google.com/go v1.2.1
	github.com/instana/go-sensor/instrumentation/instagrpc v1.0.3
	google.golang.org/grpc v1.31.0
	google.golang.org/protobuf v1.25.0
)
