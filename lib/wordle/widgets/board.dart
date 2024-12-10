import 'package:flutter/material.dart';

class Board extends StatelessWidget{
  const Board({Key? key, required this.board}) : super(key: key);

  final List<Word> board;

  final List<List<GlobalKey<FlipCardState>>> flipKeys;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: board.asMap().map(
        (i, word) => MapEntry(i, Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: word.letters.asMap().map((j, letter) => MapEntry(j, 
            FlipCard(
                key: flipKeys[i][j],
                flipOnTouch: false,
                direction: FlipDirection.Vertical,
                front: BoardTile(letter: Letter(val: letter.val, status: LetterStatus.initial,),),
                back: BoardTile(letter: letter),
                ),
              ),
            ).values.toList(),
          ),
        ),
      ).values.toList(),
    );
  }
}