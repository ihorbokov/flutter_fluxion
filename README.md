<p align="center">
<img src="https://raw.githubusercontent.com/ihorbokov/flutter_fluxion/master/assets/logo.png" height="200" alt="Fluxion Package" />
</p>

<p align="center">
<a href="https://pub.dev/packages/flutter_fluxion"><img src="https://img.shields.io/pub/v/flutter_fluxion.svg" alt="Pub"></a>
<a href="https://github.com/ihorbokov/flutter_fluxion/actions"><img src="https://github.com/ihorbokov/flutter_fluxion/actions/workflows/build.yml/badge.svg" alt="build"></a>
<a href="https://app.codecov.io/gh/ihorbokov/flutter_fluxion"><img src="https://codecov.io/gh/ihorbokov/flutter_fluxion/branch/master/graph/badge.svg" alt="codecov"></a>
<a href="https://pub.dev/packages/very_good_analysis"><img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="style: very good analysis"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

# Fluxion
Flutter Fluxion is a highly reactive state management library designed to optimize and simplify state management in Flutter applications. Built with performance and minimal UI re-renders in mind, it offers a variety of tools to control and update the UI efficiently. Inspired by the popular [flutter_bloc](https://pub.dev/packages/flutter_bloc) library.

## Features
- **Reactive State Management**: Easily manage and emit changes to your state, ensuring your UI updates seamlessly.
- **Selective Rebuilding**: Use `FluxionBuilder`, `FluxionConsumer`, and `FluxionSelector` to rebuild only the parts of your UI that actually need updating.
- **Performance Optimized**: Minimizes unnecessary widget rebuilds, ensuring your app remains fast and responsive.
- **Dynamic State Listening**: `FluxionListener` allows you to react to state changes anywhere in your app without rebuilding the UI, making it ideal for triggering actions like navigation or showing dialogs based on state changes.
- **Contextual State Provision**: `FluxionProvider` simplifies state management by making it accessible throughout the widget subtree, enabling you to manage and access state easily without boilerplate.