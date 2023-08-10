import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CustomCircularProgressBar extends StatelessWidget {
  bool hasAnimation;
  double progress;
  double radius;
  Rx<double> _currentProgress = 0.0.obs;
  CustomCircularProgressBar({Key? key,this.progress = 0,this.radius = 1,this.hasAnimation = false}) : super(key: key){
    if(!hasAnimation){
      _currentProgress = progress.obs;
    }else{
      Timer.periodic(const Duration(milliseconds: 1),(_timer)
      {
        if(_currentProgress.value == progress) {
          _timer.cancel();
          return;
        }
        _currentProgress.value += 1;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          showLabels: false,
          showTicks: false,
          radiusFactor: radius,
          pointers:  <GaugePointer>[
            RangePointer(
              value: _currentProgress.value,
              cornerStyle: CornerStyle.bothCurve,
              enableAnimation: true,
              animationDuration: 100,
              animationType: AnimationType.linear,
              width: 0.2,
              color: Colors.white70.withOpacity(0.88),
              sizeUnit: GaugeSizeUnit.factor,
            )
          ],
          startAngle: 270,
          endAngle: (270 * 5) / 7,
          axisLineStyle: AxisLineStyle(
            thickness: 0.2,
            cornerStyle: CornerStyle.bothCurve,
            color:Colors.black38,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
        )
      ]),
    );
  }
}
