import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/common/provider.dart';
import 'package:flutter_fluxion/src/fluxion.dart';

typedef Create<T> = T Function(BuildContext context);

class FluxionProvider<F extends Fluxion<S>, S> extends StatefulWidget {
  const FluxionProvider({
    required Create<F> create,
    required this.child,
    super.key,
  })  : _create = create,
        _value = null;

  const FluxionProvider.value({
    required F value,
    required this.child,
    super.key,
  })  : _value = value,
        _create = null;

  final F? _value;
  final Create<F>? _create;

  final Widget child;

  @override
  State<FluxionProvider<F, S>> createState() => _FluxionProviderState<F, S>();
}

class _FluxionProviderState<F extends Fluxion<S>, S>
    extends State<FluxionProvider<F, S>> {
  late final _fluxion = widget._value ?? widget._create?.call(context);

  @override
  Widget build(BuildContext context) {
    return Provider(
      value: _fluxion,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _fluxion?.close();
    super.dispose();
  }
}
