import 'dart:async';
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
    this.scrollOffset = 0,
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
  double scrollOffset = 0;
  bool autoScroll;
  bool faEnable;
  bool enEnable;

  @override
  State<StatefulWidget> createState() => LyricState();
}

class LyricState extends State<Lyric> with TickerProviderStateMixin {
  LyricPainter? lyricPainter;
  var imgList = <ui.Image?>[];

  AnimationController? _flingController;

  AnimationController? _lineController;

  AnimationController? _gradientController;

  @override
  void initState() {
    super.initState();
    getAllImages();
    lyricPainter = LyricPainter(
      widget.lyricLineStyle,
      widget.lyric,
      image: widget.image,
      imagesToLoad: imgList,
      textAlign: widget.textAlign,
      highlight: widget.highlight,
      faEnable: widget.faEnable,
      enEnable: widget.enEnable,
      autoScroll: widget.autoScroll,
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
        imagesToLoad: imgList,
        textAlign: widget.textAlign,
        highlight: widget.highlight,
        faEnable: widget.faEnable,
        autoScroll: widget.autoScroll,
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
    if (lyricPainter!.currentLine != line &&
        !dragging &&
        widget.autoScroll &&
        line != -1) {
      double offset = lyricPainter!.computeScrollTo(line);
      if (widget.playing && lyricPainter!.currentLine != 0 ||
          lyricPainter!.currentLine != -1) {
        offset -= widget.scrollOffset;
      }
      if (widget.autoScroll == false) {
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
      if (!widget.autoScroll) {
        lyricPainter!.currentLine = -1;
      } else {
        if (widget.playing && widget.autoScroll) {
          _gradientController!.forward(from: startPercent);
          lyricPainter!.currentLine = line;
        } else {
          _gradientController!.value = startPercent;
        }
      }
    }
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
      child: Builder(builder: (context) {
        if (lyricPainter!.faEnable != widget.faEnable ||
            lyricPainter!.enEnable != widget.enEnable || widget.autoScroll != lyricPainter!.autoScroll) {
          lyricPainter = LyricPainter(
            widget.lyricLineStyle,
            widget.lyric,
            imagesToLoad: imgList,
            image: widget.image,
            textAlign: widget.textAlign,
            highlight: widget.highlight,
            faEnable: widget.faEnable,
            autoScroll: widget.autoScroll,
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
            } catch (e) {
              // e.printError();
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
      }),
    );
  }

  Future<ui.Image> getUiImage(String imageLink) async {
    //https://zaban.languagecentre.ir/incredible-journey/Chapter%202%20-%20Part%201%20-%20Fa.srt
    ByteData bd =
        await NetworkAssetBundle(Uri.parse(imageLink)).load(imageLink);
    final Uint8List bytes = bd.buffer.asUint8List();
    int targetWidth = 300;
    int targetHeight = 200;
    int indexOfSize =
        (imageLink.lastIndexOf("?") == -1) ? 0 : imageLink.lastIndexOf("?");
    if (indexOfSize != 0) {
      var imageSize = imageLink.substring(indexOfSize).split("x");
      String imageWidth = imageSize[0];
      String imageHeight = imageSize[1];
      targetWidth = (int.tryParse(imageWidth) ?? 300);
      targetHeight = (int.tryParse(imageHeight) ?? 200);
    }

    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      allowUpscaling: true,
      targetHeight: targetHeight,
      targetWidth: targetWidth,
    );
    ui.Image _image = (await codec.getNextFrame()).image;
    return _image;
  }

  Future<List<ui.Image?>> getAllImages() async {
    // imgList.clear();
    for (int i = 0; i < widget.lyric.size; i++) {
      var item = widget.lyric[i];
      if (isLink(item.line)) {
        try {
          var img = await getUiImage(item.line);
          imgList.add(img);
        } catch (e) {
          imgList.add(null);
        }
        lyricPainter!.setImages(imgList);
        // getUiImage(item.line).then((img) => imgList.add(img));
      } else {
        imgList.add(null);
      }
    }
    // lyricPainter = LyricPainter(
    //   widget.lyricLineStyle,
    //   widget.lyric,
    //   imagesToLoad: imgList,
    //   image: widget.image,
    //   textAlign: widget.textAlign,
    //   highlight: widget.highlight,
    //   faEnable: widget.faEnable,
    //   autoScroll: widget.autoScroll,
    //   enEnable: widget.enEnable,
    // );
    return imgList;
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

  int currentLine = -1;

  TextAlign textAlign;

  late TextStyle _styleHighlight;
  bool faEnable = false;
  bool enEnable = false;
  bool autoScroll = false;
  var imagesToLoad = <ui.Image?>[];
  ui.Image? image;

  LyricPainter(TextStyle style, this.lyric,
      {this.textAlign = TextAlign.center,
      List<ui.Image?>? imagesToLoad,
      this.image,
      this.autoScroll = true,
      this.faEnable = false,
      this.enEnable = false,
      Color highlight = Colors.red}) {
    if (imagesToLoad != null &&
        imagesToLoad.isNotEmpty &&
        imagesToLoad.length != this.imagesToLoad.length) {
      this.imagesToLoad = imagesToLoad;
    }
    _highlightPainter = TextPainter(
        textDirection: textAlign == TextAlign.right
            ? TextDirection.rtl
            : TextDirection.ltr);
    assert(lyric != null);
    mLyricPainters = [];
    for (int i = 0; i < lyric!.size; i++) {
      var painter = TextPainter(
          text: TextSpan(
            children: [
              TextSpan(
                  text: !enEnable
                      ? ""
                      : intl.Bidi.stripHtmlIfNeeded(
                          whiteSpaceForSentence(lyric![i].line)),
                  style: TextStyle(
                      fontSize: getSubtitleFontSize(),
                      fontFamily: "Arial",
                      fontWeight: getSubtitleFontWeight())),
              TextSpan(text: enEnable ? "\n" : ""),
              TextSpan(
                  text: !faEnable
                      ? ""
                      : intl.Bidi.stripHtmlIfNeeded(
                          whiteSpaceForSentence(lyric![i].faLine.toString())),
                  style: TextStyle(
                      fontSize: getSubtitleFontSize(),
                      fontFamily: "Sahel",
                      fontWeight: getSubtitleFontWeight())),
              TextSpan(text: faEnable ? "\n" : ""),
            ],
          ),
          textAlign: textAlign);
      painter.textDirection = TextDirection.ltr;
      mLyricPainters.add(painter);
    }
    _styleHighlight = style.copyWith(color: highlight);
  }

  void setImages(images) {
    imagesToLoad = images;
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
    double dy = (offsetScroll + 20);

    for (int line = 0; line < mLyricPainters.length; line++) {
      TextPainter painter = mLyricPainters[line];
      if (line == 0) {
        if (image != null) {
          // dy -= 100;
          drawImage(canvas, painter, image, dy, size);
          dy += (image!.height);
        }
      }
      if (hasImageInPage(en: lyric![line].line,fa: lyric![line].faLine)) {
        String imgLink = "";
        if (isLink(lyric![line].line)) {
          imgLink = lyric![line].line;
        } else {
          imgLink = lyric![line].faLine.toString();
        }
        int indexOfSize =
            (imgLink.lastIndexOf("?") == -1) ? 0 : imgLink.lastIndexOf("?");
        int targetHeight = 200;
        if (indexOfSize != 0) {
          var imageSize = imgLink.substring(indexOfSize).split("x");
          String imageHeight = imageSize[1];
          targetHeight = (int.tryParse(imageHeight) ?? 200);
        }
        try {
          if (hasImageInPage(en: lyric![line].line,fa: lyric![line].faLine))
            drawImage(canvas, painter, imagesToLoad[line], dy, size,
                rounded: false);
        } catch (e) {
          // e.printError();
        }
        if (hasImageInPage(en: lyric![line].line,fa: lyric![line].faLine)) dy += (targetHeight);
      } else {
        bool shouldPaint = faEnable || enEnable;
        if (line == currentLine) {
          _paintCurrentLine(canvas, painter, dy, size,
              en: lyric![line].line, fa: lyric![line].faLine);
        } else {
          drawLine(canvas, painter, dy, size,
              en: lyric![line].line, fa: lyric![line].faLine);
        }
        dy += (painter.size.height);
      }
    }
    // tmpPreDy = dy;
  }

  void _paintCurrentLine(
      ui.Canvas canvas, TextPainter painter, double dy, ui.Size size,
      {String? fa, String? en}) {
    if (dy > size.height || dy < 0 - painter.size.height) {
      return;
    }

    //for current highlight line, draw background text first
    drawLine(canvas, painter, dy, size, fa: fa, en: en, isCurrent: true);
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
          Rect.fromLTWH(0, dy + lineDy, dx + gradientWidth, lineHeight + 20));
      lineWidth -= _highlightPainter.size.width;
      gradientWidth -= _highlightPainter.size.width;
      lineDy += (lineHeight);
    }

    canvas.save();
    // canvas.clipPath(highlightRegion);

    drawLine(canvas, _highlightPainter, dy, size, isCurrent: true);
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

  ui.Paragraph createParagraph(String text, ui.Size size, ui.TextStyle tStyle,
      {bool isFa = false}) {
    TextAlign align = isFa ? TextAlign.right : TextAlign.left;
    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
        fontSize: getSubtitleFontSize(),
        textAlign: align,
        textDirection: isFa ? TextDirection.rtl : TextDirection.ltr,
        fontFamily: isFa ? "Sahel" : "Arial",
        fontWeight: getSubtitleFontWeight()));

    builder.pushStyle(tStyle);
    builder.addText(text);
    return builder.build()
      ..layout(ui.ParagraphConstraints(
          width: size
              .width)); //..layout(const ParagraphConstraints(width: double.infinity));
  }

