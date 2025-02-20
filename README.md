# Adaptive Sidebar Scaffold

[pub-image]: https://img.shields.io/pub/v/adaptive_sidebar.svg
[pub-url]: https://pub.dev/packages/adaptive_sidebar

![Image](https://github.com/ae1dev/adaptive_sidebar/blob/main/example/assets/screenshot.png?raw=true)

A modern, responsive sidebar navigation component for Flutter applications that automatically adapts its size based on screen dimensions and device type. Perfect for creating consistent navigation experiences across desktop, tablet, and mobile interfaces.

## Usage

```dart
AdaptiveSidebar(
    icon: Icon(Symbols.home_rounded),
    title: "Example",
    destinations: [
        SidebarDestination(
            icon: Symbols.home_rounded,
            label: AppLocalizations.of(context)!.home,
        ),
        SidebarDestination(
            icon: Symbols.workspaces_rounded,
            label: AppLocalizations.of(context)!.social,
        ),
        SidebarDestination(
            icon: Symbols.settings_rounded,
            label: AppLocalizations.of(context)!.settings,
        ),
    ],
    onPageChange: (index) {
        //Do something
    },
    body: child,
);

```

## Who's using it?

- [Æ1](https://Æ1.com)
- [Swipefy](https://swipefy.app) - Music discovery app
- [stats.fm](https://stats.fm/) - Spotify and Apple Music analytic's app.
