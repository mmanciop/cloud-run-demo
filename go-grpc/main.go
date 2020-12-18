package main

import (
	"context"
	"fmt"
	instana "github.com/instana/go-sensor"
	"github.com/instana/go-sensor/instrumentation/cloud.google.com/go/pubsub"
	"github.com/instana/go-sensor/instrumentation/instagrpc"
	"google.golang.org/grpc"
	"log"
	"net"
	"os"

	pb "github.com/instana/test-stacks/cloud-run/composite/go-grpc/helloworld"
)

type server struct {
	pb.UnimplementedGreeterServer
	client *pubsub.Client
}

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	log.Printf("Received: %v", in.GetName())

	topic := s.client.Topic(os.Getenv("PUBSUB_TOPIC"))
	ok, err := topic.Exists(ctx)
	if err != nil {
		log.Println("Error retrieving topic")

		return nil, err
	}

	if !ok {
		log.Println("Topic doesnt exist")

		return nil, err
	}

	topic.Publish(ctx, &pubsub.Message{
		Data: []byte("hello world"),
	})

	return &pb.HelloReply{Message: "Hello " + in.GetName()}, nil
}

func main() {
	instana.InitSensor(instana.DefaultOptions())
	sensor := instana.NewSensor("go-grpc")

	ctx := context.Background()
	pubsubClient, err := pubsub.NewClient(ctx, os.Getenv("GCP_PROJECT"), sensor)
	if err != nil {
		fmt.Errorf("Error initializing pubsub client %s", err)

		os.Exit(1)
	}

	log.Print("starting server...")

	// Determine port for HTTP service.
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
		log.Printf("defaulting to port %s", port)
	}

	log.Printf("listening on port %s", port)

	//Start gRPC Server
	ln, err := net.Listen("tcp", ":"+port)
	if err != nil {
		log.Fatal(err)
	}

	srv := grpc.NewServer(
		grpc.UnaryInterceptor(instagrpc.UnaryServerInterceptor(sensor)),
		grpc.StreamInterceptor(instagrpc.StreamServerInterceptor(sensor)),
	)
	pb.RegisterGreeterServer(srv, &server{
		client: pubsubClient,
	})
	if err := srv.Serve(ln); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
