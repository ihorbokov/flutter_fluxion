import 'package:flutter/material.dart';
import 'package:flutter_fluxion/src/fluxion.dart';
import 'package:flutter_fluxion/src/fluxion_builder.dart';
import 'package:flutter_fluxion/src/fluxion_listener.dart';

/// A Flutter widget that combines both listening to and building with
/// state changes from a [Fluxion].
///
/// This widget uses [FluxionListener] to handle side-effects in response
/// to state changes and [FluxionBuilder] to build the UI based on the state.
/// The generic types [F] and [S] represent the specific type of [Fluxion]
/// and its state, respectively.
class FluxionConsumer<F extends Fluxion<S>, S> extends StatelessWidget {
  /// Creates a [FluxionConsumer] widget.
  ///
  /// It requires a [listener] to handle state changes, a [builder] to create
  /// the UI, and optionally, conditions under which to listen ([listenWhen])
  /// and build ([buildWhen]).
  ///
  /// The [fluxion] can also be provided directly; if not provided,
  /// it will be obtained from the nearest Provider context.
  const FluxionConsumer({
    required this.listener,
    required this.builder,
    this.fluxion,
    this.buildWhen,
    this.listenWhen,
    super.key,
  });

  /// The [Fluxion] this widget is connected to. It can be null, in which
  /// case the fluxion will be obtained from the nearest Provider context.
  final F? fluxion;

  /// A callback that is called in response to state changes. This is
  /// where side-effects in response to state updates should be handled.
  final FlxnWidgetListener<S> listener;

  /// A condition that determines whether the listener should be triggered.
  /// If null, the listener will be called on every state change.
  final FlxnListenerCondition<S>? listenWhen;

  /// A builder function that is used to create the widget tree based
  /// on the state.
  final FlxnWidgetBuilder<S> builder;

  /// A condition that determines whether the widget should rebuild when the
  /// state changes. If null, the widget will rebuild on every state change.
  final FlxnBuilderCondition<S>? buildWhen;

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
