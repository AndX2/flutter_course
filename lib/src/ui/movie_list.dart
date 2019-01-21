import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

import '../models/item_model.dart';
import '../bloc/movies_bloc.dart';

class MovieList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MovieListState();
  }
}

class _MovieListState extends State<MovieList> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllMovies();
  }

  @override
    void dispose() {
      bloc.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: StreamBuilder(
        stream: bloc.allMovies,
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ItemModel> snapshot) {
    return GridView.builder(
        itemCount: snapshot.data.results.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            // mainAxisSpacing: 8.0,
            // crossAxisSpacing: 8.0,
            childAspectRatio: 0.7),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 8.0,
            child: GestureDetector(
              child: imageNetworkWidgetWithErrorCatcher(() {
                return Image.network(
                  'https://image.tmdb.org/t/p/w185${snapshot.data.results[index].posterPath}',
                  fit: BoxFit.cover,
                );
              }, context,
                  'https://image.tmdb.org/t/p/w185${snapshot.data.results[index].posterPath}'),
              onTap: () {
                print('Tap on index: $index');
              },
            ),
          );
        });
  }

  Widget imageNetworkWidgetWithErrorCatcher(
      Function function, BuildContext context, String url) {
    bool isError = false;
    precacheImage(NetworkImage(url), context, onError: (error, stackTrace) {
      isError = true;
    });
    return isError
        ? Center(
            child: Text('No cover for this movie', maxLines: 2),
          )
        : function();
  }
}
