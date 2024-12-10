import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flip_card/flip_card.dart';
import '../blocs/wordle_bloc.dart';
import '../blocs/wordle_event.dart';
import '../blocs/wordle_state.dart';

class GameScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wordle Clone')),
      body: BlocBuilder<WordleBloc, WordleState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.guessedWords.length,
                  itemBuilder: (context, index) {
                    final wordModel = state.guessedWords[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: wordModel.word.split('').asMap().entries.map((entry) {
                        final letter = entry.value;
                        final isCorrect = wordModel.correctPositions[entry.key];
                        return FlipCard(
                          front: _buildCard(letter, Colors.grey),
                          back: _buildCard(letter, isCorrect ? Colors.green : Colors.red),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              if (!state.isGameOver)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter your guess',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      context.read<WordleBloc>().add(SubmitWordEvent(value));
                      _controller.clear();
                    },
                  ),
                ),
              if (state.isGameOver)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Congratulations! You guessed the word.',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ElevatedButton(
                onPressed: () => context.read<WordleBloc>().add(ResetGameEvent()),
                child: Text('Restart'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(String letter, Color color) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      alignment: Alignment.center,
      child: Text(
        letter.toUpperCase(),
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
