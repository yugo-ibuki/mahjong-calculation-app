import 'package:flutter/material.dart';

class ExplanationPage extends StatelessWidget {
  const ExplanationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('符計算の解説'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: const [
          _SectionHeader(title: '符計算の基本', icon: Icons.info_outline),
          _ExplanationCard(
            title: '副底 (フーテイ)',
            content: '和了れば必ずもらえる基本の20符です。',
            fu: '20',
          ),
          _ExplanationCard(
            title: '門前ロン',
            content: '門前（ポン・チーをしていない状態）でロン和了したときにもらえる10符です。',
            fu: '10',
          ),
          _ExplanationCard(
            title: 'ツモ和了',
            content: 'ツモ和了したときにもらえる2符です。※ピンフツモの場合は20符固定（ツモ符なし）となります。',
            fu: '2',
          ),
          
          _SectionHeader(title: '面子の符', icon: Icons.grid_view),
          _ExplanationCard(
            title: '暗刻 (アンコ)',
            content: '中張牌（2〜8）: 4符\n幺九牌 (1・9・字牌): 8符',
            fu: '4 / 8',
          ),
          _ExplanationCard(
            title: '明刻 (ミンコ)',
            content: '中張牌（2〜8）: 2符\n幺九牌 (1・9・字牌): 4符',
            fu: '2 / 4',
          ),
          _ExplanationCard(
            title: '暗槓 (アンカン)',
            content: '中張牌（2〜8）: 16符\n幺九牌 (1・9・字牌): 32符',
            fu: '16 / 32',
          ),

          _SectionHeader(title: '雀頭・待ちの符', icon: Icons.ads_click),
          _ExplanationCard(
            title: '役牌の雀頭',
            content: '自風・場風・三元牌を雀頭にすると2符つきます。',
            fu: '2',
          ),
          _ExplanationCard(
            title: '待ちによる符',
            content: 'カンチャン・ペンチャン・単騎待ちの場合、2符つきます。',
            fu: '2',
          ),

          _SectionHeader(title: '点数支払いのルール', icon: Icons.payments_outlined),
          _ExplanationCard(
            title: '親と子の支払い',
            content: '親の和了点数は、子の基本点数の1.5倍になります。',
          ),
          _ExplanationCard(
            title: 'ツモ和了の配分',
            content: '【子がツモ】親が1/2、他の子が1/4ずつ\n【親がツモ】子が1/3ずつ均等',
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12, left: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExplanationCard extends StatelessWidget {
  final String title;
  final String content;
  final String? fu;

  const _ExplanationCard({
    required this.title,
    required this.content,
    this.fu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                if (fu != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+$fu符',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Text(
              content,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
