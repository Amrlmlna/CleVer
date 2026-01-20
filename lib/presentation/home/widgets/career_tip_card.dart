import 'dart:math';
import 'package:flutter/material.dart';

class CareerTipCard extends StatelessWidget {
  const CareerTipCard({super.key});

  static const _tips = [
    {
      'title': 'Lamar Jadi Engineer?',
      'desc': 'Fokus ke "System Design" dan "Clean Code" daripada nulis skill umum.',
    },
    {
      'title': 'Pake Angka, Jangan Cuma Kata',
      'desc': '"Mengurangi latency 20%" lebih ngena daripada cuma "Meningkatkan performa".',
    },
    {
      'title': 'Format Ramah ATS',
      'desc': 'Hindari tabel atau kolom yang ribet. Keep it simple biar kebaca sistem.',
    },
    {
      'title': 'Kata Kerja Aktif',
      'desc': 'Mulai poin dengan kata kerja kuat: "Membangun", "Meluncurkan", "Memimpin".',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final tip = _tips[Random().nextInt(_tips.length)];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  tip['desc']!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
