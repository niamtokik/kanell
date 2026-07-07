/// Copyright (c) 2026 Mathieu Kerjouan
import 'package:kanell/kanell.dart';
import 'package:test/test.dart';

void main() {
  simple_test();
}

void simple_test() {
  group('simple test', () {
    test('empty pipeline', () {
      // create a new pipeline
      var pipeline = Pipeline();

      // create a new flow
      Flow flow = Flow(data: 0);
      print("debug: ${flow.data}");

      // execute the pipeline
      var result = pipeline.apply(flow);
      expect(result.status, equals(Status.ok));
      expect(result.data, equals(0));
    });

    // a pipeline is a simple way to connect input
    // and output of functions, passing a common
    // data-structure.
    test('create a simple pipeline', () {
      // creat a new pipeline
      var pipeline = Pipeline();

      // add new pipes
      pipeline.add(_increment);
      pipeline.add(_increment);
      pipeline.add(_increment);

      // create the flow
      Flow flow = Flow(data: 0);

      // execute the pipeline
      var result = pipeline.apply(flow);
      expect(result.data, equals(3));
    });

    // a pipe can stop an execution for any kind
    // of reasons.
    test('stop an execution', () {
      var pipeline = Pipeline();
      pipeline.add((Flow flow) {
        return flow.stop();
      });
      Flow flow = Flow(data: 0);
      var result = pipeline.apply(flow);
      expect(result.status, equals(Status.stop));
    });

    // a pipe can fail for some unexpected reason.
    // in this case, it should not crash the whole
    // software, but return the final state of the
    // exception and let the user deal with it.
    test('catch an exception', () {
      var pipeline = Pipeline();
      pipeline.add((Flow flow) {
        throw "error";
        return flow;
      });
      Flow flow = Flow(data: 0);
      var result = pipeline.apply(flow);
      expect(result.status, equals(Status.exception));
    });

    // A pipe can generate an error with a reason.
    test('generate an error', () {
      var pipeline = Pipeline();
      pipeline.add((Flow flow) {
        return flow.error(reason: "bad args");
      });

      Flow flow = Flow(data: 0);
      var result = pipeline.apply(flow);
      expect(result.status, equals(Status.error));
      expect(result.reason, equals("bad args"));
    });
  });
}

void advanced_test() {
  group('advanced_test', () {
    test('debugging pipeline', () {
      // TODO
      // var pipeline = kanell.Pipeline.debug();
      var pipeline = Pipeline();
      pipeline.add(_increment);
      pipeline.add(_decrement);

      Flow flow = Flow(data: 0);
      var result = pipeline.apply(flow);
      expect(result.data, equals(0));
    });
  });
}

/*

Flow flow = Flow();

void expert_test() {
  group('expert pipeline', () {
    test('expert pipeline', () {
      var pipeline = kanell.Pipeline();
      // switch in debug mode
      pipeline.add((Flow flow) => flow.debug());
      // introspection
      pipeline.add(kanell.introspection); 
    });
  });
}

*/

Flow _increment(Flow flow) {
  flow.data += 1;
  return flow;
}

Flow _decrement(Flow flow) {
  flow.data -= 1;
  return flow;
}
