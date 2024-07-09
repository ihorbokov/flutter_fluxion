import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/fluxion.dart';
import 'package:provider/provider.dart';

/// A typedef for creating an instance of a type [T] based on the
/// provided [BuildContext].
typedef Create<T> = T Function(BuildContext context);

/// A widget that provides a [Fluxion] to the widget tree.
///
/// This can either provide a new [Fluxion] instance created by a factory
/// or provide an existing instance.
class FluxionProvider<F extends Fluxion<S>, S> extends StatelessWidget {
  /// Constructs a [FluxionProvider] that will create a [Fluxion] using
  /// the provided [create] function.
  ///
  /// The [create] function is used to generate a new [Fluxion] instance
  /// when none is provided.
  ///
  /// If [lazy] is true, the [Fluxion] is created the first time it is
  /// requested.
  ///
  /// The [child] widget is the subtree that can access the [Fluxion].
  const FluxionProvider({
    required Create<F> create,
    required this.child,
    this.lazy = true,
    super.key,
  })  : _create = create,
        _value = null;

  /// Constructs a [FluxionProvider] that uses an existing [Fluxion] instance
  /// provided by [value].
  ///
  /// This constructor is typically used to provide an existing [Fluxion]
  /// to the subtree.
  ///
  /// If [lazy] is true, the [Fluxion] is created the first time it is
  /// requested.
  ///
  /// The [child] widget is the subtree that can access the [Fluxion].
  const FluxionProvider.value({
    required F value,
    required this.child,
    this.lazy = true,
    super.key,
  })  : _create = null,
        _value = value;

  /// The Fluxion instance, if provided directly.
  final F? _value;

  /// The function to create a new [Fluxion] instance, if not provided directly.
  final Create<F>? _create;

  /// Indicates whether the [Fluxion] should be created lazily (on-demand).
  final bool lazy;

  /// The child widget that can access the [Fluxion].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final value = _value;
    if (value != null) {
      return InheritedProvider<F>.value(
        value: value,
        lazy: lazy,
        child: child,
      );
    } else {
      return InheritedProvider<F>(
        create: _create,
        dispose: (_, fluxion) => fluxion.clear(),
        lazy: lazy,
        child: child,
      );
    }
  }
}
