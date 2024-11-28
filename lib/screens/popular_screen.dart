import 'package:flutter/material.dart';
import 'package:tap2024b/network/api_popular.dart';
import 'package:tap2024b/models/popular_model.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({Key? key}) : super(key: key);

  @override
  _PopularScreenState createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  late Future<List<PopularModel>> popularMovies;

  @override
  void initState() {
    super.initState();
    // Inicializar con un valor predeterminado
    popularMovies = Future.value([]);
    // Cargar datos reales
    fetchPopularMovies();
  }

  void fetchPopularMovies() {
    setState(() {
      popularMovies = ApiPopular().getAllPopular();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies')),
      body: FutureBuilder<List<PopularModel>>(
        future: popularMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  leading: Image.network(
                    movie.fullPosterPath,
                    fit: BoxFit.cover,
                    width: 50,
                  ),
                  title: Text(movie.title),
                  subtitle: Text('Rating: ${movie.voteAverage.toString()}'),
                );
              },
            );
          } else {
            return const Center(child: Text('No movies found.'));
          }
        },
      ),
    );
  }
}


