import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/match_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class ActorMatchesScreen extends StatefulWidget {
  const ActorMatchesScreen({Key? key}) : super(key: key);

  @override
  State<ActorMatchesScreen> createState() => _ActorMatchesScreenState();
}

class _ActorMatchesScreenState extends State<ActorMatchesScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Match> _matches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final matches = await _firestoreService.getActorMatches(authProvider.user!.uid);
      setState(() {
        _matches = matches;
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
          : _matches.isEmpty
              ? const Center(child: Text('No matches yet'))
              : RefreshIndicator(
                  onRefresh: _loadMatches,
                  child: ListView.builder(
                    itemCount: _matches.length,
                    itemBuilder: (context, index) {
                      final match = _matches[index];
                      return MatchCard(match: match);
                    },
                  ),
                ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final Match match;

  const MatchCard({Key? key, required this.match}) : super(key: key);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Match Score: ${match.matchScore.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B4965),
                  ),
                ),
                _buildStatusBadge(match.status),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Casting Call ID: ${match.castingCallId.substring(0, 8)}...',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D7A8C),
                ),
                onPressed: () {
                  // View details
                },
                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = status == 'accepted'
        ? Colors.green
        : status == 'rejected'
            ? Colors.red
            : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}