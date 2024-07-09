import 'dart:async';

import 'package:flutter/material.dart';

class StreamListener<T> extends StatefulWidget {
  const StreamListener({
    required this.stream,
    required this.onData,
    required this.child,
    this.onError,
    this.onDone,
    this.cancelOnError = false,
    super.key,
  });

  final Stream<T> stream;
  final bool cancelOnError;
  final void Function()? onDone;
  final void Function(T data) onData;
  final void Function(dynamic error, StackTrace stackTrace)? onError;

  final Widget child;

  @override
  State<StreamListener<T>> createState() => _StreamListenerState<T>();
}

class _StreamListenerState<T> extends State<StreamListener<T>> {
  late final StreamSubscription<T> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.stream.listen(
      widget.onData,
      onError: widget.onError,
      onDone: widget.onDone,
      cancelOnError: widget.cancelOnError,
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
