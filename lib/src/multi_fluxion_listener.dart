import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/base/base_multi_builder.dart';
import 'package:flutter_fluxion/src/fluxion.dart';
import 'package:flutter_fluxion/src/fluxion_listener.dart';

/// Signature for builders used in [MultiFluxionListener].
///
/// A function that takes a [Widget] child and returns a [FluxionListener]
/// that wraps the child.
typedef FlxnListenerBuilder<F extends Fluxion<S>, S extends Object?>
    = FluxionListener<F, S> Function(Widget child);

/// Merges multiple [FluxionListener] widgets into one widget tree.
///
/// [MultiFluxionListener] improves the readability and eliminates the need
/// to nest multiple [FluxionListener]s. By using [MultiFluxionListener],
/// you can specify multiple [FluxionListener]s in a declarative way.
///
/// ```dart
/// MultiFluxionListener(
///   listeners: [
///     (child) => FluxionListener<FluxionA, StateA>(
///       fluxion: fluxionA,
///       listener: (context, state) {
///         // Respond to fluxionA's state changes.
///       },
///       child: child,
///     ),
///     (child) => FluxionListener<FluxionB, StateB>(
///       fluxion: fluxionB,
///       listener: (context, state) {
///         // Respond to fluxionB's state changes.
///       },
///       child: child,
///     ),
///   ],
///   child: MyWidget(),
/// )
/// ```
///
/// See also:
///  * [FluxionListener], which listens to a single [Fluxion] instance.
class MultiFluxionListener extends BaseMultiBuilder {
  /// Creates a [MultiFluxionListener] widget that merges multiple
  /// [FluxionListener] widgets into one.
  ///
  /// The [listeners] argument is the list of [FlxnListenerBuilder] functions,
  /// each of which returns a [FluxionListener].
  ///
  /// The [child] argument is the widget below this widget in the tree.
  const MultiFluxionListener({
    required List<FlxnListenerBuilder> listeners,
    required super.child,
    super.key,
  }) : super(builders: listeners);
}
