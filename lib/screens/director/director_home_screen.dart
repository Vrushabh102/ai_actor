import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'director_casting_calls_screen.dart';
import 'director_matches_screen.dart';

class DirectorHomeScreen extends StatefulWidget {
  const DirectorHomeScreen({Key? key}) : super(key: key);

  @override
  State<DirectorHomeScreen> createState() => _DirectorHomeScreenState();
}

class _DirectorHomeScreenState extends State<DirectorHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final screens = [
      const DirectorCastingCallsScreen(),
      const DirectorMatchesScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4965),
        title: const Text('Face2Screen Director', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => authProvider.logout(),
          ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF1B4965),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Casting Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Matches',
          ),
        ],
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}