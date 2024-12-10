import 'package:equatable/equatable.dart';

abstract class WordleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitWordEvent extends WordleEvent {
  final String word;

  SubmitWordEvent(this.word);

  @override
  List<Object?> get props => [word];
}

class ResetGameEvent extends WordleEvent {}
