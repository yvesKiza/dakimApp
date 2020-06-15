import 'package:shake/shake.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class ListenShake {
  static ShakeDetector detector;
 static void  start() {
    detector = ShakeDetector.autoStart(shakeSlopTimeMS: 5000,shakeCountResetTime: 6000,onPhoneShake: ()  {
           Future<bool> canVibrate =  Vibrate.canVibrate;
           canVibrate.then((value) {
             if(value){
                 Vibrate.vibrate();
             }
           });
       
    });
  }
}
