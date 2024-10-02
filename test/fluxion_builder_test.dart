import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/fluxion_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'common/fluxion_stub.dart';

void main() {
  group('FluxionBuilder', () {
    testWidgets(
      'initializes state correctly',
      (tester) async {
        final fluxion1 = TestIntFluxion(0);
        final fluxion2 = TestIntFluxion(1);

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionBuilder<TestIntFluxion, int>(
              fluxion: fluxion1,
              builder: (_, state) => Text('State: $state'),
            ),
          ),
        );

        expect(find.text('State: 0'), findsOneWidget);

        await tester.pumpWidget(
          Provider.value(
            value: fluxion2,
            child: MaterialApp(
              home: FluxionBuilder<TestIntFluxion, int>(
                builder: (_, state) => Text('State: $state'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('State: 1'), findsOneWidget);
      },
    );

    testWidgets(
      'rebuilds widget on state change',
      (tester) async {
        final fluxion = TestIntFluxion(0);

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionBuilder<TestIntFluxion, int>(
              fluxion: fluxion,
              builder: (_, state) => Text('State: $state'),
            ),
          ),
        );

        expect(find.text('State: 0'), findsOneWidget);

        fluxion.update(1);
        await tester.pumpAndSettle();

        expect(find.text('State: 1'), findsOneWidget);
      },
    );

    testWidgets(
      'does not rebuild if state does not change',
      (tester) async {
        final fluxion = TestIntFluxion(0);

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionBuilder<TestIntFluxion, int>(
              fluxion: fluxion,
              builder: (_, state) => Text('State: $state'),
            ),
          ),
        );

        expect(find.text('State: 0'), findsOneWidget);

        fluxion.update(0);
        await tester.pumpAndSettle();

        expect(find.text('State: 0'), findsOneWidget);
      },
    );

    testWidgets(
      'does not rebuild widget if buildWhen returns false',
      (tester) async {
        final fluxion = TestIntFluxion(0);

        var currentState = -1;
        var previousState = -2;

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionBuilder<TestIntFluxion, int>(
              fluxion: fluxion,
              builder: (_, state) => Text('State: $state'),
              buildWhen: (previous, current) {
                currentState = current;
                previousState = previous;
                return false;
              },
            ),
          ),
        );

        expect(find.text('State: 0'), findsOneWidget);

        fluxion.update(1);
        await tester.pumpAndSettle();

        expect(find.text('State: 0'), findsOneWidget);
        expect(currentState, 1);
        expect(previousState, 0);
      },
    );

    testWidgets(
      'rebuilds widget if buildWhen returns true',
      (tester) async {
        final fluxion = TestIntFluxion(0);

        var currentState = -1;
        var previousState = -2;

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionBuilder<TestIntFluxion, int>(
              fluxion: fluxion,
              builder: (_, state) => Text('State: $state'),
              buildWhen: (previous, current) {
                currentState = current;
                previousState = previous;
                return true;
              },
            ),
          ),
        );

        expect(find.text('State: 0'), findsOneWidget);

        fluxion.update(1);
        await tester.pumpAndSettle();

        expect(find.text('State: 1'), findsOneWidget);
        expect(currentState, 1);
        expect(previousState, 0);
      },
    );
  });
}
