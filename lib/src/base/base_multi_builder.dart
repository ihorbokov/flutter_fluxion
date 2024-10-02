import 'package:flutter/material.dart';

/// A type definition for a function that takes a [Widget] as input and
/// returns a [Widget]. This allows for the creation of nested or layered
/// widget structures.
typedef FlxnNestedWidgetBuilder = Widget Function(Widget child);

/// An abstract base class for creating a multi-builder widget.
/// This class takes a list of [FlxnNestedWidgetBuilder] functions and a
/// child widget. It applies each builder to the child widget in reverse order,
/// resulting in a nested widget structure.
abstract class BaseMultiBuilder extends StatelessWidget {
  /// Creates a [BaseMultiBuilder] instance.
  ///
  /// The [builders] parameter is a list of functions that will be applied
  /// to the [child] widget in reverse order. The [child] parameter is the
  /// initial widget to which the builders will be applied.
  const BaseMultiBuilder({
    required this.builders,
    required this.child,
    super.key,
  });

  /// A list of functions that take a [Widget] and return a [Widget].
  /// These functions will be applied to the [child] widget in reverse order
  /// to create a nested structure.
  final List<FlxnNestedWidgetBuilder> builders;

  /// The initial widget to which the [builders] will be applied.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var nested = child;
    for (final builder in builders.reversed) {
      nested = builder(nested);
    }
    return nested;
  }
}
