import 'package:flutter/material.dart';
import '../../models/match_model.dart';
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
      final matches = await _firestoreService.getActorMatches();
      setState(() {
        _matches = matches;
        _matches = _matches.where((m) => m.status == 'accepted').toList();
      });
      setState(() {
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
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _matches.isEmpty
        ? const Center(
            child: Text(
              'No actor matches yet. Create a casting call first!',
              style: TextStyle(color: Colors.white),
            ),
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
      color: const Color(0xFF1B4965),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Match Score: ${widget.match.matchScore.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(widget.match.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.match.status.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Actor ID: ${widget.match.actorId.substring(0, 8)}...',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Casting Call: ${widget.match.castingCallId.substring(0, 8)}...',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Matched: ${_formatDate(widget.match.createdAt)}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'interested':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  void _updateStatus(String status) async {
    setState(() => _isUpdating = true);
    try {
      await _firestoreService.updateMatchStatus(widget.match.id, status);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Match $status')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }
}
