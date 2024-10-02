import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/base/base_multi_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseMultiBuilder', () {
    testWidgets(
      'should build widget with no builders',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: _TestBaseMultiBuilder(
              builders: [],
              child: Placeholder(),
            ),
          ),
        );

        expect(find.byType(Placeholder), findsOneWidget);
      },
    );

    testWidgets(
      'should build widget with a single builder',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: _TestBaseMultiBuilder(
              builders: [
                (child) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: child,
                  );
                },
              ],
              child: const Placeholder(),
            ),
          ),
        );

        expect(find.byType(Padding), findsOneWidget);
        expect(find.byType(Placeholder), findsOneWidget);
      },
    );

    testWidgets(
      'should build widget with multiple builders in reverse order',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: _TestBaseMultiBuilder(
              builders: [
                (child) {
                  return ColoredBox(
                    color: Colors.blue,
                    child: child,
                  );
                },
                (child) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: child,
                  );
                },
              ],
              child: const Placeholder(),
            ),
          ),
        );

        final coloredBoxFinder = find.byType(ColoredBox);
        final paddingFinder = find.byType(Padding);

        expect(coloredBoxFinder, findsOneWidget);
        expect(paddingFinder, findsOneWidget);

        final coloredBoxWidget = tester.widget<ColoredBox>(coloredBoxFinder);
        expect(coloredBoxWidget.child, isInstanceOf<Padding>());

        final paddingWidget = tester.widget<Padding>(paddingFinder);
        expect(paddingWidget.child, isInstanceOf<Placeholder>());
      },
    );

    testWidgets(
      'should build widget with nested structure when builders are applied',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: _TestBaseMultiBuilder(
              builders: [
                (child) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: child,
                  );
                },
                (child) {
                  return ColoredBox(
                    color: Colors.blue,
                    child: child,
                  );
                },
                (child) {
                  return Align(
                    child: child,
                  );
                },
              ],
              child: const Placeholder(),
            ),
          ),
        );

        final alignFinder = find.byType(Align);
        final coloredBoxFinder = find.byType(ColoredBox);
        final paddingFinder = find.byType(Padding);

        expect(alignFinder, findsOneWidget);
        expect(coloredBoxFinder, findsOneWidget);
        expect(paddingFinder, findsOneWidget);

        final paddingWidget = tester.widget<Padding>(paddingFinder);
        final coloredBoxWidget = paddingWidget.child as ColoredBox?;
        final alignWidget = coloredBoxWidget?.child as Align?;

        final alignWidgetChild = alignWidget?.child;
        expect(alignWidgetChild, isNotNull);
        expect(alignWidgetChild, isInstanceOf<Placeholder>());
      },
    );
  });
}

class _TestBaseMultiBuilder extends BaseMultiBuilder {
  const _TestBaseMultiBuilder({
    required super.builders,
    required super.child,
  });
}
