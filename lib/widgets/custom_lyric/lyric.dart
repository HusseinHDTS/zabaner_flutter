import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:async/async.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zabaner/models/sentence_model.dart';
import 'package:zabaner/widgets/custom_lyric/srt_parser.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zabaner/models/utils.dart';
import 'package:intl/intl.dart' as intl;
import '../colored_text.dart';

const _enable_paint_debug = false;

class Lyric extends StatefulWidget {
  ui.Image? image;

  Lyric({
    required this.lyric,
    required this.size,
    required this.playing,
    required this.lyricLineStyle,
    this.position,
    this.textAlign = TextAlign.center,
    this.highlight = Colors.red,
    this.faEnable = false,
    this.enEnable = false,
    this.image,
    this.autoScroll = true,
    this.onTap,
  }) : assert(lyric.size > 0);

  TextStyle lyricLineStyle;

  final LyricContent lyric;

  final TextAlign textAlign;

  final int? position;

  final Color highlight;

  final Size size;

  final VoidCallback? onTap;

  final bool playing;
  bool autoScroll;
  bool faEnable;
  bool enEnable;

  @override
  State<StatefulWidget> createState() => LyricState();
}

class LyricState extends State<Lyric> with TickerProviderStateMixin {
  LyricPainter? lyricPainter;

  AnimationController? _flingController;

  AnimationController? _lineController;

  AnimationController? _gradientController;
  // LyricState(){
  //   if(lyricPainter != null){
  //     lyricPainter = LyricPainter(
  //       widget.lyricLineStyle,
  //       widget.lyric,
  //       image: widget.image,
  //       textAlign: widget.textAlign,
  //       highlight: widget.highlight,
  //       faEnable: widget.faEnable,
  //       enEnable: widget.enEnable,
  //     );
  //   }
  // }
  @override
  void initState() {
    super.initState();
    lyricPainter = LyricPainter(
      widget.lyricLineStyle,
      widget.lyric,
      image: widget.image,
      textAlign: widget.textAlign,
      highlight: widget.highlight,
      faEnable: widget.faEnable,
      enEnable: widget.enEnable,
    );
    _scrollToCurrentPosition(widget.position!);
  }

  @override
  void didUpdateWidget(Lyric oldWidget) {
    //super.didUpdateWidget(oldWidget);
    if (widget.lyric != oldWidget.lyric) {
      lyricPainter = LyricPainter(
        widget.lyricLineStyle,
        widget.lyric,
        image: widget.image,
        textAlign: widget.textAlign,
        highlight: widget.highlight,
        faEnable: widget.faEnable,
        enEnable: widget.enEnable,
      );
    }

    if (widget.position != oldWidget.position) {
        _scrollToCurrentPosition(widget.position!);
    }

    if (widget.playing != oldWidget.playing) {
      if (!widget.playing) {
        _gradientController?.stop();
      } else {
        _gradientController?.forward();
      }
    }
  }

