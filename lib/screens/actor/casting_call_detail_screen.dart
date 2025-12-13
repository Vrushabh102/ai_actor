import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/casting_call_model.dart';
import '../../models/match_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/matching_engine.dart';

class CastingCallDetailScreen extends StatefulWidget {
  final CastingCall castingCall;

  const CastingCallDetailScreen({Key? key, required this.castingCall})
      : super(key: key);

  @override
  State<CastingCallDetailScreen> createState() =>
      _CastingCallDetailScreenState();
}

class _CastingCallDetailScreenState extends State<CastingCallDetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isApplying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4965),
        title: const Text('Casting Call Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.castingCall.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B4965),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Character:', widget.castingCall.characterName),
            _buildDetailRow('Age Range:', '${widget.castingCall.ageMin} - ${widget.castingCall.ageMax}'),
            _buildDetailRow('Gender:', widget.castingCall.requiredGender),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.castingCall.description),
            const SizedBox(height: 16),
            _buildTagList('Required Skills:', widget.castingCall.requiredSkills),
            const SizedBox(height: 8),
            _buildTagList('Required Languages:', widget.castingCall.requiredLanguages),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B4965),
                ),
                onPressed: _isApplying ? null : _applyForRole,
                child: _isApplying
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Apply for Role'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildTagList(String title, List<String> tags) {
    if (tags.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: tags
              .map(
                (tag) => Chip(
                  label: Text(tag),
                  backgroundColor: const Color(0xFF2D7A8C).withOpacity(0.2),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  void _applyForRole() async {
    setState(() => _isApplying = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Create a match record
      final match = Match(
        id: '', // Firestore will generate
        castingCallId: widget.castingCall.id,
        actorId: authProvider.user!.uid,
        directorId: widget.castingCall.directorId,
        matchScore: 85.0, // Demo score
        status: 'pending',
        createdAt: DateTime.now(),
      );

      await _firestoreService.createMatch(match);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isApplying = false);
      }
    }
  }
}