import 'package:flutter/material.dart' hide WidgetBuilder;
import 'package:flutter_fluxion/src/fluxion.dart';
import 'package:flutter_fluxion/src/fluxion_builder.dart';
import 'package:flutter_fluxion/src/fluxion_listener.dart';

class FluxionConsumer<F extends Fluxion<S>, S> extends StatelessWidget {
  const FluxionConsumer({
    required this.listener,
    required this.builder,
    this.fluxion,
    this.buildWhen,
    this.listenWhen,
    super.key,
  });

  final F? fluxion;

  final StateListener<S> listener;
  final ListenerCondition<S>? listenWhen;

  final WidgetBuilder<S> builder;
  final BuilderCondition<S>? buildWhen;

  @override
  Widget build(BuildContext context) {
    return FluxionListener<F, S>(
      fluxion: fluxion,
      listener: listener,
      listenWhen: listenWhen,
      child: FluxionBuilder(
        fluxion: fluxion,
        builder: builder,
        buildWhen: buildWhen,
      ),
    );
  }
}
