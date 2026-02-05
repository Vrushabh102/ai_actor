import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'director_casting_calls_screen.dart';
import 'director_matches_screen.dart';
import 'create_casting_call_screen.dart';

class DirectorHomeScreen extends StatefulWidget {
  const DirectorHomeScreen({Key? key}) : super(key: key);

  @override
  State<DirectorHomeScreen> createState() => _DirectorHomeScreenState();
}

class _DirectorHomeScreenState extends State<DirectorHomeScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    /// ✅ CHILD SCREENS (NO BOTTOM NAV INSIDE THEM)
    final screens = [
      const DirectorCastingCallsScreen(),
      const DirectorMatchesScreen(),
      const Center(child: Text('Chats Screen', style: TextStyle(fontSize: 20))),
      const Center(
        child: Text('Account Screen', style: TextStyle(fontSize: 20)),
      ),
    ];

    final ThemeData directorTheme = _isDarkMode
        ? ThemeData.dark()
        : ThemeData.light();

    return Theme(
      data: directorTheme,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: _isDarkMode ? const Color(0xFF121212) : Colors.white,

        /// ✅ APP BAR
        appBar: AppBar(
          title: const Text('Face2Screen Director'),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ],
        ),

        /// ✅ DRAWER
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: _isDarkMode ? Colors.black : const Color(0xFF1B4965),
                ),
                child: const Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications coming soon')),
                  );
                },
              ),

              /// 🌗 DARK / LIGHT MODE
              SwitchListTile(
                secondary: Icon(
                  _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
                title: Text(_isDarkMode ? 'Dark Mode' : 'Light Mode'),
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() => _isDarkMode = value);
                },
              ),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  authProvider.logout();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),

        /// ✅ BODY (ONLY CONTENT, NO NAV)
        body: SafeArea(child: screens[_selectedIndex]),

        /// ✅ FLOATING ACTION BUTTON (only for Casting Calls screen)
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton.extended(
                backgroundColor: directorTheme.colorScheme.primary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateCastingCallScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('New'),
              )
            : null,

        /// ✅ SINGLE BOTTOM NAV (NO DUPLICATE)
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: _isDarkMode ? const Color(0xFF121212) : Colors.white,
          currentIndex: _selectedIndex,
          selectedItemColor: _isDarkMode
              ? Colors.blueAccent
              : const Color(0xFF1B4965),
          unselectedItemColor: _isDarkMode ? Colors.grey.shade400 : Colors.grey,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Casting'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Matches'),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Chats',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          ],
        ),
      ),
    );
  }
}
