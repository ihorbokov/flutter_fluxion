import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/base/base_multi_builder.dart';
import 'package:flutter_fluxion/src/fluxion.dart';
import 'package:flutter_fluxion/src/fluxion_provider.dart';

/// Signature for builders used in [MultiFluxionProvider].
///
/// A function that takes a [Widget] child and returns a [FluxionProvider]
/// that wraps the child.
typedef FlxnProviderBuilder<F extends Fluxion<S>, S extends Object?>
    = FluxionProvider<F, S> Function(Widget child);

/// Merges multiple [FluxionProvider] widgets into one widget tree.
///
/// [MultiFluxionProvider] improves readability and eliminates the need
/// to nest multiple [FluxionProvider]s. By using [MultiFluxionProvider],
/// you can provide multiple [Fluxion] instances in a declarative way.
///
/// ```dart
/// MultiFluxionProvider(
///   providers: [
///     (child) => FluxionProvider<FluxionA, StateA>(
///       create: (context) => FluxionA(),
///       child: child,
///     ),
///     (child) => FluxionProvider<FluxionB, StateB>(
///       create: (context) => FluxionB(),
///       child: child,
///     ),
///   ],
///   child: MyApp(),
/// )
/// ```
///
/// See also:
///  * [FluxionProvider], which provides a single [Fluxion] instance to
///  the widget tree.
class MultiFluxionProvider extends BaseMultiBuilder {
  /// Creates a [MultiFluxionProvider] widget that merges multiple
  /// [FluxionProvider] widgets into one.
  ///
  /// The [providers] argument is the list of [FlxnProviderBuilder] functions,
  /// each of which returns a [FluxionProvider].
  ///
  /// The [child] argument is the widget below this widget in the tree.
  const MultiFluxionProvider({
    required List<FlxnProviderBuilder> providers,
    required super.child,
    super.key,
  }) : super(builders: providers);
}
