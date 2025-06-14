library latext;

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

extension StringExt on String {
  String refactorRac() {
    final RegExp racRegex = RegExp(r'\brac\{(.+?)\}\{(.+?)\}');

    return replaceAllMapped(racRegex, (match) {
      return '\\frac{${match.group(1)}}{${match.group(2)}}';
    });
  }

  String refactorExt() {
    final RegExp extRegex = RegExp(r'\bext\{(.+?)\}');

    return replaceAllMapped(extRegex, (match) {
      return '\\text{${match.group(1)}}';
    });
  }
}

class LaTexT extends StatefulWidget {
  /// a Text used for the rendered code as well as for the style
  final Text laTeXCode;

  /// The delimiter to be used for inline LaTeX
  final String delimiter;

  /// The delimiter to be used for Display (centered, "important") LaTeX
  final String displayDelimiter;

  /// The delimiter to be used for line breaks outside of $delimiters$
  /// Default is '\n'
  /// example: Two latex equations separated by a line break: $equation1$ \n $equation2$
  final String breakDelimiter;

  /// A TextStyle used to apply styles exclusively to the mathematical equations of the laTeXCode.
  /// If not provided, this variable will be ignored, and the laTeXCode style will be applied.
  final TextStyle? equationStyle;

  /// A callback function to be called when an error occurs while rendering the LaTeX code.
  final Function(String text)? onErrorFallback;

  const LaTexT({
    super.key,
    required this.laTeXCode,
    this.equationStyle,
    this.onErrorFallback,
    this.delimiter = r'$$',
    this.displayDelimiter = r'$',
    this.breakDelimiter = r'\\n',
  });

  @override
  State<LaTexT> createState() => LaTexTState();
}

class LaTexTState extends State<LaTexT> {
  @override
  Widget build(BuildContext context) {
    // Fetching the Widget's LaTeX code as well as it's [TextStyle]
    final laTeXCode = widget.laTeXCode.data!;
    final defaultTextStyle = widget.laTeXCode.style;

    // Building [RegExp] to find any Math part of the LaTeX code by looking for the specified delimiters
    final String delimiter = widget.delimiter.replaceAll(r'$', r'\$');
    final String displayDelimiter =
        widget.displayDelimiter.replaceAll(r'$', r'\$');

    final String rawRegExp =
        '(($delimiter)([^$delimiter]*[^\\\\\\$delimiter])($delimiter)|($displayDelimiter)([^$displayDelimiter]*[^\\\\\\$displayDelimiter])($displayDelimiter))';
    List<RegExpMatch> matches =
        RegExp(rawRegExp, dotAll: true).allMatches(laTeXCode).toList();

    // If no single Math part found, returning the raw [Text] from widget.laTeXCode
    if (matches.isEmpty) return widget.laTeXCode;

    // Otherwise looping threw all matches and building a [RichText] from [TextSpan] and [WidgetSpan] widgets
    final List<InlineSpan> textBlocks = [];
    int lastTextEnd = 0;

    for (final laTeXMatch in matches) {
      // If there is an offset between the lat match (beginning of the [String] in first case), first adding the found [Text]
      if (laTeXMatch.start > lastTextEnd) {
        final texts = laTeXCode.substring(lastTextEnd, laTeXMatch.start);

        textBlocks.addAll(
          _extractTextSpans(
            texts,
          ),
        );
      }
      // Adding the [CaTeX] widget to the children
      if (laTeXMatch.group(3) != null) {
        textBlocks.addAll([
          ..._extractWidgetSpans(
            laTeXMatch.group(3)?.trim() ?? '',
          ),
        ]);
      } else {
        textBlocks.addAll([
          const TextSpan(text: '\n'),
          ..._extractWidgetSpans(laTeXMatch.group(6)?.trim() ?? ''),
          const TextSpan(text: '\n')
        ]);
      }
      lastTextEnd = laTeXMatch.end;
    }

    // If there is any text left after the end of the last match, adding it to children
    if (lastTextEnd < laTeXCode.length) {
      textBlocks.addAll([
        ..._extractTextSpans(
          laTeXCode.substring(lastTextEnd),
        ),
      ]);
    }

    // Returning a RichText containing all the [TextSpan] and [WidgetSpan] created previously while
    // obeying the specified style in widget.laTeXCode
    return Text.rich(
      TextSpan(
        children: textBlocks,
        style: (defaultTextStyle == null)
            ? Theme.of(context).textTheme.bodyLarge
            : defaultTextStyle,
      ),
      textAlign: widget.laTeXCode.textAlign,
      textDirection: widget.laTeXCode.textDirection,
      locale: widget.laTeXCode.locale,
      softWrap: widget.laTeXCode.softWrap,
      overflow: widget.laTeXCode.overflow,
      maxLines: widget.laTeXCode.maxLines,
      semanticsLabel: widget.laTeXCode.semanticsLabel,
    );
  }

  TextStyle? get _textSpecificStyle {
    final originalStyle = widget.laTeXCode.style;
    if (originalStyle == null || originalStyle.height == null) {
      return originalStyle;
    }
    // For text-only lines, use null height to allow Flutter to use default line spacing,
    // overriding a potentially large height meant for LaTeX lines.
    return originalStyle.copyWith(height: null);
  }

  List<TextSpan> _extractTextSpans(String text) {
    final texts = text.split(widget.breakDelimiter);
    final List<TextSpan> textSpans = [];
    for (int i = 0; i < texts.length; i++) {
      if (i != 0) {
        textSpans.add(
          TextSpan(text: '\n', style: _textSpecificStyle),
        );
      }
      final currentSegment = texts[i];
      if (currentSegment.isNotEmpty) {
        textSpans.add(
          TextSpan(text: currentSegment, style: _textSpecificStyle),
        );
      }
    }
    return textSpans;
  }

  List<InlineSpan> _extractWidgetSpans(String text) {
    text = text.replaceAll('\f', '').refactorExt().refactorRac();
    final texts = text.split(widget.breakDelimiter);
    final List<InlineSpan> widgetSpans = [];

    for (int i = 0; i < texts.length; i++) {
      if (i != 0) {
        widgetSpans.add(
          const TextSpan(
            text: '\n',
          ),
        );
      }

      final trimmedText = texts[i].trim();
      if (trimmedText.isEmpty) continue;

      final mathTex = Math.tex(
        trimmedText,
        textStyle: widget.equationStyle ?? widget.laTeXCode.style,
        onErrorFallback: (exception) =>
            widget.onErrorFallback?.call(trimmedText) ??
            Math.defaultOnErrorFallback(exception),
      );

      widgetSpans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            physics: const ClampingScrollPhysics(),
            child: mathTex,
          ),
        ),
      );
    }

    return widgetSpans;
  }
}
