import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/auth/provider/auth_provider.dart';
import 'package:task/features/movies/data/movie_repository.dart';
import 'package:task/features/movies/provider/favorites_provider.dart';
import 'package:task/features/movies/provider/tmdb_provider.dart';
import 'package:task/features/genres/data/genre_repository.dart';
import 'package:task/features/genres/provider/genre_provider.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/features/movies/views/movies_view.dart';
import 'package:task/splash.dart';
import 'package:task/features/genres/views/genres_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(
          create: (context) => TmdbProvider(
            repository: MovieRepository(
              apiKey: 'c7a80ea5a4d5126abefa10ddc02f2a55',
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => GenreProvider(
            repository: GenreRepository(
              apiKey: 'c7a80ea5a4d5126abefa10ddc02f2a55',
            ),
          ),
        ),
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          extensions: [
            YoutubePlayerTheme(progressBarActiveColor: AppColors.primary),
          ],
        ),
        home: const Splash(),
        routes: {
          '/genres': (_) => GenresView(),
          '/movies': (_) => MoviesView(),
        },
      ),
    );
  }
}
