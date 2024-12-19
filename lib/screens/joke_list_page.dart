import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/joke.dart';
import '../services/joke_service.dart';
import '../services/connectivity_service.dart';
import '../widgets/connection_banner.dart';
import '../theme/app_theme.dart';

class JokeListPage extends StatefulWidget {
  final SharedPreferences prefs;

  const JokeListPage({Key? key, required this.prefs}) : super(key: key);

  @override
  _JokeListPageState createState() => _JokeListPageState();
}

class _JokeListPageState extends State<JokeListPage>
    with SingleTickerProviderStateMixin {
  late final JokeService _jokeService;
  late final ConnectivityService _connectivityService;
  List<Joke> _jokes = [];
  bool _isLoading = false;
  bool _isOffline = false;
  bool _showOfflineBanner = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _jokeService = JokeService(widget.prefs);
    _connectivityService = ConnectivityService();
    _setupConnectivityStream();
    _setupAnimations();
    _initializeData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    final isConnected = await _connectivityService.isConnected();
    setState(() => _isOffline = !isConnected);
    await _loadJokes();
  }

  void _setupConnectivityStream() {
    _connectivityService.connectivityStream.listen((status) {
      _handleConnectivityChange(status);
    });
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _handleConnectivityChange(ConnectivityResult status) async {
    final isConnected = status != ConnectivityResult.none;
    if (!isConnected && !_isOffline) {
      setState(() {
        _isOffline = true;
        _showOfflineBanner = true;
      });
    } else if (isConnected && _isOffline) {
      setState(() {
        _isOffline = false;
        _showOfflineBanner = false;
      });
      await _loadJokes(forceRefresh: true);
    }
  }

  Future<void> _loadJokes({bool forceRefresh = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      final jokes = await _jokeService.fetchJokes(forceRefresh: forceRefresh);
      setState(() {
        _jokes = jokes;
        _isLoading = false;
      });
      _animationController.reset();
      _animationController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _showOfflineBanner = true;
      });
    }
  }

  Widget _buildJokeCard(Joke joke, int index) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
          top: index == 0 ? 16 : 0,
        ),
        decoration: BoxDecoration(
          color: AppTheme.lavenderSurfaces['card'],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.lightColorScheme.outline.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lavenderOpacities['shadow1']!,
              offset: const Offset(0, 4),
              blurRadius: 16,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppTheme.lavenderOpacities['shadow2']!,
              offset: const Offset(0, 2),
              blurRadius: 4,
              spreadRadius: -1,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.lightColorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      joke.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.lightColorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.emoji_emotions_outlined,
                    color: AppTheme.lightColorScheme.primary.withOpacity(0.7),
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (joke.isTwoPart) ...[
                Text(
                  joke.setup,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.lightColorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  joke.delivery,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.lightColorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ] else
                Text(
                  joke.joke,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.lightColorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppTheme.lavenderSurfaces['surface1'],
      child: Column(
        children: [
          Text(
            'Discover Jokes',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.lightColorScheme.onSurface,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _isOffline
                ? 'Working offline - showing cached jokes'
                : 'Tap the button below for a dose of humor!',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.lightColorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFetchButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isLoading ? null : () => _loadJokes(forceRefresh: true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.lightColorScheme.primary,
            foregroundColor: AppTheme.lightColorScheme.onPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: AppTheme.lightColorScheme.primary.withOpacity(0.1),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else ...[
                const Icon(Icons.refresh_rounded, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Get Fresh Jokes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_very_satisfied_rounded,
            size: 64,
            color: AppTheme.lightColorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No jokes available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightColorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isOffline
                ? 'Check your internet connection'
                : 'Tap refresh to load some jokes!',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.lightColorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lavenderSurfaces['surface1'],
      body: Column(
        children: [
          ConnectionBanner(
            isOffline: _showOfflineBanner,
            onDismiss: () => setState(() => _showOfflineBanner = false),
          ),
          Expanded(
            child: Container(
              color: AppTheme.lavenderSurfaces['surface1'],
              child: SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeader(),
                          _buildFetchButton(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                    if (_jokes.isEmpty && !_isLoading)
                      SliverFillRemaining(
                        child: _buildEmptyState(),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (_isLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightColorScheme.primary,
                                  ),
                                ),
                              );
                            }
                            return _buildJokeCard(_jokes[index], index);
                          },
                          childCount: _isLoading ? 1 : _jokes.length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