  /// scroll lyric to current playing position
  void _scrollToCurrentPosition(int milliseconds, {bool animate = true}) {
    if (lyricPainter!.height == -1) {
      WidgetsBinding.instance.addPostFrameCallback((d) {
//        debugPrint("try to init scroll to position ${widget.position.value},"
//            "but lyricPainter is unavaiable, so scroll(without animate) on next frame $d");
        //TODO maybe cause bad performance
        if (mounted) _scrollToCurrentPosition(milliseconds, animate: false);
      });
      return;
    }

    int line = widget.lyric
        .findLineByTimeStamp(milliseconds, lyricPainter!.currentLine);

    if (lyricPainter!.currentLine != line && !dragging) {
      double offset = lyricPainter!.computeScrollTo(line);
      if(widget.autoScroll == false){
        offset = 0.0;
      }
      if (animate) {
        _lineController?.dispose();
        _lineController = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 1000),
        )..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _lineController!.dispose();
              _lineController = null;
            }
          });

        Animation<double> animation = Tween<double>(
                begin: lyricPainter!.offsetScroll,
                end: lyricPainter!.offsetScroll + offset)
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(_lineController!);
        animation.addListener(() {
          lyricPainter!.offsetScroll = animation.value;
        });
        _lineController!.forward();
      } else {
        lyricPainter!.offsetScroll += offset;
      }

      _gradientController?.dispose();
      final entry = widget.lyric[line];
      final startPercent = (milliseconds - entry.position) / entry.duration;
      _gradientController = AnimationController(
        vsync: this,
        duration:
            Duration(milliseconds: (entry.duration - entry.position).toInt()),
      );
      _gradientController!.addListener(() {
        lyricPainter!.lineGradientPercent = _gradientController!.value;
      });
      if (widget.playing) {
        _gradientController!.forward(from: startPercent);
      } else {
        _gradientController!.value = startPercent;
      }
    }
    lyricPainter!.currentLine = line;
  }

  bool dragging = false;

  bool _consumeTap = false;

  @override
  void dispose() {
    _flingController?.dispose();
    _flingController = null;
    _lineController?.dispose();
    _lineController = null;
    _gradientController?.dispose();
    _gradientController = null;
    super.dispose();
  }

  Widget? cacheOld;

  @override
  Widget build(BuildContext _) {
    // cacheOld ??= ;
    // lyricPainter!.setLang(en: widget.enEnable,fa: widget.faEnable);
    // lyricPainter!.faEnable = widget.faEnable;
    // lyricPainter!.enEnable = widget.enEnable;
    return Container(
      constraints: BoxConstraints(minWidth: 300, minHeight: 120),
      child: Builder(
        builder: (context) {
          if(lyricPainter!.faEnable != widget.faEnable || lyricPainter!.enEnable != widget.enEnable) {
            lyricPainter = LyricPainter(
              widget.lyricLineStyle,
              widget.lyric,
              image: widget.image,
              textAlign: widget.textAlign,
              highlight: widget.highlight,
              faEnable: widget.faEnable,
              enEnable: widget.enEnable,
            );
          }
          return GestureDetector(
            onTap: () {
              if (!_consumeTap && widget.onTap != null) {
                widget.onTap!();
              } else {
                _consumeTap = false;
              }
            },
            onTapDown: (details) {
              if (dragging) {
                _consumeTap = true;

                dragging = false;
                _flingController?.dispose();
                _flingController = null;
              }
            },
            onVerticalDragStart: (details) {
              dragging = true;
              _flingController?.dispose();
              _flingController = null;
            },
            onVerticalDragUpdate: (details) {
              //debugPrint("details.primaryDelta : ${details.primaryDelta}");
              try {
                lyricPainter!.offsetScroll += details.primaryDelta!;
              }catch(e){
                e.printError();
              }
            },
            onVerticalDragEnd: (details) {
              _flingController = AnimationController.unbounded(
                vsync: this,
                duration: const Duration(milliseconds: 300),
              )
                ..addListener(() {
                  double value = _flingController!.value;

                  if (value < -lyricPainter!.height || value >= 0) {
                    _flingController!.dispose();
                    _flingController = null;
                    dragging = false;
                    value = value.clamp(-lyricPainter!.height, 0.0);
                  }
                  lyricPainter!.offsetScroll = value;
                  lyricPainter!.repaint();
                })
                ..addStatusListener((status) {
                  if (status == AnimationStatus.completed ||
                      status == AnimationStatus.dismissed) {
                    dragging = false;
                    _flingController?.dispose();
                    _flingController = null;
                  }
                })
                ..animateWith(ClampingScrollSimulation(
                    position: lyricPainter!.offsetScroll,
                    velocity: details.primaryVelocity!));
            },
            child: CustomPaint(
              size: widget.size,
              painter: lyricPainter,
            ),
          );
        }
      ),
    );
  }
}

