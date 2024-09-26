import 'package:flutter/material.dart';
import 'package:latext/latext.dart';

class AutoWrapLaTeX extends StatelessWidget {
  const AutoWrapLaTeX({
    super.key,
    required this.laTeXCode,
    this.equationStyle,
    required this.maxWidth,
  });

  final String laTeXCode;
  final TextStyle? equationStyle;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    // Split the LaTeX equation into multiple lines if needed
    final wrappedLatex = _splitLaTeXByWidth(context, laTeXCode, maxWidth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: wrappedLatex.map((line) {
        return LaTexT(
          laTeXCode: Text(
            '\$\$${line.replaceAll('\$\$', '')}\$\$',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        );
      }).toList(),
    );
  }

  List<String> _splitLaTeXByWidth(BuildContext context, String latex, double maxWidth) {
    List<String> lines = [];
    String currentLine = "";
    String currentWord = "";

    for (int i = 0; i < latex.length; i++) {
      currentWord += latex[i];

      // If it's a safe split point (e.g., operator, space, or after a complete symbol)
      if (latex[i] == '+' ||
          latex[i] == '-' ||
          latex[i] == '=' ||
          latex[i] == ' ' ||
          latex[i] == '}') {
        double currentLineWidth = _measureTextWidth(context, currentLine + currentWord);

        if (currentLineWidth > maxWidth) {
          // If the current line exceeds the max width, add the current line and start a new one
          lines.add(currentLine);
          currentLine = currentWord.trim(); // Start a new line with the current word
          currentWord = "";
        } else {
          // Add the current word to the current line
          currentLine += currentWord;
          currentWord = "";
        }
      }
    }

    // Add any remaining text as the final line
    if (currentLine.isNotEmpty || currentWord.isNotEmpty) {
      lines.add(currentLine + currentWord);
    }

    return lines;
  }

  double _measureTextWidth(BuildContext context, String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: equationStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.size.width;
  }
}
