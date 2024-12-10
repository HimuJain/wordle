import 'package:equatable/equatable.dart';
import '../models/word_model.dart';

class WordleState extends Equatable {
  final List<WordModel> guessedWords;
  final bool isGameOver;
  final String targetWord;

  WordleState({
    required this.guessedWords,
    required this.isGameOver,
    required this.targetWord,
  });

  WordleState copyWith({
    List<WordModel>? guessedWords,
    bool? isGameOver,
    String? targetWord,
  }) {
    return WordleState(
      guessedWords: guessedWords ?? this.guessedWords,
      isGameOver: isGameOver ?? this.isGameOver,
      targetWord: targetWord ?? this.targetWord,
    );
  }

  @override
  List<Object?> get props => [guessedWords, isGameOver, targetWord];
}
