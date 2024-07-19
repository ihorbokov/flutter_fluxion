import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/base/base_listener.dart';
import 'package:flutter_fluxion/src/fluxion.dart';

/// A typedef for a condition function that determines if
/// the widget should rebuild.
///
/// This function returns true if the widget should rebuild
/// when the state changes from [previous] to [current].
typedef FlxnBuilderCondition<S> = bool Function(S previous, S current);

/// A typedef for a function that builds a widget based on
/// the given [context] and state [S].
typedef FlxnWidgetBuilder<S> = Widget Function(BuildContext context, S state);

/// A widget that rebuilds itself based on the changes in the state
/// of a [Fluxion].
///
/// The generic types [F] and [S] represent the specific type of [Fluxion]
/// and its state, respectively. This widget listens to changes in [Fluxion]
/// and optionally rebuilds itself based on a condition.
class FluxionBuilder<F extends Fluxion<S>, S> extends BaseListener<F, S> {
  /// Constructs a [FluxionBuilder].
  ///
  /// The [builder] function describes the part of the user interface
  /// represented by this widget.
  /// The [buildWhen] is an optional callback that determines whether
  /// the builder should run again in response to a state change, allowing
  /// for more granular control over the frequency of rebuilds.
  const FluxionBuilder({
    required this.builder,
    this.buildWhen,
    super.fluxion,
    super.key,
  });

  /// The builder function used to create the UI of this widget.
  final FlxnWidgetBuilder<S> builder;

  /// A condition function that determines whether to rebuild
  /// the widget on state changes.
  final FlxnBuilderCondition<S>? buildWhen;

  @override
  State<FluxionBuilder<F, S>> createState() => _FluxionBuilderState<F, S>();
}

/// The state for [FluxionBuilder] that handles the interaction with
/// the [Fluxion].
///
/// It manages when to rebuild the widget based on the changes in
/// the state of [Fluxion].
class _FluxionBuilderState<F extends Fluxion<S>, S>
    extends BaseListenerState<F, S, FluxionBuilder<F, S>> {
  /// Stores the current state to compare against new updates.
  late S _state = fluxion.state;

  /// Called when the [Fluxion] notifies listeners of a state change.
  ///
  /// If `buildWhen` returns true, or if the new state is different from
  /// the old state, it triggers a rebuild of the widget.
  @override
  void onNewState(S state) {
    if (widget.buildWhen?.call(_state, state) ?? state != _state) {
      setState(() => _state = state);
    }
  }

  /// Builds the widget based on the current state.
  ///
  /// It uses the `builder` provided in the widget to construct the UI.
  @override
  Widget build(BuildContext context) => widget.builder(context, _state);
}
