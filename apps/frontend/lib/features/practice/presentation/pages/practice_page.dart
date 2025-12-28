import 'package:flutter/material.dart';
import '../../data/repositories/mock_question_repository.dart';
import '../../domain/models/question.dart';
import '../../domain/services/question_randomizer.dart';
import '../widgets/hand_widget.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  late List<Question> _allQuestions;
  late Question _currentQuestion;
  int? _selectedIndex;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _allQuestions = MockQuestionRepository.questions;
    _nextQuestion();
  }

  void _nextQuestion() {
    setState(() {
      final baseQuestion = _allQuestions[DateTime.now().millisecond % _allQuestions.length];
      _currentQuestion = QuestionRandomizer.randomize(baseQuestion);
      _selectedIndex = null;
      _isAnswered = false;
    });
  }

  void _checkAnswer(int index) {
    if (_isAnswered) return;
    setState(() {
      _selectedIndex = index;
      _isAnswered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCorrect = _selectedIndex == _currentQuestion.correctChoiceIndex;

    return Scaffold(
      appBar: AppBar(title: const Text('符計算練習')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoRow(),
            const SizedBox(height: 24),
            HandWidget(
              groups: _currentQuestion.groups,
              winningGroupIndex: _currentQuestion.winningGroupIndex,
            ),
            const SizedBox(height: 24),
            const Text(
              'この和了の点数は？',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildChoices(),
            if (_isAnswered) _buildExplanation(isCorrect),
          ],
        ),
      ),
      bottomNavigationBar: _isAnswered
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('次の問題へ', style: TextStyle(fontSize: 18)),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _InfoChip(label: '状況', value: _currentQuestion.isTsumo ? 'ツモ' : 'ロン'),
        _InfoChip(label: '親/子', value: _currentQuestion.isDealer ? '親' : '子'),
        _InfoChip(label: '場/自', value: '${_currentQuestion.roundWind.toUpperCase()}/${_currentQuestion.seatWind.toUpperCase()}'),
        _InfoChip(label: '役', value: '${_currentQuestion.han}翻'),
      ],
    );
  }

  Widget _buildChoices() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: _currentQuestion.choices.length,
      itemBuilder: (context, index) {
        final choice = _currentQuestion.choices[index];
        bool isThisCorrect = index == _currentQuestion.correctChoiceIndex;
        bool isThisSelected = index == _selectedIndex;

        Color? bgColor;
        if (_isAnswered) {
          if (isThisCorrect) bgColor = Colors.green.shade100;
          else if (isThisSelected) bgColor = Colors.red.shade100;
        }

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            side: isThisSelected ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2) : null,
          ),
          onPressed: () => _checkAnswer(index),
          child: Text(
            '${choice.total}点',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  Widget _buildExplanation(bool isCorrect) {
    return Card(
      margin: const EdgeInsets.only(top: 24),
      color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  isCorrect ? '正解！' : '不正解...',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '正解: ${_currentQuestion.correctScore.total}点',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_currentQuestion.isTsumo && _currentQuestion.correctScore.dealer != null)
              Text('配分: ${_currentQuestion.correctScore.nonDealer ?? ""}-${_currentQuestion.correctScore.dealer}'),
            const Divider(),
            const Text('【解説】', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('符の内訳: ${_currentQuestion.fuBreakdown.map((f) => "${f['name']}(${f['fu']}符)").join(' + ')}'),
            Text('合計: ${_currentQuestion.fu}符 ${_currentQuestion.han}翻'),
            const SizedBox(height: 8),
            Text(_currentQuestion.explanation),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/explanation'),
              icon: const Icon(Icons.menu_book),
              label: const Text('符計算の解説ページを見る'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: const TextStyle(fontSize: 12, color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
