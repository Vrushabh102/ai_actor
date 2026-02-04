import 'package:face2screen/services/firestore_service.dart';
import 'package:face2screen/models/match_model.dart';
import 'package:flutter/material.dart';

class MatchesScreen extends StatefulWidget {
  final bool isActor;

  const MatchesScreen({Key? key, required this.isActor}) : super(key: key);

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen>
    with SingleTickerProviderStateMixin {
  final FirestoreService _firestoreService = FirestoreService();
  List<Match> _matches = [];
  bool _isLoading = true;
  late TabController _tabController;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    setState(() => _isLoading = true);
    final matches = await _firestoreService.getActorMatches();
    setState(() {
      _matches = matches;
      _isLoading = false;
    });
  }

  List<Match> get _filteredMatches {
    if (_selectedFilter == 'all') return _matches;
    return _matches.where((m) => m.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: theme.appBarTheme.backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            const Color(0xFF00D9FF).withOpacity(0.25),
                            const Color(0xFF7B2FF7).withOpacity(0.25),
                          ]
                        : [
                            const Color(0xFF00D9FF).withOpacity(0.15),
                            const Color(0xFF7B2FF7).withOpacity(0.15),
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
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.people, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your Matches',
                          style: theme.textTheme.headlineMedium
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.isActor
                              ? 'Casting opportunities matched for you'
                              : 'Actors matched for your casting calls',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                color: theme.scaffoldBackgroundColor,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: theme.colorScheme.primary,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor:
                      theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                  onTap: (index) {
                    setState(() {
                      _selectedFilter = [
                        'all',
                        'pending',
                        'interested',
                        'accepted',
                        'rejected',
                      ][index];
                    });
                  },
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Pending'),
                    Tab(text: 'Interested'),
                    Tab(text: 'Accepted'),
                    Tab(text: 'Rejected'),
                  ],
                ),
              ),
            ),
          ),

          _isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : _filteredMatches.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No Matches Found',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final match = _filteredMatches[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Card(
                                color: theme.cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: ListTile(
                                  title: Text(
                                    'Match Score: ${match.matchScore.toStringAsFixed(1)}%',
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  subtitle: Text(
                                    'Status: ${match.status}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: _filteredMatches.length,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}