class LyricPainter extends ChangeNotifier implements CustomPainter {
  double tmpPreDy = 0;

  LyricContent? lyric;

  //List<Subtitle> lyric;
  late List<TextPainter> mLyricPainters = [];

  TextPainter _highlightPainter = TextPainter(textDirection: TextDirection.ltr);

  double _offsetScroll = 0;

  double get offsetScroll => _offsetScroll;

  double _lineGradientPercent = -1;

  double get lineGradientPercent {
    if (_lineGradientPercent == -1) return 1.0;
    return _lineGradientPercent.clamp(0.0, 1.0);
  }
  set lineGradientPercent(double percent) {
    _lineGradientPercent = percent;
    repaint();
  }

  set offsetScroll(double value) {
    if (height == -1)
      return; // do not change offset when height is not available.
    _offsetScroll = value.clamp(-height, 0.0);
    repaint();
  }

  int currentLine = 0;

  TextAlign textAlign;

  late TextStyle _styleHighlight;
  bool faEnable = false;
  bool enEnable = false;
  void setLang({required bool fa , required bool en}){
    faEnable = fa;
    enEnable = en;
    repaint();
  }
  ui.Image? image;
  LyricPainter(TextStyle style, this.lyric,
      {this.textAlign = TextAlign.center,this.image,this.faEnable = false,this.enEnable = false, Color highlight = Colors.red}) {
    _highlightPainter = TextPainter(
        textDirection: textAlign == TextAlign.right
            ? TextDirection.rtl
            : TextDirection.ltr);
    assert(lyric != null);
    mLyricPainters = [];
      for (int i = 0; i < lyric!.size; i++) {
         var painter = TextPainter(
            text: TextSpan(
              style: style,
              children: [
                TextSpan(
                    text: !enEnable ? "" : intl.Bidi.stripHtmlIfNeeded(
                        whiteSpaceForSentence(lyric![i].line))),
                TextSpan(text: enEnable ? "\n" : ""),
                TextSpan(
                    text: !faEnable ? "" : intl.Bidi.stripHtmlIfNeeded(
                        whiteSpaceForSentence(lyric![i].faLine.toString()))),
                TextSpan(text: faEnable ? "\n" : ""),
              ],
            ),
            textAlign: textAlign);
        painter.textDirection = TextDirection.ltr;
        mLyricPainters.add(painter);
      // }
    }
    _styleHighlight = style.copyWith(color: highlight);
  }

  void repaint() {
    notifyListeners();
  }

  double get height => _height;
  double _height = -1;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    _layoutPainterList(size);
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // }
    double indexFC = (mLyricPainters[0].size.height);
    double dy =
        (offsetScroll + size.height / 4 - indexFC / 2);

