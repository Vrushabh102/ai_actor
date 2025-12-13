import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
// import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/actor/actor_home_screen.dart';
import 'screens/director/director_home_screen.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Face2Screen',
        theme: ThemeData(
          primaryColor: const Color(0xFF1B4965),
          secondaryHeaderColor: const Color(0xFF2D7A8C),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return FutureBuilder(
              future: authProvider.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen();
                }
                
                if (authProvider.isAuthenticated) {
                  if (authProvider.userRole == 'actor') {
                    return const ActorHomeScreen();
                  } else {
                    return const DirectorHomeScreen();
                  }
                }
                
                return const LoginScreen();
              },
            );
          },
        ),
      ),
    );
  }
}