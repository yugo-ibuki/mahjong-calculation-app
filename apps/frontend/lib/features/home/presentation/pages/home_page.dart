import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.calculate_rounded, size: 48, color: Color(0xFF2E7D32)),
              ),
              const SizedBox(height: 32),
              const Text(
                '符計算を\nマスターしよう',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '満貫未満の点数計算を、20種類の厳選された問題で効率的にトレーニングできます。',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600, height: 1.6),
              ),
              const SizedBox(height: 48),
              _MenuButton(
                icon: Icons.quiz_rounded,
                label: '練習問題を解く',
                description: '4択形式で符計算をトレーニング',
                onPressed: () => context.push(AppRoutes.practice),
                isPrimary: true,
              ),
              const SizedBox(height: 20),
              _MenuButton(
                icon: Icons.menu_book_rounded,
                label: '符計算の解説',
                description: '符の基本と種類を体系的に学びます',
                onPressed: () => context.push(AppRoutes.explanation),
                isPrimary: false,
              ),
              const SizedBox(height: 60),
              _buildStats(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '学習のポイント',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _StatRow(icon: Icons.check_circle_outline, text: '基礎から応用まで20種類のバリエーション'),
          const SizedBox(height: 12),
          _StatRow(icon: Icons.speed, text: '実践で役立つクイック回答力を養成'),
          const SizedBox(height: 12),
          _StatRow(icon: Icons.lightbulb_outline, text: '全問題に詳細な符計算の内訳解説付き'),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _StatRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green.shade600),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87))),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.description,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isPrimary ? Theme.of(context).colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: isPrimary ? null : Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: isPrimary 
                ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                : Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon, 
              size: 32, 
              color: isPrimary ? Colors.white : Theme.of(context).colorScheme.primary
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label, 
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: isPrimary ? Colors.white : Colors.black87,
                    )
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description, 
                    style: TextStyle(
                      fontSize: 13,
                      color: isPrimary ? Colors.white.withOpacity(0.8) : Colors.grey.shade600,
                    )
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded, 
              size: 16, 
              color: isPrimary ? Colors.white : Colors.grey.shade400
            ),
          ],
        ),
      ),
    );
  }
}
