import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wordle/wordle/wordle.dart';

enum GameStatus { playing, submitting, lost, won }

class WordleScreen extends StatefulWidget {
  const WordleScreen({Key? key}) : super(key: key);

  @override
  _WordleScreenState createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  GameStatus _gameStatus = GameStatus.playing;

  final List<Word> _board = List.generate(
    6,
    (_) => Word(letters: List.generate(5, (_) => Letter.empty())),
  );

  final List<List<GlobalKey<FlipCardState>>> _flipKeys = List.generate(
    6,
    (_) => Word(letters: List.generate(5, (_) => GlobalKey<FlipCardState>())),
  );

  int _currentWordIndex = 0;

  Word? get _currentWord => 
    _currentWordIndex < _board.length ? _board[_currentWordIndex] : null;

  Word _solution = Word.fromString(
    fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'wordle',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          )
        )
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Board(board: _board, flipKeys: _flipKeys),
          const SizedBox(height: 70),
          Keyboard(
            onKeyTapped: _onKeyTapped,
            onDeleteTapped: _onDeleteTapped,
            onEnterTapped: _onEnterTapped,
          ),
        ],
      ),
    );
  }


  void _onKeyTapped(String letter) {
    if (_gameStatus == GameStatus.playing) {
      setState(() => _currentWord?.addLetter(letter));
    }
  }

  void _onDeleteTapped() {
    if (_gameStatus == GameStatus.playing) {
      setState(() => _currentWord?.removeLetter());
    }
  }

  void _onEnterTapped() {
    if (_gameStatus == GameStatus.playing && _currentWord != null && !_currentWord!.letters.contains(Letter.empty())) {
      _gameStatus = GameStatus.submitting;
    }

    for(int i = 0; i < _currentWord!.letters.length; i++) {
      final currentWordLetter = _currentWord!.letters[i];
      final currentSolutionLetter = _solution.letters[i];

      setState(() {
        if (currentWordLetter == currentSolutionLetter) {
          _currentWord!.letters[i] = currentWordLetter.copyWith(status: LetterStatus.correct
          );
        } else if (_solution.letters.contains(currentWordLetter)) {
          _currentWord!.letters[i] = currentWordLetter.copyWith(status: LetterStatus.inWord);
        } else {
          _currentWord!.letters[i] = currentWordLetter.copyWith(status: LetterStatus.notInWord);
        }
      });
    }

    _checkIfWinLoss();
  }

  void _checkIfWinLoss() {
    if (_currentWord!.wordString == _solution.wordString) {
      _gameStatus = GameStatus.won;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You won!'),
          action: SnackBarAction(
            label: 'Play again',
            onPressed: _restart,
            textColor: Colors.white,
          ),
        ),
      );
    } else if (_currentWordIndex + 1 >= _board.length) {
      _gameStatus = GameStatus.lost;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You lost! Solution: ${_solution.wordString} '),
          action: SnackBarAction(
            label: 'Play again',
            onPressed: _restart,
            textColor: Colors.white,
          ),
        ),
      );
    } 
    else{
      _gameStatus = GameStatus.playing;
    }
    _currentWordIndex++;
  }

  void _restart() {
    setState(() {
      _gameStatus = GameStatus.playing;
      _currentWordIndex = 0;
      _board.forEach..clear()..addAll(
        List.generate(
          6,
          (_) => Word(letters: List.generate(5, (_) => Letter.empty())),
        ),
      );
      _solution = Word.fromString(
        fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),
      );
    });
  }
}

