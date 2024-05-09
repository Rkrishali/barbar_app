import 'package:flutter/cupertino.dart';

class ProgressBarProvider extends ChangeNotifier {

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void changeLogging() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
