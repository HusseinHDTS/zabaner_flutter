import 'package:zabaner/models/utils.dart';

extension Level on int {
  String level() {
    int input = this;
    if (input < (lvl1 * 60 )+ 1) return "سطح 1";
    if (input < (lvl2 * 60 )+ 1) return "سطح 2";
    if (input < (lvl3 * 60 )+ 1) return "سطح 3";
    if (input < (lvl4 * 60 )+ 1) return "سطح 4";
    if (input < (lvl5 * 60 )+ 1) return "سطح 5";
    if (input > (lvl6 * 60 )+ 1) return "سطح 6";
    return "";
  }

  int levelNumber() {
    int input = this;
    if (input < (lvl1 * 60 )+ 1) return 1;
    if (input < (lvl2 * 60 )+ 1)  return 2;
    if (input < (lvl3 * 60 )+ 1)  return 3;
    if (input < (lvl4 * 60 )+ 1)  return 4;
    if (input < (lvl5 * 60 )+ 1)  return 5;
    if (input > (lvl6 * 60 )+ 1)  return 6;
    return 0;
  }
}

extension Timer on int {
  String formatSecond() {
    Duration duration = Duration(seconds: this);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  formatedTime() {
    int timeInSecond = this;
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }

  String formatTimer() {
    Duration duration = Duration(seconds: this);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

extension StringToDuration on String {
  Duration toDuration() {
    String input = this;
    List times = input.split(':');
    return Duration(
        hours: int.parse(times[0]),
        minutes: int.parse(times[1]),
        seconds: int.parse(times[2]));
  }
}

extension Percent on int {
  double levelPercent() {
    int input = this;
    if (input < (lvl1 * 60 )+ 1) return (input / (lvl1 * 60 ));
    if (input < (lvl2 * 60 )+ 1) return (input / (lvl2 * 60 ));
    if (input < (lvl3 * 60 )+ 1) return (input / (lvl3 * 60 ));
    if (input < (lvl4 * 60 )+ 1) return (input / (lvl4 * 60 ));
    if (input < (lvl5 * 60 )+ 1) return (input / (lvl5 * 60 ));
    if (input > (lvl6 * 60 )+ 1) return (input / (lvl6 * 60 ));
    return 1;
  }
}

extension Current on int {
  String showCurrent() {
    int input = this;
    if (input < (lvl1 * 60 )+ 1) return "$lvl1 / ${((input) / 60).round()}";
    if (input < (lvl2 * 60 )+ 1) return "$lvl2 / ${((input) / 60).round()}";
    if (input < (lvl3 * 60 )+ 1) return "$lvl3 / ${((input) / 60).round()}";
    if (input < (lvl4 * 60 )+ 1) return "$lvl4 / ${((input) / 60).round()}";
    if (input < (lvl5 * 60 )+ 1) return "$lvl5 / ${((input) / 60).round()}";
    if (input > (lvl6 * 60 )+ 1) return "$lvl6 / ${((input) / 60).round()}";
    return "";
  }
}
