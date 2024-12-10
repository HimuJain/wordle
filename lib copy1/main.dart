import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/game_screen.dart';
import 'blocs/wordle_bloc.dart';

void main() {
  runApp(WordleApp());
}

class WordleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle Clone',
      home: BlocProvider(
        create: (_) => WordleBloc(),
        child: GameScreen(),
      ),
    );
  }
}
