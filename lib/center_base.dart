import 'package:veri_haberlesmesi/utils.dart';

class CenterBase {

  double? energy = 0;

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