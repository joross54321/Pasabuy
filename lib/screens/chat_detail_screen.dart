import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _Bubble {
  const _Bubble(this.text, this.fromMe);
  final String text;
  final bool fromMe;
}

class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key, required this.name});

  final String name;

  static const _messages = [
    _Bubble('Hi! I just got to SM City Iloilo, starting your list now 🛒', false),
    _Bubble('Awesome, thank you! Let me know if the brand of milk is out of stock', true),
    _Bubble('Got the milk & bread. Eggs are out — ok to get a different brand?', false),
    _Bubble('Sure, any brand is fine 👍', true),
    _Bubble('Perfect, heading to checkout now. ETA 15 mins.', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withOpacity(0.15),
              child: Text(name.substring(0, 1), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                const Text('online', style: TextStyle(fontSize: 11, color: AppColors.success)),
              ],
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.call_outlined, color: AppColors.textDark),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Shopping Trip • In Progress', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                      SizedBox(height: 4),
                      Text('SM City Iloilo • 5 items', style: TextStyle(fontSize: 12, color: AppColors.placeholder)),
                    ],
                  ),
                ),
                Row(
                  children: const [
                    Text('View details', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                    Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                return Align(
                  alignment: m.fromMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                    decoration: BoxDecoration(
                      color: m.fromMe ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(m.fromMe ? 16 : 4),
                        bottomRight: Radius.circular(m.fromMe ? 4 : 16),
                      ),
                    ),
                    child: Text(
                      m.text,
                      style: TextStyle(fontSize: 14, color: m.fromMe ? Colors.white : AppColors.textDark),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 47,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(85),
                      ),
                      child: const Center(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Type a message…',
                            hintStyle: TextStyle(fontSize: 14, color: AppColors.placeholder),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 47,
                    height: 47,
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
