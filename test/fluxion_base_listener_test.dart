import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/base/base_listener.dart';
import 'package:flutter_fluxion/src/fluxion.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'common.dart';

void main() {
  group('BaseListener', () {
    testWidgets(
      'should initialize with passed fluxion',
      (tester) async {
        final fluxion = TestIntFluxion(0);

        await tester.pumpWidget(
          MaterialApp(
            home: _TestBaseListener(
              fluxion: fluxion,
            ),
          ),
        );

        final state = tester.state<_TestBaseListenerState>(
          find.byType(_TestBaseListener),
        );

        expect(state.actualFluxion, isA<TestIntFluxion>());
        expect(state.actualFluxion, equals(fluxion));

        expect(state.actualState, isA<int>());
        expect(state.actualState, 0);
      },
    );

    testWidgets(
      'should initialize with provided fluxion',
      (tester) async {
        final fluxion = TestIntFluxion(0);

        await tester.pumpWidget(
          Provider.value(
            value: fluxion,
            child: const MaterialApp(
              home: _TestBaseListener(),
            ),
          ),
        );

        final state = tester.state<_TestBaseListenerState>(
          find.byType(_TestBaseListener),
        );

        expect(state.actualFluxion, isA<TestIntFluxion>());
        expect(state.actualFluxion, equals(fluxion));

        expect(state.actualState, isA<int>());
        expect(state.actualState, 0);
      },
    );

    testWidgets(
      'should call onNewState when state updates',
      (tester) async {
        final fluxion = TestIntFluxion(0);

        await tester.pumpWidget(
          MaterialApp(
            home: _TestBaseListener(
              fluxion: fluxion,
            ),
          ),
        );

        final state = tester.state<_TestBaseListenerState>(
          find.byType(_TestBaseListener),
        );

        expect(state.actualState, isA<int>());
        expect(state.actualState, 0);

        fluxion.update(1);
        await tester.pumpAndSettle();

        expect(state.actualState, isA<int>());
        expect(state.actualState, 1);
      },
    );

    testWidgets(
      'should update fluxion if widget updates',
      (tester) async {
        final fluxion1 = TestIntFluxion(0);
        final fluxion2 = TestIntFluxion(1);

        await tester.pumpWidget(
          MaterialApp(
            home: _TestBaseListener(
              fluxion: fluxion1,
            ),
          ),
        );

        var state = tester.state<_TestBaseListenerState>(
          find.byType(_TestBaseListener),
        );

        expect(state.actualFluxion, equals(fluxion1));

        await tester.pumpWidget(
          MaterialApp(
            home: _TestBaseListener(
              fluxion: fluxion2,
            ),
          ),
        );

        await tester.pumpAndSettle();

        state = tester.state<_TestBaseListenerState>(
          find.byType(_TestBaseListener),
        );

        expect(state.actualFluxion, equals(fluxion2));
      },
    );

    testWidgets(
      'should update fluxion on dependencies change',
      (tester) async {
        final fluxion1 = TestIntFluxion(0);
        final fluxion2 = TestIntFluxion(1);

        await tester.pumpWidget(
          Provider.value(
            value: fluxion1,
            child: const MaterialApp(
              home: _TestBaseListener(),
            ),
          ),
        );

        var state = tester.state<_TestBaseListenerState>(
          find.byType(_TestBaseListener),
        );

        expect(state.actualFluxion, equals(fluxion1));

        await tester.pumpWidget(
          Provider.value(
            value: fluxion2,
            child: const MaterialApp(
              home: _TestBaseListener(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        state = tester.state<_TestBaseListenerState>(
          find.byType(_TestBaseListener),
        );

        expect(state.actualFluxion, equals(fluxion2));
      },
    );
  });
}

class _TestBaseListener extends BaseListener<TestIntFluxion, int> {
  const _TestBaseListener({super.fluxion});

  @override
  State<_TestBaseListener> createState() => _TestBaseListenerState();
}

class _TestBaseListenerState
    extends BaseListenerState<TestIntFluxion, int, _TestBaseListener> {
  late int actualState = fluxion.state;

  Fluxion<int> get actualFluxion => fluxion;

  @override
  void onNewState(int state) => actualState = state;

  @override
  Widget build(BuildContext context) => const Placeholder();
}
