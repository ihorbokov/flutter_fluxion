import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/fluxion_consumer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'common/fluxion_stub.dart';

void main() {
  group('FluxionConsumer', () {
    testWidgets(
      'initializes state correctly',
      (tester) async {
        final fluxion1 = TestIntFluxion(0);
        final fluxion2 = TestIntFluxion(1);

        var listenerCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionConsumer<TestIntFluxion, int>(
              fluxion: fluxion1,
              listener: (_, __) => listenerCalled = true,
              builder: (_, state) => Text('State: ${fluxion1.state}'),
            ),
          ),
        );

        expect(find.text('State: 0'), findsOneWidget);
        expect(listenerCalled, isFalse);

        await tester.pumpWidget(
          Provider.value(
            value: fluxion2,
            child: MaterialApp(
              home: FluxionConsumer<TestIntFluxion, int>(
                listener: (_, __) => listenerCalled = true,
                builder: (_, state) => Text('State: ${fluxion2.state}'),
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
      'executes listener and rebuilds widget on state change',
      (tester) async {
        final fluxion = TestIntFluxion(0);

        var listenerCalled = false;
        var listenerState = -1;

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionConsumer<TestIntFluxion, int>(
              fluxion: fluxion,
              listener: (_, state) {
                listenerCalled = true;
                listenerState = state;
              },
              builder: (_, state) => Text('State: $state'),
            ),
          ),
        );

        expect(listenerCalled, isFalse);
        expect(find.text('State: 0'), findsOneWidget);

        fluxion.update(1);
        await tester.pumpAndSettle();

        expect(find.text('State: 1'), findsOneWidget);
        expect(listenerCalled, isTrue);
        expect(listenerState, 1);
      },
    );

    testWidgets(
      'respects buildWhen and listenWhen conditions',
      (tester) async {
        final fluxion = TestIntFluxion(0);

        var listenerCalled = false;
        var buildCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionConsumer<TestIntFluxion, int>(
              fluxion: fluxion,
              listener: (_, __) => listenerCalled = true,
              listenWhen: (_, current) => current == 1,
              builder: (_, state) {
                buildCount++;
                return Text('State: $state');
              },
              buildWhen: (_, current) => current == 1,
            ),
          ),
        );

        fluxion.update(2);
        await tester.pumpAndSettle();

        expect(find.text('State: 0'), findsOneWidget);
        expect(listenerCalled, isFalse);
        expect(buildCount, 1);

        fluxion.update(1);
        await tester.pumpAndSettle();

        expect(find.text('State: 1'), findsOneWidget);
        expect(listenerCalled, isTrue);
        expect(buildCount, 2);
      },
    );
  });
}
