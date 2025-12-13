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
              ? const Center(child: Text('No casting calls available'))
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
                              builder: (context) => CastingCallDetailScreen(castingCall: call),
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
    Key? key,
    required this.call,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
              Text(
                'Character: ${call.characterName}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                'Age: ${call.ageMin} - ${call.ageMax}',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gender: ${call.requiredGender}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D7A8C),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    onPressed: onTap,
                    child: const Text('View'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}