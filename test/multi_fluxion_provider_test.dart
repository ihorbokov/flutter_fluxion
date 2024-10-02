import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/fluxion_provider.dart';
import 'package:flutter_fluxion/src/multi_fluxion_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common/fluxion_stub.dart';

void main() {
  group('MultiFluxionProvider', () {
    testWidgets(
      'should build widget with no providers',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: MultiFluxionProvider(
              providers: [],
              child: Placeholder(),
            ),
          ),
        );

        expect(find.byType(Placeholder), findsOneWidget);
      },
    );

    testWidgets(
      'should build widget with a single provider',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MultiFluxionProvider(
              providers: [
                (child) {
                  return FluxionProvider<TestIntFluxion, int>(
                    create: (_) => TestIntFluxion(0),
                    child: child,
                  );
                },
              ],
              child: const Placeholder(),
            ),
          ),
        );

        expect(
          find.byType(FluxionProvider<TestIntFluxion, int>),
          findsOneWidget,
        );
        expect(find.byType(Placeholder), findsOneWidget);
      },
    );

    testWidgets(
      'should build widget with multiple providers in reverse order',
      (tester) async {
        final fluxion1 = TestIntFluxion(0);
        final fluxion2 = TestStringFluxion('initial');

        await tester.pumpWidget(
          MaterialApp(
            home: MultiFluxionProvider(
              providers: [
                (child) {
                  return FluxionProvider<TestIntFluxion, int>.value(
                    value: fluxion1,
                    child: child,
                  );
                },
                (child) {
                  return FluxionProvider<TestStringFluxion, String>.value(
                    value: fluxion2,
                    child: child,
                  );
                },
              ],
              child: const Placeholder(),
            ),
          ),
        );

        final providerFinder1 =
            find.byType(FluxionProvider<TestIntFluxion, int>);

        final providerFinder2 =
            find.byType(FluxionProvider<TestStringFluxion, String>);

        expect(providerFinder1, findsOneWidget);
        expect(providerFinder2, findsOneWidget);

        final provider1Widget =
            tester.widget<FluxionProvider<TestIntFluxion, int>>(
          providerFinder1,
        );
        expect(
          provider1Widget.child,
          isInstanceOf<FluxionProvider<TestStringFluxion, String>>(),
        );

        final listener2Widget =
            tester.widget<FluxionProvider<TestStringFluxion, String>>(
          providerFinder2,
        );
        expect(listener2Widget.child, isInstanceOf<Placeholder>());
      },
    );
  });
}
