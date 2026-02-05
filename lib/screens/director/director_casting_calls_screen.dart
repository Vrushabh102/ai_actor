import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/casting_call_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import 'create_casting_call_screen.dart';
import 'matches_screen.dart';

class DirectorCastingCallsScreen extends StatefulWidget {
  const DirectorCastingCallsScreen({Key? key}) : super(key: key);

  @override
  State<DirectorCastingCallsScreen> createState() =>
      _DirectorCastingCallsScreenState();
}

class _DirectorCastingCallsScreenState
    extends State<DirectorCastingCallsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<CastingCall> _castingCalls = [];
  bool _isLoading = true;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCastingCalls();
  }

  Future<void> _loadCastingCalls() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final calls = await _firestoreService.getDirectorCastingCalls(
        authProvider.user!.uid,
      );
      setState(() {
        _castingCalls = calls;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        /// ✅ THEME AWARE APP BAR
        AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          title: Text('My Casting Calls', style: theme.textTheme.titleLarge),
          iconTheme: theme.iconTheme,
        ),

        /// ✅ BODY CONTENT
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(theme),
        ),
      ],
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (_castingCalls.isEmpty) {
      return Center(
        child: Text('No Casting Calls Yet', style: theme.textTheme.titleMedium),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _castingCalls.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CastingCallCard(
            call: _castingCalls[index],
            onRefresh: _loadCastingCalls,
          ),
        );
      },
    );
  }

  void _navigateToCreateCall() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateCastingCallScreen()),
    ).then((_) => _loadCastingCalls());
  }
}

/// ================= CARD =================

class CastingCallCard extends StatelessWidget {
  final CastingCall call;
  final VoidCallback onRefresh;

  const CastingCallCard({Key? key, required this.call, required this.onRefresh})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            call.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(call.characterName, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
          Text(
            call.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MatchesScreen(isActor: true),
                  ),
                ).then((_) => onRefresh());
              },
              child: const Text('View Matches'),
            ),
          ),
        ],
      ),
    );
  }
}
