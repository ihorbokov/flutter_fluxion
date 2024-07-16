import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/fluxion.dart';
import 'package:provider/provider.dart';

/// A typedef for creating an instance of a type [F] based on the
/// provided [BuildContext].
typedef FlxnCreate<F> = F Function(BuildContext context);

/// A function that returns true when the update from [previous] to [current]
/// should notify listeners, if any.
typedef FlxnUpdateShouldNotify<F> = bool Function(F previous, F current);

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
    required FlxnCreate<F> create,
    required this.child,
    bool lazy = true,
    super.key,
  })  : _create = create,
        _value = null,
        _lazy = lazy,
        _updateShouldNotify = null;

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
    FlxnUpdateShouldNotify<F>? updateShouldNotify,
    super.key,
  })  : _create = null,
        _value = value,
        _lazy = null,
        _updateShouldNotify = updateShouldNotify;

  /// The Fluxion instance, if provided directly.
  final F? _value;

  /// The function to create a new [Fluxion] instance, if not provided directly.
  final FlxnCreate<F>? _create;

  /// A function that determines whether an update should notify listeners.
  final FlxnUpdateShouldNotify<F>? _updateShouldNotify;

  /// Indicates whether the [Fluxion] should be created lazily (on-demand).
  final bool? _lazy;

  /// The child widget that can access the [Fluxion].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final value = _value;
    if (value != null) {
      return Provider<F>.value(
        value: value,
        updateShouldNotify: _updateShouldNotify,
        child: child,
      );
    }
    final create = _create;
    if (create != null) {
      return Provider<F>(
        create: create,
        dispose: (_, fluxion) => fluxion.clear(),
        lazy: _lazy,
        child: child,
      );
    }
    return child;
  }
}
