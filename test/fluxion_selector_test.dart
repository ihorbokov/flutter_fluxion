import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/fluxion_selector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'common/fluxion_stub.dart';

void main() {
  group('FluxionSelector', () {
    testWidgets(
      'initializes state correctly',
      (tester) async {
        final fluxion1 = TestIntFluxion(0);
        final fluxion2 = TestIntFluxion(1);

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionSelector<TestIntFluxion, int, String>(
              fluxion: fluxion1,
              selector: (state) => 'State: $state',
              builder: (_, state) => Text(state),
            ),
          ),
        );

        expect(find.text('State: 0'), findsOneWidget);

        await tester.pumpWidget(
          Provider.value(
            value: fluxion2,
            child: MaterialApp(
              home: FluxionSelector<TestIntFluxion, int, String>(
                selector: (state) => 'State: $state',
                builder: (_, state) => Text(state),
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
            home: FluxionSelector<TestIntFluxion, int, String>(
              fluxion: fluxion,
              selector: (state) => 'State: $state',
              builder: (_, state) => Text(state),
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
            home: FluxionSelector<TestIntFluxion, int, String>(
              fluxion: fluxion,
              selector: (state) => 'State: $state',
              builder: (_, state) => Text(state),
            ),
          ),
        );

        expect(find.text('State: 0'), findsOneWidget);

        fluxion.update(0);
        await tester.pumpAndSettle();

        expect(find.text('State: 0'), findsOneWidget);
      },
    );
  });
}
