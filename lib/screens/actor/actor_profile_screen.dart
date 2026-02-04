import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActorProfileScreen extends StatelessWidget {
  // final User user;

  const ActorProfileScreen({
    Key? key,
    // required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: theme.cardColor,
          elevation: isDark ? 2 : 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 👤 PROFILE ICON
                Center(
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: theme.colorScheme.primary,
                    child: const Icon(
                      Icons.person,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 📧 EMAIL
                Text(
                  'Email',
                  style: theme.textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Not available',
                  style: theme.textTheme.titleMedium,
                ),

                const SizedBox(height: 16),

                /// 🆔 USER ID
                Text(
                  'User ID',
                  style: theme.textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Not available',
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                /// ✏️ EDIT PROFILE BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Edit Profile coming soon'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}