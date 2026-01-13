import 'package:flutter/material.dart';
import 'package:personal_growth_app/features/today/presentation/today_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.today),
                label: Text('Today'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.water_drop), // Bucket icon placeholder
                label: Text('Buckets'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _selectedIndex == 0
                ? const TodayPage()
                : const Center(child: Text('Buckets (Coming Soon)')),
          ),
        ],
      ),
    );
  }
}
