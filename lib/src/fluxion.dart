import 'package:flutter/material.dart';

/// A typedef for a listener callback function
/// that receives updates to the state.
typedef Listener<S> = void Function(S state);

/// An abstract class that provides a reactive state management mechanism.
///
/// This class provides methods to manage and notify listeners about state
/// changes.
///
/// Generic type [S] refers to the type of the state managed by this Fluxion.
abstract class Fluxion<S> {
  /// Initializes the Fluxion with an initial state.
  ///
  /// The [initialState] sets the starting state of the Fluxion.
  Fluxion(S initialState)
      : _state = initialState,
        _listeners = [];

  /// The current state of the Fluxion.
  late S _state;

  /// A list of listeners that are called when the state changes.
  late final List<Listener<S>> _listeners;

  /// Returns the current state.
  S get state => _state;

  /// Notifies all listeners about a state change.
  ///
  /// [state] is the new state that will replace the current state and will
  /// be passed to all listeners.
  @protected
  void notify(S state) {
    for (final listener in _listeners) {
      listener(state);
    }
    _state = state;
  }

  /// Adds a [Listener] to the list of listeners.
  ///
  /// The [listener] will be called whenever the state changes.
  void addListener(Listener<S> listener) => _listeners.add(listener);

  /// Removes a [Listener] from the list of listeners.
  ///
  /// This method removes the specified [listener]
  /// so it no longer receives state updates.
  void removeListener(Listener<S> listener) => _listeners.remove(listener);

  /// Cleans up the Fluxion by clearing all listeners.
  ///
  /// This method should be called when the Fluxion is no longer needed to
  /// free up resources and prevent memory leaks.
  @mustCallSuper
  void clear() => _listeners.clear();
}
