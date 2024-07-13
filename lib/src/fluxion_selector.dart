import 'package:flutter/material.dart' hide WidgetBuilder;
import 'package:flutter_fluxion/flutter_fluxion.dart';
import 'package:flutter_fluxion/src/fluxion_base.dart';

/// A typedef for a function that transforms the state [S] into a new form [T].
typedef StateSelector<S, T> = T Function(S state);

/// A widget that listens to a [Fluxion] and rebuilds its child selectively
/// based on the transformation defined by a [selector].
///
/// The generic types [F], [S], and [T] represent the specific type of
/// [Fluxion], its state type, and the selected state type, respectively.
class FluxionSelector<F extends Fluxion<S>, S, T> extends BaseListener<F, S> {
  /// Creates a [FluxionSelector] that listens to state changes, applies
  /// a [selector] to derive a new state [T] from [S], and rebuilds using
  /// the provided [builder].
  const FluxionSelector({
    required this.selector,
    required this.builder,
    super.fluxion,
    super.key,
  });

  /// A function that transforms the state [S] into a new form [T].
  final StateSelector<S, T> selector;

  /// A builder function used to create the UI based on the selected state [T].
  final WidgetBuilder<T> builder;

  @override
  State<FluxionSelector<F, S, T>> createState() =>
      _FluxionSelectorState<F, S, T>();
}

/// The state for [FluxionSelector], managing the lifecycle and state changes
/// for widgets that depend on a specific transformation of the state managed
/// by a [Fluxion].
///
/// [F] is the type of the [Fluxion] that provides the state [S], and [T] is
/// the type of the derived state that this selector cares about.
class _FluxionSelectorState<F extends Fluxion<S>, S, T>
    extends BaseListenerState<F, S, FluxionSelector<F, S, T>> {
  /// Holds the current selected state which is used to build the widget.
  late T _state = widget.selector(fluxion.state);

  /// Called when the [Fluxion] notifies listeners of a state change.
  ///
  /// This method minimizes widget rebuilds by checking if the derived
  /// state actually changed before calling `setState`, ensuring only
  /// necessary updates are made.
  @override
  void onNewState(S state) {
    final selectedState = widget.selector(state);
    if (selectedState != _state) setState(() => _state = selectedState);
  }

  /// Builds the widget based on the selected state [T].
  ///
  /// It uses the `builder` function provided in [FluxionSelector] to render
  /// the UI based on the current value of [_state].
  @override
  Widget build(BuildContext context) => widget.builder(context, _state);
}
