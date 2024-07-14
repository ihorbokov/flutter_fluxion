import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/fluxion.dart';
import 'package:flutter_fluxion/src/fluxion_base.dart';

/// A typedef for a condition function that determines if the listener
/// should execute.
///
/// This function returns true if the listener should be invoked when
/// the state changes from [previous] to [current].
typedef FlxnListenerCondition<S> = bool Function(S previous, S current);

/// A typedef for a function that executes side effects based on the
/// given [context] and state [S].
typedef FlxnWidgetListener<S> = void Function(BuildContext context, S state);

/// A Flutter widget that listens to state changes from a [Fluxion] and
/// executes side effects.
///
/// The generic types [F] and [S] represent the specific type of [Fluxion]
/// and its state, respectively. This widget listens to changes in [Fluxion]
/// and triggers the [listener] callback in response to state changes,
/// potentially filtered by a [listenWhen] condition.
class FluxionListener<F extends Fluxion<S>, S> extends BaseListener<F, S> {
  /// Creates a [FluxionListener].
  ///
  /// The [listener] is a callback that executes side effects in response
  /// to state changes.
  ///
  /// The [listenWhen] is an optional callback that determines whether the
  /// [listener] should be called on a state change, allowing for more granular
  /// control over when side effects occur.
  ///
  /// The [child] widget is what [FluxionListener] displays and does not
  /// rebuild based on state changes.
  const FluxionListener({
    required this.listener,
    required this.child,
    this.listenWhen,
    super.fluxion,
    super.key,
  });

  /// The callback executed in response to state changes.
  final FlxnWidgetListener<S> listener;

  /// A condition that determines whether the listener should be triggered.
  final FlxnListenerCondition<S>? listenWhen;

  /// The child widget to display. This widget does not rebuild when the
  /// state changes.
  final Widget child;

  @override
  State<FluxionListener<F, S>> createState() => _FluxionListenerState<F, S>();
}

/// The state for [FluxionListener] that manages the interaction with
/// the [Fluxion].
///
/// This state class automatically subscribes to the state changes
/// and executes the `listener` callback based on the condition provided
/// by `listenWhen`.
class _FluxionListenerState<F extends Fluxion<S>, S>
    extends BaseListenerState<F, S, FluxionListener<F, S>> {
  /// Current state of the [Fluxion].
  S get _state => fluxion.state;

  /// Called when the [Fluxion] notifies listeners of a state change.
  ///
  /// If `listenWhen` returns true, or if there is no `listenWhen` provided,
  /// it triggers the `listener`.
  @override
  void onNewState(S state) {
    if (widget.listenWhen?.call(_state, state) ?? true) {
      widget.listener(context, state);
    }
  }

  /// Builds the widget based on the current state.
  ///
  /// It simply returns the `child` widget provided in the [FluxionListener],
  /// which does not rebuild in response to state changes. This ensures that
  /// the listener's side effects do not cause re-renders.
  @override
  Widget build(BuildContext context) => widget.child;
}
