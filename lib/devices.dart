import 'dart:math' as math;
import 'utils.dart';

class Device{

  late int Y;
  late int X;

  math.Random valueGiver = math.Random();

  Device(){
    Y = valueGiver.nextInt(HEIGHT);
    X = valueGiver.nextInt(WIDTH);
  }

  late double distanceFromOptimalBase;
  late double distanceFromCenterBase;

  late double energyForOptimalBase;
  late double energyForCenterBase;

}
