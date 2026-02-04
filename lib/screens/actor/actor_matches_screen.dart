import 'dart:developer';

import 'package:face2screen/screens/actor/view_casting_call_details_screen.dart';
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

  static const _bg = Color(0xFF0A0E21);

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final matches = await _firestoreService.getCastingAcceptedCallMatches();

      setState(() {
        _matches = matches;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      log('Error loading matches: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading matches: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text(
          'Your Matches',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF00D9FF)),
      );
    }

    if (_matches.isEmpty) {
      return const _EmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadMatches,
      color: const Color(0xFF00D9FF),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _matches.length,
        itemBuilder: (_, i) => MatchCard(match: _matches[i]),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty_rounded,
              size: 48,
              color: Colors.white.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'No matches yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'When a director accepts your application,\nit will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final Match match;

  const MatchCard({super.key, required this.match});

  static const _card = Color(0xFF1E1E3F);
  static const _cyan = Color(0xFF00D9FF);
  static const _purple = Color(0xFF7B2FF7);

  @override
  Widget build(BuildContext context) {
    final statusStyle = _statusStyle(match.status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusStyle.color.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: statusStyle.color.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: score + status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MatchScore(score: match.matchScore),
              _StatusBadge(label: match.status, color: statusStyle.color),
            ],
          ),
          const SizedBox(height: 12),

          // Secondary info (clean, non-dev)
          Text(
            'Casting ID • ${match.castingCallId.substring(0, 6).toUpperCase()}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 16),

          // CTA
          SizedBox(
            width: double.infinity,
            height: 44,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) =>
                //         AcceptedMatchCard(castingCallId: match.castingCallId),
                //   ),
                // );
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(colors: [_cyan, _purple]),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _StatusStyle _statusStyle(String status) {
    switch (status) {
      case 'accepted':
        return _StatusStyle(color: const Color(0xFF00FFB2));
      case 'rejected':
        return _StatusStyle(color: const Color(0xFFFF4C4C));
      default:
        return _StatusStyle(color: const Color(0xFFFFB020));
    }
  }
}

class _MatchScore extends StatelessWidget {
  final double score;

  const _MatchScore({required this.score});

  static const _cyan = Color(0xFF00D9FF);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Match Score',
          style: TextStyle(fontSize: 12, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          '${score.toStringAsFixed(1)}%',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _cyan,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withOpacity(0.15),
        border: Border.all(color: color),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: color,
        ),
      ),
    );
  }
}

class _StatusStyle {
  final Color color;

  _StatusStyle({required this.color});
}