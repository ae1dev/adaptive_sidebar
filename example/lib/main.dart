import 'package:adaptive_sidebar/adaptive_sidebar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'adaptive_sidebar Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TabsView(),
    );
  }
}

class TabsView extends StatefulWidget {
  const TabsView({super.key});
  @override
  State<TabsView> createState() => _TabsViewState();
}

class _TabsViewState extends State<TabsView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdaptiveSidebar(
        icon: const Icon(Icons.home_rounded),
        title: "Example",
        destinations: [
          SidebarDestination(
            icon: Icons.home_rounded,
            label: "Home",
          ),
          SidebarDestination(
            icon: Icons.settings_rounded,
            label: "Settings",
          ),
        ],
        onPageChange: (index) {
          _pageController.jumpToPage(index);
        },
        body: PageView(
          controller: _pageController,
          children: const [
            HomeView(),
            SettingsView(),
          ],
        ),
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Home Tab',
        ),
      ),
    );
  }
}

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});
  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Settings Tab',
        ),
      ),
    );
  }
}
