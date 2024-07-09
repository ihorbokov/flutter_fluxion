import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/common/base_listener.dart';
import 'package:flutter_fluxion/src/fluxion.dart';

typedef ListenerCondition<S> = bool Function(S previous, S current);

typedef StateListener<S> = Widget Function(BuildContext context, S state);

class FluxionListener<F extends Fluxion<S>, S> extends BaseListener<F, S> {
  const FluxionListener({
    required this.listener,
    required this.child,
    this.listenWhen,
    super.fluxion,
  });

  final StateListener<S> listener;
  final ListenerCondition<S>? listenWhen;

  final Widget child;

  @override
  State<FluxionListener<F, S>> createState() => _FluxionListenerState<F, S>();
}

class _FluxionListenerState<F extends Fluxion<S>, S>
    extends BaseListenerState<F, S, FluxionListener<F, S>> {
  S get _state => fluxion.state;

  @override
  void onNewState(S state) {
    if (widget.listenWhen?.call(_state, state) ?? true) {
      widget.listener(context, state);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
