# Adaptive Sidebar

[pub-image]: https://img.shields.io/pub/v/adaptive_sidebar.svg
[pub-url]: https://pub.dev/packages/adaptive_sidebar

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
- [stats.fm](https://stats.fm/) - Spotify and Apple Music analytic's app.

## API

### child

The content you want to display with a sidebar.

### destinations

Sidebar page options

### pinnedDestination [optional]

This will be shown on top of the destination list

### footerDestinations [optional]

These destinations will be pinned at the footer

### onPageChange

Called when a new destination has been selected

### icon

Icon shown before the title

### title [optional]

Title of the app

### titleStyle [optional]

Style of the title of the app

### destinationsTextStyle [optional]

Text style of the destinations

### selectedColor [optional]

The text and icon color of the selected destination (will defualt to Theme.of(context).primaryColor if none is provided)

### floatingShadow [optional]

Show a shadow around the sidebar when using the floating sidebar style.

### maxLargeSidebarSize

size of the sidebar (Default: 192)

### macOSTopPadding

Add 30px padding to the top on macOS

### mediumAuto

Auto enable medium layout if passing medium breakpoint

### mediumBreakpoint

The breakpoint size of the child space for the medium icon only layout

### mediumManualButton

Manually enable and disable the medium layout

### bottomNavigationBar [optional]

Show a bottomNavigationBar on smaller devices useing the bottomNavigationBarBreakpoint.

If no bottom navigation bar is given it will ignore the bottomNavigationBarBreakpoint and always show the sidebar.

### bottomNavigationBarBreakpoint

Breakpoint of when the sidebar is enabled and the bottom navigation bar is no longer used.

### backgroundWidget [optional]

Display a widget in the background behind the page and the sidebar.