    for (int line = 0; line < mLyricPainters.length; line++) {
      TextPainter painter = mLyricPainters[line];
      if(line == 0){
        if(image != null) {
          dy -= 100;
          drawImage(canvas, painter, image, dy, size);
          dy += (image!.height);
          // return;
        }
      }
      if (line == currentLine) {
        _paintCurrentLine(canvas, painter, dy, size);
      } else {
        drawLine(canvas, painter, dy, size);
      }
      dy += (painter.size.height);
    }
    // tmpPreDy = dy;
  }

  void _paintCurrentLine(
      ui.Canvas canvas, TextPainter painter, double dy, ui.Size size) {
    if (dy > size.height || dy < 0 - painter.size.height) {
      return;
    }

    //for current highlight line, draw background text first
    drawLine(canvas, painter, dy, size);
    var cTextSpan = TextSpan(
      style: _styleHighlight,
      children: (painter.text as TextSpan).children,
    );

    _highlightPainter
      ..text = cTextSpan
      ..textAlign = textAlign;

    _highlightPainter.layout(); //layout with unbound width

    double lineWidth = _highlightPainter.size.width;
    double gradientWidth = lineWidth;
    final double lineHeight = _highlightPainter.size.height;

    _highlightPainter.layout(maxWidth: size.width);

    final highlightRegion = Path();
    double lineDy = 0;
    while (gradientWidth > 0) {
      double dx = 0;
      if (lineWidth < size.width) {
        dx = (size.width - lineWidth) / 2;
      }
      highlightRegion.addRect(
          Rect.fromLTWH(0, dy + lineDy , dx + gradientWidth, lineHeight + 20));
      lineWidth -= _highlightPainter.size.width;
      gradientWidth -= _highlightPainter.size.width;
      lineDy += (lineHeight);
    }

    canvas.save();
    // canvas.clipPath(highlightRegion);

    drawLine(canvas, _highlightPainter, dy, size,isCurrent: true);
    // drawLine(canvas, _highlightPainter, dy, size);
    canvas.restore();

    assert(() {
      if (_enable_paint_debug) {
        final painter = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawPath(highlightRegion, painter);
      }
      return true;
    }());
  }


  ui.Paragraph createParagraph(String text,ui.Size size,ui.TextStyle tStyle,{bool isFa = false}) {
    TextAlign align = isFa ? TextAlign.right : TextAlign.left;
    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(fontSize: 18,textAlign: align,textDirection: isFa ? TextDirection.rtl : TextDirection.ltr,fontFamily: "Iransans_Fa_MD",fontWeight: FontWeight.w900));
    builder.pushStyle(tStyle);
    builder.addText(text);
    return builder.build()..layout(ui.ParagraphConstraints(width: size.width)); //..layout(const ParagraphConstraints(width: double.infinity));
  }

  void drawLine(ui.Canvas canvas, TextPainter painter, double dy, ui.Size size,
      {TextPainter? painterFa,bool isCurrent = false}) {
    if (dy > size.height || dy < 0 - painter.size.height) {
      return;
    }
    canvas.save();
    canvas.translate(_calculateAlignOffset(painter, size), dy);
    // canvas.drawParagraph(painter., Offset.zero);
    String t1 = "";
    String t2 = "";
    t1 = ((painter.text as TextSpan).children![0] as TextSpan).text.toString();
    // if((painter.text as TextSpan).children!.length >= 3){
    t2 = ((painter.text as TextSpan).children![2] as TextSpan).text.toString();
    // }
    ui.TextStyle normalStyle = ui.TextStyle(color: Colors.black.withOpacity(0.3),fontSize: 18);
    ui.TextStyle highlightStyle = ui.TextStyle(color: Colors.black,fontSize: 18);
    final a = createParagraph(t1,size,isCurrent ? highlightStyle : normalStyle);
    final b = createParagraph(t2,size,isCurrent ? highlightStyle : normalStyle,isFa: true);
    double firstDy = 0.0;
    if(t2 != ""){
      // firstDy = dy;
    }
    if(t1 != "") {
      canvas.drawParagraph(a, Offset(0, 20));
    }
    if(t2 != ""){
      canvas.drawParagraph(b, Offset(0, a.height + 20));
    }

    // canvas.drawParagraph(, paint);
    // TextPainter tPainter = TextPainter(text: p.text,textAlign:TextAlign.right);
    // ui.ParagraphBuilder()
    // tPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  void drawImage(ui.Canvas canvas, TextPainter painter,ui.Image? image, double dy, ui.Size size,
      {TextPainter? painterFa,bool isCurrent = false}) async{
    canvas.save();
    canvas.translate(_calculateAlignOffset(painter, size), dy);
    var paint = Paint();
    if(image != null) {
      // canvas.clipRRect(RRect.fromLTRBAndCorners(20, 20, 20, 20));
      canvas.clipRRect(BorderRadius.circular(18).toRRect(Rect.fromLTRB((size.width / 2 ) - (image.width /2), 0, image.width.toDouble() + (size.width / 2 ) - (image.width /2) , image.height.toDouble())));
      // canvas.drawImageRect(image, Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      //     Rect.fromLTWH(0, 0, (image.width / 1), (image.height / 1)),
      //     paint);
      canvas.drawImage(image, Offset((size.width / 2 ) - (image.width /2), 0), paint);
    }
    canvas.restore();
  }

  double _calculateAlignOffset(TextPainter painter, ui.Size size) {
    if (textAlign == TextAlign.center) {
      return (size.width - painter.size.width) / 2;
    }
    return 0;
  }

  @override
  bool shouldRepaint(LyricPainter oldDelegate) {
    return true;
  }

  void _layoutPainterList(ui.Size size) {
    _height = 0;
    try {
      mLyricPainters.forEach((p) {
        p.layout(maxWidth: size.width);
        _height += (p.size.height);
      });
    } catch (e) {
      e.printError();
    }
  }

  //compute the offset current offset to destination line
  double computeScrollTo(int destination) {
    if (mLyricPainters.isEmpty || this.height == 0) {
      return 0;
    }
    double height = -(mLyricPainters[0].size.height) / 2;
    for (int i = 0; i < mLyricPainters.length; i++) {
      if (i == destination) {
        height += (mLyricPainters[i].size.height) / 2;
        break;
      }
      height += (mLyricPainters[i].size.height);
    }
    return -(height + offsetScroll);
  }

  @override
  bool? hitTest(ui.Offset position) => null;

  @override
  get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(LyricPainter oldDelegate) =>
      shouldRepaint((oldDelegate));
}

