# Proto Definitions for Greeter Service

```shell script
go get google.golang.org/protobuf/cmd/protoc-gen-go \
     google.golang.org/grpc/cmd/protoc-gen-go-grpc
export PATH="$PATH:$(go env GOPATH)/bin"
```

```shell script
npm install -g grpc-tools
```

Run the proto compiler for go:

```shell script
protoc --go_out=plugins=grpc:../go-grpc/helloworld \
  --go_opt=paths=source_relative \
  helloworld.proto
```

Run the proto compiler for JS:

```shell script
protoc --js_out="import_style=commonjs,binary:../nodejs-web" \
  --grpc_out=../nodejs-web \
  --plugin=protoc-gen-grpc=`which grpc_tools_node_protoc_plugin` \
  helloworld.proto
```
