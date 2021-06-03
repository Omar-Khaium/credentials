import 'dart:async';

class AuthBLoC {

  final StreamController _authStatusController = StreamController();

  StreamSink<bool> get authStatusSink => _authStatusController.sink;

  Stream get authStatusStream => _authStatusController.stream;

  void dispose() {
    _authStatusController.close();
  }
}
