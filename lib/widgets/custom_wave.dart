import 'package:flutter/material.dart';

class WaveClipPath extends AnimatedWidget {
  final Animation<double> animation;
  Color backgroundColor;

  WaveClipPath(this.animation,{this.backgroundColor = Colors.red})
      : super(listenable: animation);


  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        bottom: 0,
        right: animation.value,
        child: ClipPath(
          clipper: BottomWaveClipper(),
          child: Opacity(
            opacity: 1,
            child: Container(
              color: backgroundColor,
              width: double.infinity,
              height: 200,
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 15,
        left: animation.value,
        child: ClipPath(
          clipper: BottomWaveClipper(),
          child: Opacity(
            opacity: 0.8,
            child: Container(
              color: backgroundColor,
              width: double.infinity,
              height: 200,
            ),
          ),
        ),
      ),
    ]);
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, 40.0);
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 40.0);

    for (int i = 0; i < 10; i++) {
      if (i % 2 == 0) {
        path.quadraticBezierTo(
            size.width - (size.width / 16) - (i * size.width / 8),
            0.0,
            size.width - ((i + 1) * size.width / 8),
            size.height - 160);
      } else {
        path.quadraticBezierTo(
            size.width - (size.width / 16) - (i * size.width / 8),
            size.height - 120,
            size.width - ((i + 1) * size.width / 8),
            size.height - 160);
      }
    }

    path.lineTo(0.0, 40.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomWaveAnimation extends StatefulWidget {
  Color waveColor;
  CustomWaveAnimation({this.waveColor = Colors.red});

  @override
  _MyAnimationState createState() => _MyAnimationState();
}

class _MyAnimationState extends State<CustomWaveAnimation>
    with SingleTickerProviderStateMixin {

  Animation<double>? animation;
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(seconds: 8),
        vsync: this)..repeat();

    animation = Tween<double>(begin: -500, end: 0).animate(_controller!);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WaveClipPath(
        animation!,
      backgroundColor: widget.waveColor,
    );
  }
}