import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/base/base_multi_builder.dart';
import 'package:flutter_fluxion/src/fluxion.dart';
import 'package:flutter_fluxion/src/fluxion_listener.dart';

typedef FlxnListenerBuilder<F extends Fluxion<S>, S extends Object?>
    = FluxionListener<F, S> Function(Widget child);

class MultiFluxionListener extends BaseMultiBuilder {
  const MultiFluxionListener({
    required List<FlxnListenerBuilder> listeners,
    required super.child,
    super.key,
  }) : super(builders: listeners);
}
