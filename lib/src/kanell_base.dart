/// Copyright (c) 2026 Mathieu Kerjouan
///
/// Yet Another Pipeline-library for Dart
///
/// This module was designed to support different
/// kind of pipelines, from simple one to more
/// complex construction.
///
/// TODO: pipeline switcher, a pipe can switch to
///       another pipeline
///
/// TODO: named pipeline, a pipeline can be dynamically
///       created using named pipeline, they can be
///       plugged and can also return the next pipe
///       or pipeline to use based on the input

/// A pipeline can be set in different status,
/// these status are stored directly
enum Status {
  ok,
  error,
  exception,
  stop,
  ignore
}

/// A pipeline is a list of pipes. Each pipe is 
/// executed linearily.
class Pipeline {
  List<Function(Flow)> pipes = [];
  Pipeline();

  Pipeline add(Function(Flow) pipe) {
    pipes.add(pipe);
    return this;
  }

  Flow apply(Flow data) {
    dynamic flow = data;
    for (var f in pipes) {
      try {
        flow = f(flow);
        switch (flow) {
          case _ when flow.status == Status.ok:
            continue;
          case _ when flow.status == Status.stop:
            break;
          case _ when flow.status == Status.error:
            break;
          default:
            continue;
        }
      }
      catch (e,s) {
        return _exception(e, s, flow);
      }
    }
    return flow;
  }

  _exception(exception, stacktrace, Flow flow) {
    flow.status = Status.exception;
    flow.stacktrace = stacktrace;
    return flow;
  }
}

/// A pipe is the main element of a pipeline. Every
/// pipes are accepting a flow and will deal with them
/// depending on their input or output.
class Pipe {
  static Flow apply(Flow flow) {
    return flow;
  }
}

/// a flow is the object encapsulating the user 
/// data, routed by the pipeline.
class Flow {
  Status status = Status.ok;
  dynamic data;
  dynamic? args;

  // timestamp every steps.
  bool timestamp = false;

  // when set, every time the flow is executed,
  // information printed.
  bool debug = false;

  // TODO: tracing capabilities, after every call
  //       of the pipeline, the input/output is
  //       stored in a list to trace. This can be
  //       costly and we should give an interface
  //       to export this data somewhere else.
  // bool trace = false;
  // List<Flow> tracing = const [];

  // TODO: store the stacktrace if present.
  dynamic? reason;
  dynamic? stacktrace;

  // TODO: create toString() function

  // TODO: give the possibility to export the data
  //       to JSON or another format.

  // Constructor
  Flow({
    required dynamic data,
    Status status = Status.ok,
    dynamic? args,
    bool timestamp = false,
    bool debug = false,
  }) :
    this.data = data,
    this.status = status,
    this.args = args,
    this.timestamp = timestamp,
    this.debug = debug;

  Flow.debug({
    required dynamic data,
    Status status = Status.ok,
    dynamic? args,
  }) :
    this.data = data,
    this.status = status,
    this.args = args,
    this.timestamp = true,
    this.debug = true;

  Flow apply(Function f) {
    data = f(data);
    return this;
  }

  Flow error({dynamic? reason}) {
    this.status = Status.error;
    this.reason = reason;
    return this;
  }

  Flow stop({dynamic? reason}) {
    this.status = Status.stop;
    this.reason = reason;
    return this;
  }

}

/// An introspection function to show more
/// information about pipelines, pipes and
/// flows.
Flow introspection(Flow flow) {
  print(Flow);
  return flow;
}

/// Stop the pipeline
Flow stop(Flow flow) {
  flow.status = Status.stop;
  return flow;
}

/// Enable or disable timestamping
Flow timestamp(Flow flow) {
  flow.timestamp = flow.timestamp ? true : false;
  return flow;
}

/// Enable or disable debug mode
Flow debug(Flow flow) {
  flow.debug = flow.debug ? true : false;
  return flow;
}
