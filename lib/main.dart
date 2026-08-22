import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/features/auth/provider/auth_provider.dart';
import 'package:task/features/movies/provider/tmdb_provider.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/root.dart';
import 'package:task/splash.dart';
import 'package:task/views/genres_view.dart';
import 'package:task/features/movies/views/movies_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => TmdbProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Root(),
        routes: {
          '/genres': (_) => GenresView(),
          '/movies': (_) => MoviesView(),
        },
      ),
    );
  }
}
