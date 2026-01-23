import 'package:flutter/material.dart';

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          iconColor: Colors.black,
          collapsedIconColor: Colors.grey,
          title: Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black87,
              fontFamily: 'Outfit',
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            Text(
              answer,
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.6,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
