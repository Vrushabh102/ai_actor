import 'package:flutter/material.dart';
import 'package:face2screen/models/match_model.dart';

class AcceptedMatchCard extends StatelessWidget {

  final String castingCallId;

  const AcceptedMatchCard({Key? key, required this.castingCallId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        title: const Text('Match Details'),
      ),
      
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Divider(color: Color(0xFF1D1E33), height: 16),
        ],
      ),
    );
  }
}
