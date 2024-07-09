import 'package:flutter/material.dart';

class Provider<T> extends InheritedWidget {
  const Provider({
    required this.value,
    required super.child,
    super.key,
  });

  final T value;

  static T of<T>(
    BuildContext context, {
    bool listen = false,
  }) {
    final provider = listen
        ? context.dependOnInheritedWidgetOfExactType<Provider<T>>()
        : context.findAncestorWidgetOfExactType<Provider<T>>();
    assert(provider != null, 'No Provider<${T.runtimeType}> found in context.');
    return provider!.value;
  }

  @override
  bool updateShouldNotify(Provider<T> oldWidget) => oldWidget.value != value;
}

class MultiProvider extends StatelessWidget {
  const MultiProvider({
    required this.child,
    required this.providers,
    super.key,
  });

  final List<Provider> providers;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var wrapper = child;
    for (final provider in providers.reversed) {
      wrapper = Provider(
        value: provider.value,
        child: wrapper,
      );
    }
    return wrapper;
  }
}

extension ReadContext on BuildContext {
  T read<T>({bool listen = false}) => Provider.of<T>(this, listen: false);
}
