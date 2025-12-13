import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/casting_call_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class CreateCastingCallScreen extends StatefulWidget {
  const CreateCastingCallScreen({Key? key}) : super(key: key);

  @override
  State<CreateCastingCallScreen> createState() =>
      _CreateCastingCallScreenState();
}

class _CreateCastingCallScreenState extends State<CreateCastingCallScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _characterNameController = TextEditingController();
  final _ageMinController = TextEditingController();
  final _ageMaxController = TextEditingController();
  String _selectedGender = 'Any';
  List<String> _selectedSkills = [];
  List<String> _selectedLanguages = [];
  bool _isCreating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4965),
        title: const Text('Create Casting Call'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Casting Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _characterNameController,
              decoration: const InputDecoration(labelText: 'Character Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageMinController,
              decoration: const InputDecoration(labelText: 'Minimum Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageMaxController,
              decoration: const InputDecoration(labelText: 'Maximum Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(labelText: 'Gender Requirement'),
              items: ['Any', 'Male', 'Female', 'Other']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedGender = value);
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B4965),
                ),
                onPressed: _isCreating ? null : _createCastingCall,
                child: _isCreating
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Create Casting Call'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createCastingCall() async {
    if (_titleController.text.isEmpty ||
        _characterNameController.text.isEmpty ||
        _ageMinController.text.isEmpty ||
        _ageMaxController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    setState(() => _isCreating = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final castingCall = CastingCall(
        id: '',
        directorId: authProvider.user!.uid,
        title: _titleController.text,
        description: _descriptionController.text,
        characterName: _characterNameController.text,
        requiredGender: _selectedGender,
        ageMin: int.parse(_ageMinController.text),
        ageMax: int.parse(_ageMaxController.text),
        requiredSkills: _selectedSkills,
        requiredLanguages: _selectedLanguages,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );

      await _firestoreService.createCastingCall(castingCall);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Casting call created successfully!')),
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
        setState(() => _isCreating = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _characterNameController.dispose();
    _ageMinController.dispose();
    _ageMaxController.dispose();
    super.dispose();
  }
}