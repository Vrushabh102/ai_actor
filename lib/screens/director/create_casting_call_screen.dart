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

  // Available options for skills and languages
  final List<String> _availableSkills = [
    'Acting',
    'Dancing',
    'Singing',
    'Martial Arts',
    'Comedy',
    'Drama',
    'Action',
    'Stunt Work',
    'Voice Acting',
    'Modeling',
  ];

  final List<String> _availableLanguages = [
    'English',
    'Hindi',
    'Spanish',
    'French',
    'Mandarin',
    'Japanese',
    'Korean',
    'German',
    'Italian',
    'Portuguese',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: const Color(0xFF0A0E21),
            iconTheme: const IconThemeData(color: Color(0xFF00D9FF)),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF00D9FF).withOpacity(0.3),
                      const Color(0xFF7B2FF7).withOpacity(0.3),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00D9FF), Color(0xFF7B2FF7)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.movie_creation_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Create Casting Call',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Basic Information'),
                  const SizedBox(height: 16),
                  _buildInputField(
                    controller: _titleController,
                    label: 'Casting Title',
                    icon: Icons.title_rounded,
                    hint: 'e.g., Lead Role for Action Film',
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    controller: _characterNameController,
                    label: 'Character Name',
                    icon: Icons.person_outline_rounded,
                    hint: 'e.g., Detective James',
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    controller: _descriptionController,
                    label: 'Description',
                    icon: Icons.description_outlined,
                    hint: 'Describe the role and requirements...',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 32),

                  _buildSectionTitle('Age Requirements'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          controller: _ageMinController,
                          label: 'Min Age',
                          icon: Icons.cake_outlined,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInputField(
                          controller: _ageMaxController,
                          label: 'Max Age',
                          icon: Icons.cake_rounded,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  _buildSectionTitle('Gender Preference'),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    value: _selectedGender,
                    label: 'Gender',
                    icon: Icons.wc_rounded,
                    items: ['Any', 'Male', 'Female', 'Other'],
                    onChanged: (value) {
                      if (value != null)
                        setState(() => _selectedGender = value);
                    },
                  ),
                  const SizedBox(height: 32),

                  _buildSectionTitle('Required Skills'),
                  const SizedBox(height: 16),
                  _buildChipSelector(
                    items: _availableSkills,
                    selectedItems: _selectedSkills,
                    onChanged: (selected) {
                      setState(() => _selectedSkills = selected);
                    },
                  ),
                  const SizedBox(height: 32),

                  _buildSectionTitle('Required Languages'),
                  const SizedBox(height: 16),
                  _buildChipSelector(
                    items: _availableLanguages,
                    selectedItems: _selectedLanguages,
                    onChanged: (selected) {
                      setState(() => _selectedLanguages = selected);
                    },
                  ),
                  const SizedBox(height: 48),

                  // Create Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00D9FF), Color(0xFF7B2FF7)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D9FF).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _isCreating ? null : _createCastingCall,
                      child: _isCreating
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              'Create Casting Call',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00D9FF), Color(0xFF7B2FF7)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E3F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00D9FF).withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          prefixIcon: Icon(icon, color: const Color(0xFF00D9FF)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E3F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00D9FF).withOpacity(0.2)),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: const Color(0xFF1E1E3F),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          prefixIcon: Icon(icon, color: const Color(0xFF00D9FF)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(color: Colors.white)),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildChipSelector({
    required List<String> items,
    required List<String> selectedItems,
    required Function(List<String>) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E3F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00D9FF).withOpacity(0.2)),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: items.map((item) {
          final isSelected = selectedItems.contains(item);
          return GestureDetector(
            onTap: () {
              final newSelected = List<String>.from(selectedItems);
              if (isSelected) {
                newSelected.remove(item);
              } else {
                newSelected.add(item);
              }
              onChanged(newSelected);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF00D9FF), Color(0xFF7B2FF7)],
                      )
                    : null,
                color: isSelected ? null : const Color(0xFF0A0E21),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : const Color(0xFF00D9FF).withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  if (isSelected) const SizedBox(width: 6),
                  Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF00D9FF),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _createCastingCall() async {
    if (_titleController.text.isEmpty ||
        _characterNameController.text.isEmpty ||
        _ageMinController.text.isEmpty ||
        _ageMaxController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all required fields'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
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
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Casting call created successfully!'),
              ],
            ),
            backgroundColor: const Color(0xFF00D9FF),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
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
