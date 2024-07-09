import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

void main() {
  group('Fluxion', () {
    test('should initialize with the initial state', () {
      final fluxion = TestIntFluxion(0);

      expect(fluxion.state, 0);
    });

    test('should notify listeners when state changes', () {
      final fluxion = TestIntFluxion(0);
      var latestState = -1;

      fluxion
        ..addListener((state) => latestState = state)
        ..update(10);

      expect(latestState, 10);
      expect(fluxion.state, 10);
    });

    test('should add and call multiple listeners', () {
      final fluxion = TestStringFluxion('initial');
      var firstListenerCalled = false;
      var secondListenerCalled = false;

      fluxion
        ..addListener((state) {
          firstListenerCalled = true;
          expect(state, 'updated');
        })
        ..addListener((state) {
          secondListenerCalled = true;
          expect(state, 'updated');
        })
        ..update('updated');

      expect(firstListenerCalled, isTrue);
      expect(secondListenerCalled, isTrue);
    });

    test('should remove listener correctly', () {
      final fluxion = TestStringFluxion('initial');
      var listenerCalled = false;

      void listener(String state) {
        listenerCalled = true;
      }

      fluxion
        ..addListener(listener)
        ..removeListener(listener)
        ..update('updated');

      expect(listenerCalled, isFalse);
    });

    test('should clear all listeners', () {
      final fluxion = TestIntFluxion(0);
      var callCount = 0;

      fluxion
        ..addListener((_) => callCount++)
        ..addListener((_) => callCount++)
        ..clear()
        ..update(10);

      expect(callCount, 0);
    });
  });
}
