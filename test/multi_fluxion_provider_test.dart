import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/fluxion_provider.dart';
import 'package:flutter_fluxion/src/multi_fluxion_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

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

        final provider1Finder =
            find.byType(FluxionProvider<TestIntFluxion, int>);

        final provider2Finder =
            find.byType(FluxionProvider<TestStringFluxion, String>);

        expect(provider1Finder, findsOneWidget);
        expect(provider2Finder, findsOneWidget);

        final provider1Widget =
            tester.widget<FluxionProvider<TestIntFluxion, int>>(
          provider1Finder,
        );
        expect(
          provider1Widget.child,
          isInstanceOf<FluxionProvider<TestStringFluxion, String>>(),
        );

        final provider2Widget =
            tester.widget<FluxionProvider<TestStringFluxion, String>>(
          provider2Finder,
        );
        expect(provider2Widget.child, isInstanceOf<Placeholder>());
      },
    );

    testWidgets(
      'should build widget with nested structure when providers are applied',
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

        final provider1Finder =
            find.byType(FluxionProvider<TestIntFluxion, int>);

        final provider2Finder =
            find.byType(FluxionProvider<TestStringFluxion, String>);

        expect(provider1Finder, findsOneWidget);
        expect(provider2Finder, findsOneWidget);

        final provider1Widget =
            tester.widget<FluxionProvider<TestIntFluxion, int>>(
          provider1Finder,
        );

        final provider2Widget = provider1Widget.child
            as FluxionProvider<TestStringFluxion, String>?;

        final provider2WidgetChild = provider2Widget?.child;
        expect(provider2WidgetChild, isNotNull);
        expect(provider2WidgetChild, isInstanceOf<Placeholder>());
      },
    );

    testWidgets(
      'should provide Fluxion instances to a child widget',
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
              child: Builder(
                builder: (context) {
                  final fluxion1 = context.read<TestIntFluxion>();
                  final fluxion2 = context.read<TestStringFluxion>();
                  return Text('State: ${fluxion1.state}; ${fluxion2.state}');
                },
              ),
            ),
          ),
        );

        expect(find.text('State: 0; initial'), findsOneWidget);
      },
    );
  });
}
