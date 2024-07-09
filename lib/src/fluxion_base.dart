import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/fluxion.dart';
import 'package:provider/provider.dart';

/// An abstract StatefulWidget that acts as a base for widgets
/// that listen to state changes from a specified [Fluxion].
///
/// The generic types [F] and [S] represent the specific type
/// of [Fluxion] and its state, respectively. This base class
/// requires a [fluxion] object to listen to.
abstract class BaseListener<F extends Fluxion<S>, S> extends StatefulWidget {
  /// Constructs a [BaseListener].
  ///
  /// Optionally, a specific [fluxion] can be provided.
  /// If no [fluxion] is provided, it will attempt to find
  /// one using the context in [BaseListenerState].
  const BaseListener({
    this.fluxion,
    super.key,
  });

  /// The fluxion this widget listens to. It can be null, in which case
  /// the fluxion will be obtained from the nearest Provider context.
  final F? fluxion;
}

/// The state class for [BaseListener] that manages the interaction
/// with the [Fluxion].
///
/// This state class automatically subscribes to the state changes of
/// the [fluxion] and provides a callback [onNewState] that subclasses
/// should implement to react to state changes.
abstract class BaseListenerState<F extends Fluxion<S>, S,
    L extends BaseListener<F, S>> extends State<L> {
  /// The active fluxion. It is determined either from
  /// the widget's [fluxion] or from the Provider context.
  late F _fluxion = widget.fluxion ?? context.read<F>();

  /// Provides protected access to the active [Fluxion] instance.
  @protected
  F get fluxion => _fluxion;

  /// A callback method that subclasses need to override to handle
  /// state updates.
  @protected
  void onNewState(S state);

  @override
  void initState() {
    super.initState();
    _fluxion.addListener(onNewState);
  }

  @override
  void didUpdateWidget(covariant L oldWidget) {
    super.didUpdateWidget(oldWidget);
    _refresh();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refresh();
  }

  void _refresh() {
    final fluxion = widget.fluxion ?? context.read<F>();
    if (fluxion != _fluxion) {
      _fluxion.removeListener(onNewState);
      _fluxion = fluxion;
      _fluxion.addListener(onNewState);
    }
  }

  @override
  void dispose() {
    _fluxion.removeListener(onNewState);
    super.dispose();
  }
}
