import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/fluxion_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'common/fluxion_stub.dart';

void main() {
  group('FluxionProvider', () {
    testWidgets(
      'provides new Fluxion instance via create function',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: FluxionProvider<TestStringFluxion, String>(
              create: (_) => TestStringFluxion('0'),
              child: Builder(
                builder: (context) {
                  final fluxion = context.read<TestStringFluxion>();
                  return Text('State: ${fluxion.state}');
                },
              ),
            ),
          ),
        );

        expect(find.text('State: 0'), findsOneWidget);
      },
    );

    testWidgets(
      'provides existing Fluxion instance via value constructor',
      (tester) async {
        final fluxion = TestIntFluxion(0);

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionProvider<TestIntFluxion, int>.value(
              value: fluxion,
              child: Builder(
                builder: (context) {
                  final fluxion = context.read<TestIntFluxion>();
                  return Text('State: ${fluxion.state}');
                },
              ),
            ),
          ),
        );

        expect(find.text('State: 0'), findsOneWidget);
      },
    );

    testWidgets(
      'forcefully creates Fluxion',
      (tester) async {
        var created = false;

        TestIntFluxion create(BuildContext context) {
          created = true;
          return TestIntFluxion(0);
        }

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionProvider<TestIntFluxion, int>(
              create: create,
              lazy: false,
              child: const Placeholder(),
            ),
          ),
        );

        expect(created, isTrue);
      },
    );

    testWidgets(
      'lazily creates Fluxion',
      (tester) async {
        var created = false;

        TestIntFluxion create(BuildContext context) {
          created = true;
          return TestIntFluxion(0);
        }

        await tester.pumpWidget(
          MaterialApp(
            home: FluxionProvider<TestIntFluxion, int>(
              create: create,
              child: const Text('Lazy Test'),
            ),
          ),
        );

        expect(created, isFalse);

        final context = tester.element(find.text('Lazy Test'));
        final fluxion = context.read<TestIntFluxion>();

        expect(created, isTrue);
        expect(fluxion.state, 0);
      },
    );
  });
}
