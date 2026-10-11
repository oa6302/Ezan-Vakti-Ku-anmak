import 'package:flutter/material.dart';
import '../../app/theme.dart';

class SectionHeading extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const SectionHeading(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle});
  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                      color: navy.withValues(alpha: .18),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ]),
            child: Icon(icon, color: Colors.white, size: 22)),
        const SizedBox(width: 11),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900, color: navy)),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ])),
      ]);
}