import 'package:dilidili/model/read/opus.dart';
import 'package:flutter/material.dart';

class TextHelper {
  static double _fontSize(int? fontSize) {
    if (fontSize == null || fontSize <= 0) {
      return 14;
    }
    return fontSize * 0.95;
  }

  static Color _parseWordColor(String? color, Color fallback) {
    final String value = color?.trim() ?? '';
    if (value.isEmpty) return fallback;

    String hex = value;
    if (hex.startsWith('#')) hex = hex.substring(1);
    if (hex.startsWith('0x') || hex.startsWith('0X')) hex = hex.substring(2);
    if (hex.length == 6) hex = 'FF$hex';
    if (hex.length != 8) return fallback;

    final int? parsedColor = int.tryParse(hex, radix: 16);
    return parsedColor == null ? fallback : Color(parsedColor);
  }

  static Alignment getAlignment(int? align) {
    switch (align) {
      case 1:
        return Alignment.center;
      case 0:
        return Alignment.centerLeft;
      case 2:
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }

  static TextSpan buildTextSpan(
      ModuleParagraphTextNode node, int? align, BuildContext context) {
    // 获取node的所有key
    if (node.nodeType != null) {
      return TextSpan(
        text: node.word?.words ?? '',
        style: TextStyle(
          fontSize: _fontSize(node.word?.fontSize),
          fontWeight: node.word?.style?.bold == true
              ? FontWeight.bold
              : FontWeight.normal,
          height: align == 1 ? 2 : 1.5,
          color: _parseWordColor(
            node.word?.color,
            Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    } else {
      switch (node.type) {
        case 'TEXT_NODE_TYPE_WORD':
          return TextSpan(
            text: node.word?.words ?? '',
            style: TextStyle(
              fontSize: _fontSize(node.word?.fontSize),
              fontWeight: node.word?.style?.bold == true
                  ? FontWeight.bold
                  : FontWeight.normal,
              height: align == 1 ? 2 : 1.5,
              color: _parseWordColor(
                node.word?.color,
                Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        default:
          return const TextSpan(text: '');
      }
    }
  }
}
