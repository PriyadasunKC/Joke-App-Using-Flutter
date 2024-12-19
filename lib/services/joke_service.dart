import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/joke.dart';

class JokeService {
  final Dio _dio = Dio();
  final SharedPreferences _prefs;
  static const String _cacheKey = 'cached_jokes';
  static const String _lastFetchKey = 'last_fetch_time';

  JokeService(this._prefs);

  Future<List<Joke>> fetchJokes({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cachedJokes = await getCachedJokes();
      final lastFetchTime = _prefs.getInt(_lastFetchKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;

      if (cachedJokes.isNotEmpty && now - lastFetchTime < 300000) {
        return cachedJokes;
      }
    }

    try {
      final response = await _dio.get(
        "https://v2.jokeapi.dev/joke/Programming,Christmas?blacklistFlags=nsfw,religious,racist&amount=5",
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jokesJson = response.data['jokes'];
        final jokes = jokesJson.map((json) => Joke.fromJson(json)).toList();
        await cacheJokes(jokes);
        await _prefs.setInt(
            _lastFetchKey, DateTime.now().millisecondsSinceEpoch);
        return jokes;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<List<Joke>> _handleDioError(DioException error) async {
    final cachedJokes = await getCachedJokes();
    if (cachedJokes.isNotEmpty) {
      return cachedJokes;
    }
    throw Exception('No cached jokes available');
  }

  Future<void> cacheJokes(List<Joke> jokes) async {
    final jokesJson = jokes.map((joke) => joke.toJson()).toList();
    await _prefs.setString(_cacheKey, jsonEncode(jokesJson));
  }

  Future<List<Joke>> getCachedJokes() async {
    final jsonString = _prefs.getString(_cacheKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Joke.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
