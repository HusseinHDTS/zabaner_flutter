import 'package:get/get.dart';

class WebViewController extends GetxController{
  final _progress = 0.0.obs;
  final _isResultReceived = false.obs;

  void setResultReceived(bool _isReceived){
    _isResultReceived.value = _isReceived;
  }

  bool isResultReceived(){
    return _isResultReceived.value;
  }

  void setProgress(double progress){
    _progress.value = progress;
  }

  double getProgress(){
    return _progress.value;
  }

}