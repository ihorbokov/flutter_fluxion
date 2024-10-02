import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/fluxion_listener.dart';
import 'package:flutter_fluxion/src/multi_fluxion_listener.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common/fluxion_stub.dart';

void main() {
  group('MultiFluxionListener', () {
    testWidgets(
      'should build widget with no listeners',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: MultiFluxionListener(
              listeners: [],
              child: Text('Initial Child'),
            ),
          ),
        );

        expect(find.text('Initial Child'), findsOneWidget);
      },
    );

    testWidgets(
      'should build widget with a single listener',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MultiFluxionListener(
              listeners: [
                (child) {
                  return FluxionListener<TestIntFluxion, int>(
                    fluxion: TestIntFluxion(0),
                    listener: (_, __) {},
                    child: child,
                  );
                },
              ],
              child: const Text('Initial Child'),
            ),
          ),
        );

        expect(
          find.byType(FluxionListener<TestIntFluxion, int>),
          findsOneWidget,
        );
        expect(find.text('Initial Child'), findsOneWidget);
      },
    );

    testWidgets(
      'should build widget with multiple listeners in reverse order',
      (tester) async {
        final fluxion1 = TestIntFluxion(0);
        final fluxion2 = TestStringFluxion('initial');

        await tester.pumpWidget(
          MaterialApp(
            home: MultiFluxionListener(
              listeners: [
                (child) {
                  return FluxionListener<TestIntFluxion, int>(
                    fluxion: fluxion1,
                    listener: (_, __) {},
                    child: child,
                  );
                },
                (child) {
                  return FluxionListener<TestStringFluxion, String>(
                    fluxion: fluxion2,
                    listener: (_, __) {},
                    child: child,
                  );
                },
              ],
              child: const Text('Initial Child'),
            ),
          ),
        );

        final listenerFinder1 = find.byWidgetPredicate(
          (widget) =>
              widget is FluxionListener<TestIntFluxion, int> &&
              widget.fluxion == fluxion1,
        );

        final listenerFinder2 = find.byWidgetPredicate(
          (widget) =>
              widget is FluxionListener<TestStringFluxion, String> &&
              widget.fluxion == fluxion2,
        );

        expect(listenerFinder1, findsOneWidget);
        expect(listenerFinder2, findsOneWidget);

        final listener1Widget =
            tester.widget<FluxionListener<TestIntFluxion, int>>(
          listenerFinder1,
        );
        expect(
          listener1Widget.child,
          isInstanceOf<FluxionListener<TestStringFluxion, String>>(),
        );

        final listener2Widget =
            tester.widget<FluxionListener<TestStringFluxion, String>>(
          listenerFinder2,
        );
        expect(listener2Widget.child, isInstanceOf<Text>());
      },
    );

    testWidgets(
      'should build widget with nested structure when listeners are applied',
      (tester) async {
        final fluxion1 = TestIntFluxion(0);
        final fluxion2 = TestStringFluxion('initial');

        await tester.pumpWidget(
          MaterialApp(
            home: MultiFluxionListener(
              listeners: [
                (child) {
                  return FluxionListener<TestIntFluxion, int>(
                    fluxion: fluxion1,
                    listener: (_, __) {},
                    child: child,
                  );
                },
                (child) {
                  return FluxionListener<TestStringFluxion, String>(
                    fluxion: fluxion2,
                    listener: (_, __) {},
                    child: child,
                  );
                },
              ],
              child: const Text('Initial Child'),
            ),
          ),
        );

        final listenerFinder1 = find.byWidgetPredicate(
          (widget) =>
              widget is FluxionListener<TestIntFluxion, int> &&
              widget.fluxion == fluxion1,
        );

        final listenerFinder2 = find.byWidgetPredicate(
          (widget) =>
              widget is FluxionListener<TestStringFluxion, String> &&
              widget.fluxion == fluxion2,
        );

        expect(listenerFinder1, findsOneWidget);
        expect(listenerFinder2, findsOneWidget);

        final listener1Widget =
            tester.widget<FluxionListener<TestIntFluxion, int>>(
          listenerFinder1,
        );

        final listener2Widget = listener1Widget.child
            as FluxionListener<TestStringFluxion, String>?;

        final listener2WidgetChild = listener2Widget?.child;
        expect(listener2WidgetChild, isNotNull);
        expect(listener2WidgetChild, isInstanceOf<Text>());
      },
    );
  });

  //todo: add more tests
}
