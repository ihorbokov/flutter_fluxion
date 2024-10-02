import 'package:flutter_fluxion/src/fluxion.dart';

class _TestFluxion<S> extends Fluxion<S> {
  _TestFluxion(super.initialState);

  void update(S state) => notify(state);
}

class TestIntFluxion extends _TestFluxion<int> {
  TestIntFluxion(super.initialState);
}

class TestStringFluxion extends _TestFluxion<String> {
  TestStringFluxion(super.initialState);
}
