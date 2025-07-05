import 'dart:async';

class Throttler {
  final Duration delay;
  Timer? _timer;
  bool _isThrottled = false;

  Throttler({required this.delay});

  void call(void Function() callback) {
    if (!_isThrottled) {
      callback();
      _isThrottled = true;
      _timer = Timer(delay, () {
        _isThrottled = false;
      });
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}
