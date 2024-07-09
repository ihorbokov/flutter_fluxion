import 'package:flutter/material.dart';
import 'package:flutter_fluxion/flutter_fluxion.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: FluxionProvider(
        create: (_) => IncrementFluxion(),
        child: const MyHomePage(
          title: 'Fluxion Demo',
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return FluxionListener<IncrementFluxion, int>(
      listener: (context, state) {
        showDialog<void>(
          context: context,
          builder: (_) => FluxionProvider(
            create: (_) => DialogFluxion(),
            child: AlertDialog(
              title: FluxionBuilder<DialogFluxion, String>(
                builder: (_, state) => Text(state),
              ),
              content: Text('You\'ve clicked $state times!'),
            ),
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'You have pushed the button this many times:',
              ),
              FluxionBuilder<IncrementFluxion, int>(
                builder: (_, state) {
                  return Text(
                    '$state',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: context.read<IncrementFluxion>().increment,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class IncrementFluxion extends Fluxion<int> {
  IncrementFluxion() : super(0);

  void increment() => notify(state + 1);
}

class DialogFluxion extends Fluxion<String> {
  DialogFluxion() : super('Hi there! :)');
}
