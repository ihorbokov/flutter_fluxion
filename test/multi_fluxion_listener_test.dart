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
              child: Placeholder(),
            ),
          ),
        );

        expect(find.byType(Placeholder), findsOneWidget);
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
              child: const Placeholder(),
            ),
          ),
        );

        expect(
          find.byType(FluxionListener<TestIntFluxion, int>),
          findsOneWidget,
        );
        expect(find.byType(Placeholder), findsOneWidget);
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
              child: const Placeholder(),
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
        expect(listener2Widget.child, isInstanceOf<Placeholder>());
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
              child: const Placeholder(),
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
        expect(listener2WidgetChild, isInstanceOf<Placeholder>());
      },
    );

    testWidgets(
      'executes listeners on state change',
      (tester) async {
        final fluxion1 = TestIntFluxion(0);
        final fluxion2 = TestStringFluxion('initial');

        var listener1Called = false;
        var listener2Called = false;
        var listener3Called = false;

        var listener1State = fluxion1.state;
        var listener2State = fluxion1.state;
        var listener3State = fluxion2.state;

        await tester.pumpWidget(
          MaterialApp(
            home: MultiFluxionListener(
              listeners: [
                (child) {
                  return FluxionListener<TestIntFluxion, int>(
                    fluxion: fluxion1,
                    listener: (_, state) {
                      listener1Called = true;
                      listener1State = state;
                    },
                    child: child,
                  );
                },
                (child) {
                  return FluxionListener<TestIntFluxion, int>(
                    fluxion: fluxion1,
                    listener: (_, state) {
                      listener2Called = true;
                      listener2State = state;
                    },
                    child: child,
                  );
                },
                (child) {
                  return FluxionListener<TestStringFluxion, String>(
                    fluxion: fluxion2,
                    listener: (_, state) {
                      listener3Called = true;
                      listener3State = state;
                    },
                    child: child,
                  );
                },
              ],
              child: const Placeholder(),
            ),
          ),
        );

        fluxion1.update(1);
        fluxion2.update('updated');
        await tester.pumpAndSettle();

        expect(listener1Called, isTrue);
        expect(listener2Called, isTrue);
        expect(listener3Called, isTrue);

        expect(listener1State, 1);
        expect(listener2State, 1);
        expect(listener3State, 'updated');
      },
    );

    testWidgets(
      'does not execute listeners if listenWhen returns false',
      (tester) async {
        final fluxion = TestIntFluxion(0);

        var listenerCalled = false;
        var currentState = -1;
        var previousState = -2;

        await tester.pumpWidget(
          MaterialApp(
            home: MultiFluxionListener(
              listeners: [
                (child) {
                  return FluxionListener<TestIntFluxion, int>(
                    fluxion: fluxion,
                    listener: (_, __) => listenerCalled = true,
                    listenWhen: (previous, current) {
                      currentState = current;
                      previousState = previous;
                      return false;
                    },
                    child: child,
                  );
                },
              ],
              child: const Placeholder(),
            ),
          ),
        );

        fluxion.update(1);
        await tester.pumpAndSettle();

        expect(listenerCalled, isFalse);
        expect(currentState, 1);
        expect(previousState, 0);
      },
    );

    testWidgets(
      'executes listeners if listenWhen returns true',
      (tester) async {
        final fluxion = TestIntFluxion(0);

        var listenerCalled = false;
        var listenerState = fluxion.state;
        var currentState = -2;
        var previousState = -3;

        await tester.pumpWidget(
          MaterialApp(
            home: MultiFluxionListener(
              listeners: [
                (child) {
                  return FluxionListener<TestIntFluxion, int>(
                    fluxion: fluxion,
                    listener: (_, state) {
                      listenerCalled = true;
                      listenerState = state;
                    },
                    listenWhen: (previous, current) {
                      currentState = current;
                      previousState = previous;
                      return true;
                    },
                    child: child,
                  );
                },
              ],
              child: const Placeholder(),
            ),
          ),
        );

        fluxion.update(1);
        await tester.pumpAndSettle();

        expect(listenerCalled, isTrue);
        expect(listenerState, 1);
        expect(currentState, 1);
        expect(previousState, 0);
      },
    );

    testWidgets(
      'child widget does not rebuild on state change',
      (tester) async {
        final fluxion = TestIntFluxion(0);

        var buildCount = 0;
        var listenerCalled = false;
        var listenerState = fluxion.state;

        await tester.pumpWidget(
          MaterialApp(
            home: MultiFluxionListener(
              listeners: [
                (child) {
                  return FluxionListener<TestIntFluxion, int>(
                    fluxion: fluxion,
                    listener: (_, state) {
                      listenerCalled = true;
                      listenerState = state;
                    },
                    child: child,
                  );
                },
              ],
              child: Builder(
                builder: (_) {
                  buildCount++;
                  return const Placeholder();
                },
              ),
            ),
          ),
        );

        expect(buildCount, 1);

        fluxion.update(1);
        await tester.pumpAndSettle();

        expect(buildCount, 1);
        expect(listenerCalled, isTrue);
        expect(listenerState, 1);
      },
    );
  });
}