class LyricContent {
  ///splitter lyric content to line
  static const LineSplitter _SPLITTER = const LineSplitter();

  static const int _default_line_duration = 5 * 1000;

  LyricContent.from(String text, {String faText = ""}) {
    //Parse srt
    List<Subtitle> srtContent = parseSrt(text);
    List<Subtitle> faSrtContent = parseSrt(faText);
    if(srtContent.isEmpty && faSrtContent.isEmpty){
      return;
    }
    int length = 0;
    if(srtContent.isEmpty){
      length = faSrtContent.length;
    }else{
      length = srtContent.length;
    }
    for (int i = 0; i < length; i++) {
      String faLine = "";
      String enLine = "";
      var item;
      if(srtContent.isEmpty){
        item = faSrtContent[i];
      }else{
        item = srtContent[i];
      }
      if (faSrtContent.asMap().containsKey(i)) {
        var faItem = faSrtContent[i];
        faLine = faItem.rawLines.join("\n").replaceAll("/l", "").replaceAll("l/", "");
      }
      if (srtContent.asMap().containsKey(i)) {
        var enItem = srtContent[i];
        enLine = enItem.rawLines.join("\n").replaceAll("/l", "").replaceAll("l/", "");
      }
      if(faText == ""){
        faLine = "";
      }
      if(text == ""){
        enLine = "";
      }
      _durations.add(item.range!.begin);

      _lyricEntries.add(LyricEntry(
          enLine, item.range!.begin, item.range!.end,faLine: faLine));
    }
  }

  List<int> _durations = [];
  List<LyricEntry> _lyricEntries = [];

  int get size => _durations.length;

  LyricEntry operator [](int index) {
    return _lyricEntries[index];
  }

  int _getTimeStamp(int index) {
    return _durations[index];
  }

  LyricEntry? getLineByTimeStamp(final int timeStamp, final int anchorLine) {
    if (size <= 0) {
      return null;
    }
    final line = findLineByTimeStamp(timeStamp, anchorLine);
    return this[line];
  }

