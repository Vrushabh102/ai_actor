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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _castingCalls.isEmpty
              ? Center(
                  child: Text(
                    'No casting calls available',
                    style: theme.textTheme.bodyLarge,
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
                              builder: (_) => CastingCallDetailScreen(
                                castingCall: call,
                              ),
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

  const CastingCallCard({
    super.key,
    required this.call,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor =
        isDark ? const Color(0xFF1E1E3F) : Colors.white;
    final borderColor =
        isDark ? Colors.cyanAccent : Colors.blueGrey.shade200;
    final titleColor =
        isDark ? Colors.white : Colors.black;
    final subtitleColor =
        isDark ? Colors.cyanAccent : Colors.blueGrey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              Text(
                call.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              /// CHARACTER NAME
              Text(
                call.characterName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: subtitleColor,
                ),
              ),

              const SizedBox(height: 12),

              /// INFO CHIPS
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(label: 'Age ${call.ageMin}-${call.ageMax}'),
                  _InfoChip(label: call.requiredGender),
                ],
              ),

              const SizedBox(height: 16),

              /// VIEW BUTTON
              Align(
                alignment: Alignment.centerRight,
                child: _GradientButton(
                  text: 'View',
                  onTap: onTap,
                ),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark
            ? Colors.cyan.withOpacity(0.15)
            : Colors.blue.withOpacity(0.1),
        border: Border.all(
          color: isDark ? Colors.cyan : Colors.blueGrey,
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _GradientButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.cyanAccent, Colors.purpleAccent]
                : [Colors.blue, Colors.purple],
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}