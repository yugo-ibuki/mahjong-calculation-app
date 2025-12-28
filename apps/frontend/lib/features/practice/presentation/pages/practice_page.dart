import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/practice_provider.dart';
import '../widgets/hand_widget.dart';

class PracticePage extends ConsumerWidget {
  const PracticePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(practiceProvider);
    final currentQuestion = state.currentQuestion;

    if (currentQuestion == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isCorrect = state.selectedIndex == currentQuestion.correctChoiceIndex;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('符計算練習'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(context, currentQuestion),
            const SizedBox(height: 24),
            HandWidget(
              groups: currentQuestion.groups,
              winningGroupIndex: currentQuestion.winningGroupIndex,
            ),
            const SizedBox(height: 32),
            const Text(
              'この和了の点数は？',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            _buildChoices(context, ref, state),
            if (state.isAnswered) _buildExplanation(context, ref, currentQuestion, isCorrect),
          ],
        ),
      ),
      bottomNavigationBar: state.isAnswered
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () => ref.read(practiceProvider.notifier).nextQuestion(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text('次の問題へ', style: TextStyle(fontSize: 18)),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoCard(BuildContext context, dynamic question) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _InfoItem(label: '状況', value: question.isTsumo ? 'ツモ' : 'ロン', icon: Icons.pan_tool_alt),
            _InfoItem(label: '親/子', value: question.isDealer ? '親' : '子', icon: Icons.person),
            _InfoItem(label: '場/自', value: '${question.roundWind.toUpperCase()}/${question.seatWind.toUpperCase()}', icon: Icons.explore),
            _InfoItem(label: '役', value: '${question.han}翻', icon: Icons.stars, color: Colors.orange.shade700),
          ],
        ),
      ),
    );
  }

  Widget _buildChoices(BuildContext context, WidgetRef ref, dynamic state) {
    final question = state.currentQuestion;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: question.choices.length,
      itemBuilder: (context, index) {
        final choice = question.choices[index];
        bool isThisCorrect = index == question.correctChoiceIndex;
        bool isThisSelected = index == state.selectedIndex;

        Color bgColor = Colors.white;
        Color textColor = Colors.black87;
        BorderSide? border;

        if (state.isAnswered) {
          if (isThisCorrect) {
            bgColor = Colors.green.shade50;
            textColor = Colors.green.shade700;
            border = BorderSide(color: Colors.green.shade300, width: 2);
          } else if (isThisSelected) {
            bgColor = Colors.red.shade50;
            textColor = Colors.red.shade700;
            border = BorderSide(color: Colors.red.shade300, width: 2);
          }
        } else {
          border = BorderSide(color: Colors.grey.shade300);
        }

        return InkWell(
          onTap: () => ref.read(practiceProvider.notifier).selectChoice(index),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: border != null ? Border.fromBorderSide(border) : null,
              boxShadow: state.isAnswered ? null : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              '${choice.total}点',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExplanation(BuildContext context, WidgetRef ref, dynamic question, bool isCorrect) {
    return Container(
      margin: const EdgeInsets.only(top: 32, bottom: 80),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isCorrect ? Colors.green.shade100 : Colors.red.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                isCorrect ? '正解です！' : '残念、不正解です',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '正解: ${question.correctScore.total}点',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          if (question.isTsumo && question.correctScore.dealer != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '配分: ${question.correctScore.nonDealer ?? ""}-${question.correctScore.dealer}',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
          const Text(
            '解説',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          _buildFuDetail(question),
          const SizedBox(height: 16),
          Text(
            question.explanation,
            style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => context.push('/explanation'),
            icon: const Icon(Icons.menu_book),
            label: const Text('符計算の解説を読み直す'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuDetail(dynamic question) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ...question.fuBreakdown.map<Widget>((f) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(f['name'].toString(), style: const TextStyle(fontSize: 14)),
                Text('${f['fu']}符', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          )).toList(),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('合計', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${question.fu}符 ${question.han}翻',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _InfoItem({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.grey.shade600),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}