  int findLineByTimeStamp(final int timeStamp, final int anchorLine) {
    int position = anchorLine;
    if (position < 0 || position > size - 1) {
      position = 0;
    }
    if (_getTimeStamp(position) > timeStamp) {
      //look forward
      while (_getTimeStamp(position) > timeStamp) {
        position--;
        if (position <= 0) {
          position = 0;
          break;
        }
      }
    } else {
      while (_getTimeStamp(position) < timeStamp) {
        position++;
        if (position <= size - 1 && _getTimeStamp(position) > timeStamp) {
          position--;
          break;
        }
        if (position >= size - 1) {
          position = size - 1;
          break;
        }
      }
    }
    return position;
  }

  @override
  String toString() {
    return 'Lyric{_lyricEntries: $_lyricEntries}';
  }
}

class LyricEntries {
  List<LyricEntry> lyrics;

  LyricEntries(this.lyrics);
}

class LyricEntry {
  static RegExp pattern = RegExp(r"\[\d{2}:\d{2}.\d{2,3}]");

  static int _stamp2int(final String stamp) {
    final int indexOfColon = stamp.indexOf(":");
    final int indexOfPoint = stamp.indexOf(".");

    final int minute = int.parse(stamp.substring(1, indexOfColon));
    final int second =
        int.parse(stamp.substring(indexOfColon + 1, indexOfPoint));
    int millisecond;
    if (stamp.length - indexOfPoint == 2) {
      millisecond =
          int.parse(stamp.substring(indexOfPoint + 1, stamp.length)) * 10;
    } else {
      millisecond =
          int.parse(stamp.substring(indexOfPoint + 1, stamp.length - 1));
    }
    return ((((minute * 60) + second) * 1000) + millisecond);
  }

  ///build from a .lrc file line .such as: [11:44.100] what makes your beautiful
  static void inflate(String line, Map<int, String> map) {
    //TODO lyric info
    if (line.startsWith("[ti:")) {
    } else if (line.startsWith("[ar:")) {
    } else if (line.startsWith("[al:")) {
    } else if (line.startsWith("[au:")) {
    } else if (line.startsWith("[by:")) {
    } else {
      var stamps = pattern.allMatches(line);
      var content = line.split(pattern).last;
      stamps.forEach((stamp) {
        int timeStamp = _stamp2int(stamp.group(0)!);
        map[timeStamp] = content;
      });
    }
  }

  LyricEntry(this.line, this.position, this.duration, {this.faLine})
      : this.timeStamp = getTimeStamp(position);

  final String timeStamp;
  final String line;
  final String? faLine;

  final int position;

  ///the duration of this line
  final int duration;

  @override
  String toString() {
    return 'LyricEntry{line: $line, timeStamp: $timeStamp}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LyricEntry &&
          runtimeType == other.runtimeType &&
          line == other.line &&
          timeStamp == other.timeStamp;

  @override
  int get hashCode => line.hashCode ^ timeStamp.hashCode;
}

String getTimeStamp(int milliseconds) {
  int seconds = (milliseconds / 1000).truncate();
  int minutes = (seconds / 60).truncate();

  String minutesStr = (minutes % 60).toString().padLeft(2, '0');
  String secondsStr = (seconds % 60).toString().padLeft(2, '0');

  return "$minutesStr:$secondsStr";
}

class PlayingLyric {
  CancelableOperation? _lyricLoader;

  String _message = 'Lyric not found';

  LyricContent? _lyricContent;
  List<Subtitle>? _lyricContentSrt;

  ///[lyric]，[lyric]=null，[message]=null
  String get message => _message;

  LyricContent? get lyric => _lyricContent;

  bool get hasLyric => lyric != null && lyric!.size > 0;

  //Music _music;
  void setLyric({String lyric = "", String faLyric = ""}) {
    if (lyric.isNotEmpty || faLyric.isNotEmpty) {
      _lyricContent = LyricContent.from(lyric, faText: faLyric);
    } else {
      _lyricContent = null;
    }
    if (_lyricContent?.size == 0) {
      _lyricContent = null;
    }
    if (_lyricContent == null) {
      _message = '';
    }
  }
}
