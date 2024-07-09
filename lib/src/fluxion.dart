import 'package:flutter/material.dart';

typedef Listener<S> = void Function(S);

class Fluxion<S> {
  Fluxion(S initialState)
      : _state = initialState,
        _listeners = [];

  late S _state;
  late final List<Listener<S>> _listeners;

  S get state => _state;

  @protected
  void shift(S state) {
    if (state != _state) {
      for (final listener in _listeners) {
        listener(state);
      }
      _state = state;
    }
  }

  void addListener(Listener<S> listener) => _listeners.add(listener);

  void removeListener(Listener<S> listener) => _listeners.remove(listener);

  @mustCallSuper
  void close() => _listeners.clear();
}
