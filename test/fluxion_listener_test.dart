import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/fluxion_listener.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'common/fluxion_stub.dart';

void main() {
  group('FluxionListener', () {
    testWidgets(
      'initializes state correctly',
      (tester) async {
        final fluxion1 = TestIntFluxion(0);
        final fluxion2 = TestIntFluxion(1);

        var listenerCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionListener<TestIntFluxion, int>(
              fluxion: fluxion1,
              listener: (_, __) => listenerCalled = true,
              child: Text('State: ${fluxion1.state}'),
            ),
          ),
        );

        expect(find.text('State: 0'), findsOneWidget);
        expect(listenerCalled, isFalse);

        await tester.pumpWidget(
          Provider.value(
            value: fluxion2,
            child: MaterialApp(
              home: FluxionListener<TestIntFluxion, int>(
                listener: (_, __) => listenerCalled = true,
                child: Text('State: ${fluxion2.state}'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('State: 1'), findsOneWidget);
        expect(listenerCalled, isFalse);
      },
    );

    testWidgets(
      'executes listener on state change',
      (tester) async {
        final fluxion = TestIntFluxion(0);

        var listenerCalled = false;
        var listenerState = -1;

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionListener<TestIntFluxion, int>(
              fluxion: fluxion,
              listener: (_, state) {
                listenerCalled = true;
                listenerState = state;
              },
              child: const Placeholder(),
            ),
          ),
        );

        fluxion.update(1);
        await tester.pumpAndSettle();

        expect(listenerCalled, isTrue);
        expect(listenerState, 1);
      },
    );

    testWidgets(
      'does not execute listener if listenWhen returns false',
      (tester) async {
        final fluxion = TestIntFluxion(0);

        var listenerCalled = false;
        var currentState = -1;
        var previousState = -2;

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionListener<TestIntFluxion, int>(
              fluxion: fluxion,
              listener: (_, __) => listenerCalled = true,
              listenWhen: (previous, current) {
                currentState = current;
                previousState = previous;
                return false;
              },
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
      'executes listener if listenWhen returns true',
      (tester) async {
        final fluxion = TestIntFluxion(0);

        var listenerCalled = false;
        var listenerState = -1;
        var currentState = -2;
        var previousState = -3;

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionListener<TestIntFluxion, int>(
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
        var listenerState = -1;

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionListener<TestIntFluxion, int>(
              fluxion: fluxion,
              listener: (_, state) {
                listenerCalled = true;
                listenerState = state;
              },
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
