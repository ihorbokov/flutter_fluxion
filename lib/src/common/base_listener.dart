import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/common/provider.dart';
import 'package:flutter_fluxion/src/fluxion.dart';

abstract class BaseListener<F extends Fluxion<S>, S> extends StatefulWidget {
  const BaseListener({
    this.fluxion,
    super.key,
  });

  final F? fluxion;
}

abstract class BaseListenerState<F extends Fluxion<S>, S,
    L extends BaseListener<F, S>> extends State<L> {
  late F _fluxion = widget.fluxion ?? context.read<F>();

  @protected
  F get fluxion => _fluxion;

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
    final oldFluxion = oldWidget.fluxion ?? context.read<F>();
    final newFluxion = widget.fluxion ?? oldFluxion;
    if (newFluxion != oldFluxion) _refresh(oldFluxion, newFluxion);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final fluxion = widget.fluxion ?? context.read<F>();
    if (fluxion != _fluxion) _refresh(_fluxion, fluxion);
  }

  void _refresh(F oldFluxion, F newFluxion) {
    oldFluxion.removeListener(onNewState);
    _fluxion = newFluxion;
    newFluxion.addListener(onNewState);
  }

  @override
  void dispose() {
    _fluxion.removeListener(onNewState);
    super.dispose();
  }
}
