import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../theme/colors.dart';
import 'glass_container.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bubbleDecoration = isUser
        ? BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          )
        : null;

    final childContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: isUser
          ? Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            )
          : MarkdownBody(
              data: text,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: isDark ? Colors.white.withOpacity(0.95) : Colors.black87,
                ),
                code: TextStyle(
                  backgroundColor: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9),
                  fontFamily: 'monospace',
                  fontSize: 13,
                ),
                blockquote: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: text));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Copied to clipboard"),
              behavior: SnackBarBehavior.floating,
              width: 200,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          constraints: const BoxConstraints(maxWidth: 320),
          child: isUser
              ? Container(
                  decoration: bubbleDecoration,
                  child: childContent,
                )
              : GlassContainer(
                  borderRadius: 20,
                  child: childContent,
                ),
        ),
      ),
    );
  }
}