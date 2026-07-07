# Kanell - Yet Another Pipeline-library for Dart

`kanell` (meaning pipeline in breton) is a pipeline-library for Dart with the
goal to make it simple, flexible, reusable and powerful. Its design is inspired
by [Erlang finite state
machines](https://www.erlang.org/doc/apps/stdlib/gen_statem.html) and [Elixir
Plugs](https://plug.hexdocs.pm/readme.html).

## Features

 - [x] synchronous pipeline

 - [ ] asynchronous pipeline

 - [ ] dynamic routing pipeline

 - [x] pipe status

 - [ ] named pipeline

 - [ ] benchmark mode

 - [ ] debug mode

 - [ ] tracing mode

## Getting started

A small function with a well defined data-structure is the way. Let imagine you
want to create, sanitize and validate some HTTP client requests.

```dart
class Request {
  String method = "GET";
  Map<String, String> headers = {};
  Uri url = Uri.parse("https://dart.org");
  Map<String, dynamic> query = {};
  String? body;

  Request({
    required Uri url,
    String method = "GET",
    Map<String, String> headers = const {},
    Map<String, dynamic> query = const {},
    String? body
  });

  String toString() => "url: ${url}, method: ${method}, headers: ${headers}, query: ${query}";
}
```

```dart
// create a new pipeline
var pipeline = Pipeline();

// check the method
pipeline.add((Flow flow) {
  switch (flow.data.method) {
    case "GET":
      // return flow.next("GET");
      return flow;
    case "POST":
      return flow;
    case "PUT":
      return flow;
    case "OPTIONS":
      return flow;
    case "DELETE":
      return flow;
    case "QUERY": 
      return flow.error(reason: "QUERY request is not supported yet");
    default:
      return flow.error(reason: "unsupported");
  }
});

// check some headers
pipeline.add((Flow flow) {
  if (flow.data.headers['accept'] == null) {
    flow.data.headers['accept'] = "*/*";
  }

  if flow.data.headers['user-agent'] == null {
    flow.data.headers['user-agent'] = "my custom agent"
  }

  return flow
});

// create our initial flow with a default request
Flow flow = Flow(data: Request());

// start the pipeline
Flow result = pipeline.apply(flow);
```

## Usage

```dart
```

## Examples

```dart
```

## Additional information

This project is in active development and should not be used in production yet.

## References and Resources

TODO
