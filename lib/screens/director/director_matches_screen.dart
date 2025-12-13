import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/match_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class DirectorMatchesScreen extends StatefulWidget {
  const DirectorMatchesScreen({Key? key}) : super(key: key);

  @override
  State<DirectorMatchesScreen> createState() => _DirectorMatchesScreenState();
}

class _DirectorMatchesScreenState extends State<DirectorMatchesScreen> {
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
      // Load all matches (would need to implement by directorId)
      // For now, showing placeholder
      setState(() {
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
              ? const Center(
                  child: Text('No actor matches yet. Create a casting call first!'),
                )
              : RefreshIndicator(
                  onRefresh: _loadMatches,
                  child: ListView.builder(
                    itemCount: _matches.length,
                    itemBuilder: (context, index) {
                      final match = _matches[index];
                      return DirectorMatchCard(match: match);
                    },
                  ),
                ),
    );
  }
}

class DirectorMatchCard extends StatefulWidget {
  final Match match;

  const DirectorMatchCard({Key? key, required this.match}) : super(key: key);

  @override
  State<DirectorMatchCard> createState() => _DirectorMatchCardState();
}

class _DirectorMatchCardState extends State<DirectorMatchCard> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isUpdating = false;

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
              'Match Score: ${widget.match.matchScore.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B4965),
              ),
            ),
            const SizedBox(height: 12),
            Text('Actor ID: ${widget.match.actorId.substring(0, 8)}...'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: _isUpdating ? null : () => _updateStatus('accepted'),
                    child: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: _isUpdating ? null : () => _updateStatus('rejected'),
                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatus(String status) async {
    setState(() => _isUpdating = true);
    try {
      await _firestoreService.updateMatchStatus(widget.match.id, status);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Match $status')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }
}