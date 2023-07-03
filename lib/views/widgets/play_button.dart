import 'package:flutter/material.dart';
import 'dart:math' show pi;

import 'package:get/get.dart';

class PlayButton extends StatefulWidget {
  RxBool? initialIsPlaying;
  final Widget playIcon;
  final Icon pauseIcon;
  // final VoidCallback onPressed;
  final WillPopCallback onPressed;
  PlayButton({
    required this.onPressed,
    this.initialIsPlaying,
    this.playIcon = const Icon(Icons.play_arrow),
    this.pauseIcon = const Icon(Icons.pause),
  }) : assert(onPressed != null);

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  static const _kToggleDuration = Duration(milliseconds: 300);
  static const _kRotationDuration = Duration(seconds: 5);

  RxBool? isPlaying;

  // rotation and scale animations
  AnimationController? _rotationController;
  AnimationController? _scaleController;
  double _rotation = 0;
  double _scale = 0.85;

  bool get _showWaves => !_scaleController!.isDismissed;

  void _updateRotation() => _rotation = _rotationController!.value * 2 * pi;
  void _updateScale() => _scale = (_scaleController!.value * 0.2) + 0.85;

  @override
  void initState() {
    isPlaying = widget.initialIsPlaying;
    _rotationController =
    AnimationController(vsync: this, duration: _kRotationDuration)
      ..addListener(() => setState(_updateRotation))
      ..repeat();

    _scaleController =
    AnimationController(vsync: this, duration: _kToggleDuration)
      ..addListener(() => setState(_updateScale));
    super.initState();
  }

  void _onToggle() async{
    bool shouldPlay = await widget.onPressed();
    if(shouldPlay == false){
      return;
    }
    // setState(() => isPlaying!.toggle());

    if (_scaleController!.isCompleted) {
      _scaleController!.reverse();
    } else {
      _scaleController!.forward();
    }

  }

  Widget _buildIcon(RxBool isPlaying) {
    return SizedBox.expand(
      key: ValueKey<bool>(isPlaying.value),
      child: Obx(()=>IconButton(
        icon: isPlaying.value ? widget.pauseIcon : widget.playIcon,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        disabledColor: Colors.transparent,
        onPressed: _onToggle,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 48, minHeight: 48),
      child: Obx((){
        if (isPlaying!.isFalse) {
          _scaleController!.reverse();
        } else {
          _scaleController!.forward();
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            if (_showWaves) ...[
              Blob(color: Color(0xff0092ff), scale: _scale, rotation: _rotation),
              Blob(color: Color(0xff4ac7b7), scale: _scale, rotation: _rotation * 2 - 30),
              Blob(color: Color(0xffa4a6f6), scale: _scale, rotation: _rotation * 3 - 45),
            ],
            Container(
              constraints: BoxConstraints.expand(),
              child: AnimatedSwitcher(
                child: _buildIcon(isPlaying!),
                duration: _kToggleDuration,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    _scaleController!.dispose();
    _rotationController!.dispose();
    super.dispose();
  }
}

class Blob extends StatelessWidget {
  final double rotation;
  final double scale;
  final Color? color;

  const Blob({this.color, this.rotation = 0, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(150),
              topRight: Radius.circular(240),
              bottomLeft: Radius.circular(220),
              bottomRight: Radius.circular(180),
            ),
          ),
        ),
      ),
    );
  }
}