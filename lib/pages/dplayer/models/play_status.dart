import 'package:get/get.dart';

enum DPlayerStatus { completed, playing, paused }

class DPPlayerStatus {
  Rx<DPlayerStatus> status = Rx(DPlayerStatus.paused);

  bool get playing {
    return status.value == DPlayerStatus.playing;
  }

  bool get paused {
    return status.value == DPlayerStatus.paused;
  }

  bool get completed {
    return status.value == DPlayerStatus.completed;
  }
}
