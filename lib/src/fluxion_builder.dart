import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/common/base_listener.dart';
import 'package:flutter_fluxion/src/fluxion.dart';

typedef BuilderCondition<S> = bool Function(S previous, S current);

typedef WidgetBuilder<S> = Widget Function(BuildContext context, S state);

class FluxionBuilder<F extends Fluxion<S>, S> extends BaseListener<F, S> {
  const FluxionBuilder({
    required this.builder,
    this.buildWhen,
    super.fluxion,
  });

  final WidgetBuilder<S> builder;
  final BuilderCondition<S>? buildWhen;

  @override
  State<FluxionBuilder<F, S>> createState() => _FluxionBuilderState<F, S>();
}

class _FluxionBuilderState<F extends Fluxion<S>, S>
    extends BaseListenerState<F, S, FluxionBuilder<F, S>> {
  late S _state = fluxion.state;

  @override
  void onNewState(S state) {
    if (widget.buildWhen?.call(_state, state) ?? true) {
      setState(() => _state = state);
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _state);
}
