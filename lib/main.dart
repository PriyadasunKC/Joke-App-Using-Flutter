import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/joke_list_page.dart';
import 'widgets/error_boundary.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    runApp(MyApp(prefs: prefs));
  } catch (error, stackTrace) {
    print('Error initializing app: $error\n$stackTrace');
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({
    Key? key,
    required this.prefs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Jokes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: AppTheme.lightColorScheme,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: AppTheme.lavenderSurfaces['surface1'],
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: AppTheme.lightColorScheme.surface,
          foregroundColor: AppTheme.lightColorScheme.onSurface,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.lightColorScheme.primary,
            foregroundColor: AppTheme.lightColorScheme.onPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: AppTheme.lavenderSurfaces['card'],
        ),
      ),
      home: ErrorBoundary(
        child: FutureBuilder(
          future: _initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _buildErrorScreen(snapshot.error.toString());
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return JokeListPage(prefs: prefs);
            }

            return _buildLoadingScreen();
          },
        ),
      ),
    );
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Widget _buildLoadingScreen() {
    return Container(
      color: AppTheme.lavenderSurfaces['surface1'],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.lavenderSurfaces['card'],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.lightColorScheme.outline.withOpacity(0.1),
                ),
              ),
              child: Icon(
                Icons.emoji_emotions_rounded,
                size: 64,
                color: AppTheme.lightColorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightColorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading Jokes...',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.lightColorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String error) {
    return Scaffold(
      body: Container(
        color: AppTheme.lavenderSurfaces['surface1'],
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.lightColorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: AppTheme.lightColorScheme.error,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Oops! Something went wrong',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightColorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.lightColorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightColorScheme.primary,
                      foregroundColor: AppTheme.lightColorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.lightColorScheme.onSurfaceVariant,
                  ),
                  child: const Text('Close App'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
