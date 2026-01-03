import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/casting_call_model.dart';
import '../../models/match_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/matching_engine.dart';

class CastingCallDetailScreen extends StatefulWidget {
  final CastingCall castingCall;

  const CastingCallDetailScreen({super.key, required this.castingCall});

  @override
  State<CastingCallDetailScreen> createState() =>
      _CastingCallDetailScreenState();
}

class _CastingCallDetailScreenState extends State<CastingCallDetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isApplying = false;

  static const _bg = Color(0xFF0A0E21);
  static const _card = Color(0xFF1E1E3F);
  static const _cyan = Color(0xFF00D9FF);
  static const _purple = Color(0xFF7B2FF7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Casting Call',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(call: widget.castingCall),
            const SizedBox(height: 20),
            _InfoSection(call: widget.castingCall),
            const SizedBox(height: 20),
            _DescriptionSection(text: widget.castingCall.description),
            const SizedBox(height: 20),
            _TagSection(
              title: 'Required Skills',
              tags: widget.castingCall.requiredSkills,
            ),
            const SizedBox(height: 16),
            _TagSection(
              title: 'Languages',
              tags: widget.castingCall.requiredLanguages,
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: _bg,
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 54,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isApplying ? null : _applyForRole,
            style: ElevatedButton.styleFrom(
              backgroundColor: _cyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: _isApplying
                ? const CircularProgressIndicator(color: Colors.black)
                : const Text(
                    'Apply for Role',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _applyForRole() async {
    setState(() => _isApplying = true);
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      final match = Match(
        id: '',
        castingCallId: widget.castingCall.id,
        actorId: auth.user!.uid,
        directorId: widget.castingCall.directorId,
        matchScore: 85,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      await _firestoreService.createMatch(match);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Application submitted')));
      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isApplying = false);
    }
  }
}

class _Header extends StatelessWidget {
  final CastingCall call;

  const _Header({required this.call});

  static const _cyan = Color(0xFF00D9FF);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          call.title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          call.characterName,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: _cyan.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  final CastingCall call;

  const _InfoSection({required this.call});

  static const _card = Color(0xFF1E1E3F);
  static const _cyan = Color(0xFF00D9FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cyan.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _InfoItem(label: 'Age', value: '${call.ageMin}-${call.ageMax}'),
          _InfoItem(label: 'Gender', value: call.requiredGender),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final String text;

  const _DescriptionSection({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class _TagSection extends StatelessWidget {
  final String title;
  final List<String> tags;

  const _TagSection({required this.title, required this.tags});

  static const _cyan = Color(0xFF00D9FF);
  static const _purple = Color(0xFF7B2FF7);

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags
              .map(
                (t) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        _cyan.withOpacity(0.12),
                        _purple.withOpacity(0.12),
                      ],
                    ),
                    border: Border.all(color: _cyan.withOpacity(0.4)),
                  ),
                  child: Text(
                    t,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
