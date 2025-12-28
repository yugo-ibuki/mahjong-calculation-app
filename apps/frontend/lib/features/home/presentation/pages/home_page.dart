import 'package:flutter/material.dart';
import '../../../../app/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('麻雀符計算練習')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calculate, size: 80, color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                '符計算をマスターしよう！',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '満貫未満の点数計算を効率的に練習できます。',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _MenuButton(
                icon: Icons.menu_book,
                label: '符計算の種類・解説',
                description: '符の基本と種類を学びます',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.explanation),
              ),
              const SizedBox(height: 16),
              _MenuButton(
                icon: Icons.quiz,
                label: '練習問題を解く',
                description: '4択形式で符計算をトレーニング',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.practice),
                isPrimary: true,
              ),
            ],
          ),
        ),
      ),
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Theme.of(context).colorScheme.primary : null,
          foregroundColor: isPrimary ? Colors.white : null,
          padding: const EdgeInsets.all(16),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(description, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
