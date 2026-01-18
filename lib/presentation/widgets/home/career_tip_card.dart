import 'dart:math';
import 'package:flutter/material.dart';

class CareerTipCard extends StatelessWidget {
  const CareerTipCard({super.key});

  static const _tips = [
    {
      'title': 'Tailoring for Engineering?',
      'desc': 'Focus on "System Design" and "Clean Code" principles over generic skills.',
    },
    {
      'title': 'Quantify Your Impact',
      'desc': 'Use numbers! "Reduced latency by 20%" is better than "Improved performance".',
    },
    {
      'title': 'ATS Friendly Formatting',
      'desc': 'Avoid complex tables and columns. Keep it simple for the bots.',
    },
    {
      'title': 'Action Verbs',
      'desc': 'Start bullets with strong verbs: "Architected", "Deployed", "Spearheaded".',
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
