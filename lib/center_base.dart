import 'package:veri_haberlesmesi/utils.dart';

// CENTER BASE LOCATION
// THIS CLASS GENERATES A BASE STATION CENTERED TO GIVEN AREA
// EVERY BASE STATION HAS 3 FIELD, "required energy",  "X coordinate", "Y coordinate"

class CenterBase {

  double energy = 0;

  late int Y;
  late int X;

  CenterBase(){
    Y = (HEIGHT / 2) as int;
    X = (WIDTH / 2) as int;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Center Base Location\n X: $X Y: $Y \n Energy Consumption: $energy";
  }

}