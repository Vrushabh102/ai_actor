import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'actor_profile_screen.dart';
import 'casting_calls_screen.dart';
import 'actor_matches_screen.dart';

class ActorHomeScreen extends StatefulWidget {
  const ActorHomeScreen({Key? key}) : super(key: key);

  @override
  State<ActorHomeScreen> createState() => _ActorHomeScreenState();
}

class _ActorHomeScreenState extends State<ActorHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final screens = [
      ActorProfileScreen(user: authProvider.user!),
      const CastingCallsScreen(),
      const ActorMatchesScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4965),
        title: const Text('Face2Screen', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => authProvider.logout(),
          ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0A0E21),
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(255, 141, 136, 136),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Calls'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Matches'),
        ],
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
