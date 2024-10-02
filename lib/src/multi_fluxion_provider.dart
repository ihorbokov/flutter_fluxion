import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/base/base_multi_builder.dart';
import 'package:flutter_fluxion/src/fluxion.dart';
import 'package:flutter_fluxion/src/fluxion_provider.dart';

typedef FlxnProviderBuilder<F extends Fluxion<S>, S extends Object?>
    = FluxionProvider<F, S> Function(Widget child);

class MultiFluxionProvider extends BaseMultiBuilder {
  const MultiFluxionProvider({
    required List<FlxnProviderBuilder> providers,
    required super.child,
    super.key,
  }) : super(builders: providers);
}
