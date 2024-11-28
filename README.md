# Adaptive Sidebar

[pub-image]: https://img.shields.io/pub/v/adaptive_sidebar.svg
[pub-url]: https://pub.dev/packages/adaptive_sidebar

![Image](https://github.com/ae1dev/adaptive_sidebar/blob/main/example/assets/screenshot.png?raw=true)

Sleak sidebar for responsive Flutter apps with automatic size change.

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
    child: child,
);

```

## Who's using it?

- [Æ1](https://Æ1.com)
- [Swipefy](https://swipefy.app) - Music discovery app
- [stats.fm](https://stats.fm/) - Spotify and Apple Music analytic's app.
