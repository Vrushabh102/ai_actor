import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'casting_calls_screen.dart';
import 'actor_matches_screen.dart';
import 'actor_profile_screen.dart';

class ActorHomeScreen extends StatefulWidget {
  const ActorHomeScreen({Key? key}) : super(key: key);

  @override
  State<ActorHomeScreen> createState() => _ActorHomeScreenState();
}

class _ActorHomeScreenState extends State<ActorHomeScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    /// ✅ PROVIDER – THIS IS NOW 100% SAFE
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    /// 🔐 USER NULL CHECK (VERY IMPORTANT)
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    /// ✅ SCREENS (NO ERROR HERE)
    final List<Widget> screens = [
      const CastingCallsScreen(),
      const ActorMatchesScreen(),
      const ActorProfileScreen(),
    ];

    return Theme(
      data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        key: _scaffoldKey,

        /// 🔝 APP BAR
        appBar: AppBar(
          backgroundColor: _isDarkMode ? Colors.black : const Color(0xFF1B4965),
          title: const Text(
            'Face2Screen',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ],
        ),

        /// 📂 DRAWER
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

              /// 🚪 LOGOUT
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

        /// 🧱 BODY
        body: SafeArea(child: screens[_selectedIndex]),

        /// 🔻 BOTTOM NAV
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Calls'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Matches'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
