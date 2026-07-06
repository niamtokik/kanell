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
