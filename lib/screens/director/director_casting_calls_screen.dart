import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/casting_call_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import 'create_casting_call_screen.dart';

class DirectorCastingCallsScreen extends StatefulWidget {
  const DirectorCastingCallsScreen({Key? key}) : super(key: key);

  @override
  State<DirectorCastingCallsScreen> createState() =>
      _DirectorCastingCallsScreenState();
}

class _DirectorCastingCallsScreenState extends State<DirectorCastingCallsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<CastingCall> _castingCalls = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCastingCalls();
  }

  Future<void> _loadCastingCalls() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final calls = await _firestoreService.getDirectorCastingCalls(authProvider.user!.uid);
      setState(() {
        _castingCalls = calls;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _castingCalls.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No casting calls yet'),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B4965),
                        ),
                        onPressed: () => _navigateToCreateCall(),
                        child: const Text('Create First Casting Call'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadCastingCalls,
                  child: ListView.builder(
                    itemCount: _castingCalls.length,
                    itemBuilder: (context, index) {
                      final call = _castingCalls[index];
                      return CastingCallTile(call: call);
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1B4965),
        onPressed: _navigateToCreateCall,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToCreateCall() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateCastingCallScreen(),
      ),
    ).then((_) => _loadCastingCalls());
  }
}

class CastingCallTile extends StatelessWidget {
  final CastingCall call;

  const CastingCallTile({Key? key, required this.call}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              call.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B4965),
              ),
            ),
            const SizedBox(height: 8),
            Text('Character: ${call.characterName}'),
            const SizedBox(height: 8),
            Text('Age: ${call.ageMin} - ${call.ageMax}'),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D7A8C),
              ),
              onPressed: () {
                // View matches for this call
              },
              child: const Text('View Matches'),
            ),
          ],
        ),
      ),
    );
  }
}