  List<ui.Paragraph> generatePars({en,fa,size,bool isCurrent = false}){
    String t1 = "";
    String t2 = "";
    t1 = (en ?? "");
    t2 = (fa ?? "");
    ui.TextStyle normalStyle = ui.TextStyle(color: Colors.grey, fontSize: getSubtitleFontSize());
    ui.TextStyle highlightStyle =
    ui.TextStyle(color: Colors.black, fontSize: getSubtitleFontSize());
    var style = autoScroll ? (isCurrent ? highlightStyle : normalStyle) : highlightStyle;
    final a =
    createParagraph(t1, size, style);
    final b = createParagraph(
        t2, size, style,
        isFa: true);
    return[a,b];
  }

  void drawLine(ui.Canvas canvas, TextPainter painter, double dy, ui.Size size,
      {TextPainter? painterFa,
      bool isCurrent = false,
      String? en,
      String? fa}) {
    if (dy > size.height || dy < 0 - painter.size.height) {
      return;
    }
    canvas.save();
    canvas.translate(_calculateAlignOffset(painter, size), dy);
    var pars = generatePars(en: en,fa: fa,size: size,isCurrent: isCurrent);
    if (enEnable) {
      canvas.drawParagraph(pars[0], Offset(0, 20));
    }
    if (faEnable) {
      canvas.drawParagraph(pars[1], Offset(0, (enEnable ? pars[0].height : 0) + 22));
    }

    // canvas.drawParagraph(, paint);
    // TextPainter tPainter = TextPainter(text: p.text,textAlign:TextAlign.right);
    // ui.ParagraphBuilder()
    // tPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  void drawImage(ui.Canvas canvas, TextPainter painter, ui.Image? image,
      double dy, ui.Size size,
      {TextPainter? painterFa,
      bool isCurrent = false,
      bool rounded = true}) async {
    canvas.save();
    canvas.translate(_calculateAlignOffset(painter, size), dy);
    var paint = Paint();
    if (image != null) {
      // canvas.clipRRect(RRect.fromLTRBAndCorners(20, 20, 20, 20));
      if (rounded) {
        canvas.clipRRect(BorderRadius.circular(18).toRRect(Rect.fromLTRB(
            (size.width / 2) - (image.width / 2),
            0,
            image.width.toDouble() + (size.width / 2) - (image.width / 2),
            image.height.toDouble())));
      }
      // canvas.drawImageRect(image, Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      //     Rect.fromLTWH(0, 0, (image.width / 1), (image.height / 1)),
      //     paint);
      canvas.drawImage(
          image, Offset((size.width / 2) - (image.width / 2), 0), paint);
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
      // e.printError();
    }
  }
  bool hasImageInPage({fa,en}){
    bool hasImageInPage = false;
    if(faEnable){
      if(isLink(fa)){
        hasImageInPage = true;
        return hasImageInPage;
      }
    }
    if(enEnable){
      if(isLink(en)){
        hasImageInPage = true;
        return hasImageInPage;
      }
    }
    return hasImageInPage;
  }
  //compute the offset current offset to destination line
  double computeScrollTo(int destination) {
    if (mLyricPainters.isEmpty || this.height == 0) {
      return 0;
    }
    double height = -(mLyricPainters[0].size.height) / 2;
    for (int i = 0; i < mLyricPainters.length; i++) {
      if (i == destination) {
        if(hasImageInPage(fa: lyric![i].faLine , en: lyric![i].line)){
          try{
            height += imagesToLoad[i]!.height /2;
          }catch(e){
            e.printError();
          }
        }else{
          height += (mLyricPainters[i].size.height) / 2;
        }
        break;
      }
      if(hasImageInPage(fa: lyric![i].faLine , en: lyric![i].line)){
        try{
          height += imagesToLoad[i]!.height;
        }catch(e){
          e.printError();
        }
      }else{
        height += (mLyricPainters[i].size.height);
      }
    }
    height += 20;
    var res = -(height + offsetScroll);
    // res += 20;
    return res;
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
    if (srtContent.isEmpty && faSrtContent.isEmpty) {
      return;
    }
    int length = 0;
    if (srtContent.isEmpty) {
      length = faSrtContent.length;
    } else {
      length = srtContent.length;
    }
    for (int i = 0; i < length; i++) {
      String faLine = "";
      String enLine = "";
      var item;
      if (srtContent.isEmpty) {
        item = faSrtContent[i];
      } else {
        item = srtContent[i];
      }
      if (faSrtContent.asMap().containsKey(i)) {
        var faItem = faSrtContent[i];
        faLine = faItem.rawLines
            .join("\n")
            .replaceAll("/l", "")
            .replaceAll("l/", "");
      }
      if (srtContent.asMap().containsKey(i)) {
        var enItem = srtContent[i];
        enLine = enItem.rawLines
            .join("\n")
            .replaceAll("/l", "")
            .replaceAll("l/", "");
      }
      if (faText == "") {
        faLine = "";
      }
      if (text == "") {
        enLine = "";
      }
      _durations.add({"begin": item.range!.begin, "end": item.range!.end});

      _lyricEntries.add(LyricEntry(enLine, item.range!.begin, item.range!.end,
          faLine: faLine));
    }
  }

  List<dynamic> _durations = [];
  List<LyricEntry> _lyricEntries = [];

  int get size => _durations.length;

  LyricEntry operator [](int index) {
    return _lyricEntries[index];
  }

  dynamic _getTimeStamp(int index) {
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
    if (_getTimeStamp(position)['begin'] > timeStamp) {
      //look forward
      while (_getTimeStamp(position)['begin'] > timeStamp) {
        position--;
        if (position <= 0) {
          position = 0;
          break;
        }
      }
    } else {
      while (_getTimeStamp(position)['begin'] < timeStamp) {
        position++;
        if (position <= size - 1 &&
            _getTimeStamp(position)['begin'] > timeStamp) {
          position--;
          break;
        }
        if (position >= size - 1) {
          position = size - 1;
          break;
        }
      }
    }
    // position = anchorLine;
    // if (position < 0 || position > size - 1) {
    //   position = -1;
    // }
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
