import 'package:bloc/bloc.dart';
import '../utils/word_list.dart';
import 'wordle_event.dart';
import 'wordle_state.dart';
import '../models/word_model.dart';

class WordleBloc extends Bloc<WordleEvent, WordleState> {
  WordleBloc()
      : super(WordleState(
          guessedWords: [],
          isGameOver: false,
          targetWord: wordList[0],
        )) {
    on<SubmitWordEvent>(_onSubmitWord);
    on<ResetGameEvent>(_onResetGame);
  }

  void _onSubmitWord(SubmitWordEvent event, Emitter<WordleState> emit) {
    if (state.isGameOver) return;

    final guessedWord = event.word.toLowerCase();
    if (guessedWord.length != state.targetWord.length) return;

    final correctPositions = List<bool>.generate(
      state.targetWord.length,
      (i) => state.targetWord[i] == guessedWord[i],
    );

    if (guessedWord == state.targetWord) {
      emit(state.copyWith(
        isGameOver: true,
        guessedWords: [
          ...state.guessedWords,
          WordModel(word: guessedWord, correctPositions: correctPositions),
        ],
      ));
    } else {
      emit(state.copyWith(
        guessedWords: [
          ...state.guessedWords,
          WordModel(word: guessedWord, correctPositions: correctPositions),
        ],
      ));
    }
  }

  void _onResetGame(ResetGameEvent event, Emitter<WordleState> emit) {
    emit(WordleState(
      guessedWords: [],
      isGameOver: false,
      targetWord: wordList[0], // You can randomize this
    ));
  }
}
