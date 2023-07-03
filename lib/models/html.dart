import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

import 'html_color.dart' as htmlColor;

// TODO Add tag handler
// TODO Add GestureRecognizer for a tag
InlineSpan parseHtmlToTextSpan(String? html, TextStyle style) {
  final document = parser.parse(html);
  final span = _parseRecursive(document.body, style, true);
  return span ?? TextSpan();
}

InlineSpan? _parseRecursive(Node? node, TextStyle style, bool styleChanged) {
  if (node is Text) {
    return _parseText(node, style, styleChanged);
  } else if (node is Element) {
    return _parseElement(node, style, styleChanged);
  } else {
    return _parseOtherNode(node, style, styleChanged);
  }
}

// TODO the method always remove whitespace at leading,
//  but it should check the tail of the previous span
String _fixWhitespaceInText(String text) {
  final sb = new StringBuffer();
  int pre = ' '.codeUnitAt(0);
  for (int c in text.codeUnits) {
    if (c == ' '.codeUnitAt(0) || c == '\n'.codeUnitAt(0)) {
      if (pre != ' '.codeUnitAt(0) && pre != '\n'.codeUnitAt(0)) {
        sb.writeCharCode(' '.codeUnitAt(0));
        pre = c;
      }
    } else {
      sb.writeCharCode(c);
      pre = c;
    }
  }
  return sb.toString();
}

InlineSpan? _parseText(Text text, TextStyle style, bool styleChanged) {
  var t = text.data;
  if (t == null || t.isEmpty) return null;
  t = _fixWhitespaceInText(t);
  return TextSpan(text: t, style: styleChanged ? style : null,);
}

TextDecoration _combine(TextDecoration? nullable, TextDecoration nonnull) {
  if (nullable == null) return nonnull;
  else return TextDecoration.combine([nullable, nonnull]);
}

InlineSpan? _parseElement(Element element, TextStyle style, bool styleChanged) {
  final tag = element.localName!.toLowerCase();

  GestureRecognizer? recognizer;

  switch (tag) {
    case "body":
    // Ignore
      break;
    case "br":
      return TextSpan(text: "\n", style: styleChanged ? style : null);
    case "strong":
    case "b":
      style = style.copyWith(fontWeight: FontWeight.bold);
      styleChanged = true;
      break;
    case "em":
    case "cite":
    case "dfn":
    case "i":
      style = style.copyWith(fontStyle: FontStyle.italic);
      styleChanged = true;
      break;
    case "u":
    case "ins":
      style = style.copyWith(decoration: _combine(style.decoration, TextDecoration.underline));
      styleChanged = true;
      break;
    case "del":
    case "s":
    case "strike":
      style = style.copyWith(decoration: _combine(style.decoration, TextDecoration.lineThrough));
      styleChanged = true;
      break;
    case "font":
      Color? color = htmlColor.tryParse(element.attributes['color']);
      if (color != null) {
        style = style.copyWith(color: color);
        styleChanged = true;
      }
      break;
    default:
      break;
  }

  return _parseParent(element, style, styleChanged, recognizer);
}

InlineSpan? _parseOtherNode(Node? node, TextStyle style, bool styleChanged) {
  return _parseParent(node, style, styleChanged, null);
}

InlineSpan? _parseParent(
    Node? node,
    TextStyle style,
    bool styleChanged,
    GestureRecognizer? recognizer
    ) {
  final children = <InlineSpan>[];
  node!.nodes.forEach((item) {
    // The change of style is applied below
    final span = _parseRecursive(item, style, false);
    if (span != null) children.add(span);
  });

  // Avoid TextSpan with no child
  if (children.length == 0) return null;

  // Avoid TextSpan with only one child
  if (children.length == 1) {
    final span = children.single;
    if (span is TextSpan) {
      // Keep origin style/recognizer, or use parent style/recognizer
      if ((span.style != null || !styleChanged) &&
          (span.recognizer != null || recognizer == null))
        return span;
      else return TextSpan(
        text: span.text,
        style: span.style != null ? span.style : style,
        recognizer: span.recognizer != null ? span.recognizer : recognizer,
      );
    }
    // TODO what if it's not TextSpan
  }

  return TextSpan(
    children: children,
    style: styleChanged ? style : null,
    recognizer: recognizer,
  );
}