import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/question.dart';
import '../../data/repositories/mock_question_repository.dart';
import '../../domain/services/question_randomizer.dart';

class PracticeState {
  final Question? currentQuestion;
  final int? selectedIndex;
  final bool isAnswered;

  PracticeState({
    this.currentQuestion,
    this.selectedIndex,
    this.isAnswered = false,
  });

  PracticeState copyWith({
    Question? currentQuestion,
    int? selectedIndex,
    bool? isAnswered,
  }) {
    return PracticeState(
      currentQuestion: currentQuestion ?? this.currentQuestion,
      selectedIndex: selectedIndex, // Can be null
      isAnswered: isAnswered ?? this.isAnswered,
    );
  }
}

class PracticeNotifier extends StateNotifier<PracticeState> {
  PracticeNotifier() : super(PracticeState()) {
    nextQuestion();
  }

  void nextQuestion() {
    final allQuestions = MockQuestionRepository.questions;
    final baseQuestion = allQuestions[DateTime.now().millisecond % allQuestions.length];
    final randomizedQuestion = QuestionRandomizer.randomize(baseQuestion);
    
    state = PracticeState(
      currentQuestion: randomizedQuestion,
      selectedIndex: null,
      isAnswered: false,
    );
  }

  void selectChoice(int index) {
    if (state.isAnswered) return;
    state = state.copyWith(
      selectedIndex: index,
      isAnswered: true,
    );
  }
}

final practiceProvider = StateNotifierProvider<PracticeNotifier, PracticeState>((ref) {
  return PracticeNotifier();
});
