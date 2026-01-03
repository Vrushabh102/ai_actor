import 'package:flutter/material.dart';
import '../../models/casting_call_model.dart';
import '../../services/firestore_service.dart';
import 'casting_call_detail_screen.dart';

class CastingCallsScreen extends StatefulWidget {
  const CastingCallsScreen({Key? key}) : super(key: key);

  @override
  State<CastingCallsScreen> createState() => _CastingCallsScreenState();
}

class _CastingCallsScreenState extends State<CastingCallsScreen> {
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
      final calls = await _firestoreService.getAllCastingCalls();
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
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _castingCalls.isEmpty
          ? const Center(
              child: Text(
                'No casting calls available',
                style: TextStyle(color: Colors.white),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadCastingCalls,
              child: ListView.builder(
                itemCount: _castingCalls.length,
                itemBuilder: (context, index) {
                  final call = _castingCalls[index];
                  return CastingCallCard(
                    call: call,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CastingCallDetailScreen(castingCall: call),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}

class CastingCallCard extends StatelessWidget {
  final CastingCall call;
  final VoidCallback onTap;

  const CastingCallCard({super.key, required this.call, required this.onTap});

  static const _bgColor = Color(0xFF1E1E3F);
  static const _cyan = Color(0xFF00D9FF);
  static const _purple = Color(0xFF7B2FF7);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cyan.withOpacity(0.35), width: 1),
          boxShadow: [
            BoxShadow(
              color: _purple.withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                call.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              // Character name
              Text(
                call.characterName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _cyan.withOpacity(0.9),
                ),
              ),

              const SizedBox(height: 12),

              // Chips row
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(label: 'Age ${call.ageMin}-${call.ageMax}'),
                  _InfoChip(label: call.requiredGender),
                ],
              ),

              const SizedBox(height: 16),

              // CTA row
              Align(
                alignment: Alignment.centerRight,
                child: _GradientButton(text: 'View', onTap: onTap),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  static const _cyan = Color(0xFF00D9FF);
  static const _purple = Color(0xFF7B2FF7);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [_cyan.withOpacity(0.12), _purple.withOpacity(0.12)],
        ),
        border: Border.all(color: _cyan.withOpacity(0.4), width: 0.8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _GradientButton({required this.text, required this.onTap});

  static const _cyan = Color(0xFF00D9FF);
  static const _purple = Color(0xFF7B2FF7);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(colors: [_cyan, _purple]),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
