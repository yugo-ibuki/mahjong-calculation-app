import 'package:flutter/material.dart';

class ExplanationPage extends StatelessWidget {
  const ExplanationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('符計算の種類と解説')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SectionTitle('符計算の基本'),
          _ExplanationCard(
            title: '副底 (フーテイ)',
            content: '和了れば必ずもらえる基本の20符です。',
          ),
          _ExplanationCard(
            title: '門前ロン',
            content: '門前（ポン・チーをしていない状態）でロン和了したときにもらえる10符です。',
          ),
          _ExplanationCard(
            title: 'ツモ',
            content: 'ツモ和了したときにもらえる2符です。ピンフツモの場合は20符固定となります。',
          ),
          _SectionTitle('面子の符'),
          _ExplanationCard(
            title: '暗刻 (アンコ)',
            content: '中張牌（2〜8）: 4符\n幺九牌 (1・9・字牌): 8符',
          ),
          _ExplanationCard(
            title: '明刻 (ミンコ)',
            content: '中張牌（2〜8）: 2符\n幺九牌 (1・9・字牌): 4符',
          ),
          _SectionTitle('雀頭・待ちの符'),
          _ExplanationCard(
            title: '役牌の雀頭',
            content: '自風・場風・三元牌を雀頭にすると2符つきます。',
          ),
          _ExplanationCard(
            title: '待ちによる符',
            content: 'カンチャン・ペンチャン・単騎待ちの場合、2符つきます。',
          ),
          _SectionTitle('点数計算の配分'),
          _ExplanationCard(
            title: '親と子の違い',
            content: '親の和了点数は、子の基本点数の1.5倍になります。',
          ),
          _ExplanationCard(
            title: 'ツモ和了の支払い配分',
            content: '【子がツモった場合】\n親が1/2、他の子が1/4ずつ支払います。\n\n【親がツモった場合】\n子が1/3ずつ均等に支払います。',
          ),
          _ExplanationCard(
            title: 'ロン和了の支払い',
            content: '放銃した（牌を捨てた）人が全額支払います。',
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _ExplanationCard extends StatelessWidget {
  final String title;
  final String content;

  const _ExplanationCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text(content),
          ],
        ),
      ),
    );
  }
}
