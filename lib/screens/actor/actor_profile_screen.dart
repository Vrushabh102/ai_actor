import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/actor_profile_model.dart';
import '../../services/firestore_service.dart';

class ActorProfileScreen extends StatefulWidget {
  final UserModel user;

  const ActorProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ActorProfileScreen> createState() => _ActorProfileScreenState();
}

class _ActorProfileScreenState extends State<ActorProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  ActorProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _firestoreService.getActorProfile(widget.user.uid);
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profile == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Complete Your Profile'),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B4965),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(userId: widget.user.uid),
                            ),
                          );
                        },
                        child: const Text('Create Profile'),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ProfileCard(profile: _profile!),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D7A8C),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(userId: widget.user.uid),
                          ),
                        );
                      },
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final ActorProfile profile;

  const ProfileCard({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B4965),
              ),
            ),
            const SizedBox(height: 8),
            Text('Age: ${profile.age} | Gender: ${profile.gender} | Height: ${profile.height}'),
            const SizedBox(height: 16),
            Text(
              'Bio',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(profile.bio),
            const SizedBox(height: 16),
            _buildTagSection('Skills', profile.skills),
            const SizedBox(height: 8),
            _buildTagSection('Languages', profile.languages),
          ],
        ),
      ),
    );
  }

  Widget _buildTagSection(String title, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
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
}

class EditProfileScreen extends StatefulWidget {
  final String userId;

  const EditProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  String _selectedGender = 'Male';
  String _selectedExperience = 'fresher';
  List<String> _skills = [];
  List<String> _languages = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _ageController = TextEditingController();
    _heightController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4965),
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(labelText: 'Bio'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: 'Height'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(labelText: 'Gender'),
              items: ['Male', 'Female', 'Other']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedGender = value);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedExperience,
              decoration: const InputDecoration(labelText: 'Experience'),
              items: ['fresher', 'intermediate', 'professional']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedExperience = value);
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B4965),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _saveProfile,
                child: const Text('Save Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final profile = ActorProfile(
      uid: widget.userId,
      name: _nameController.text,
      bio: _bioController.text,
      age: int.parse(_ageController.text),
      height: _heightController.text,
      gender: _selectedGender,
      skills: _skills,
      languages: _languages,
      photoUrls: [],
      videoUrls: [],
      experience: _selectedExperience,
      createdAt: DateTime.now(),
    );

    try {
      await _firestoreService.saveActorProfile(profile);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}