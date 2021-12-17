
// GENERIC BASE STATION
// WHEN CALCULATING OPTIMAL BASE STATION, EVERY POINT ON MAP WILL TREATED AS GENERIC BASE
// AFTER FOUND OPTIMAL POINT WE WILL PASS THAT BASE VALUES TO IT

class Base{
  late int X;
  late int Y;

  double energy = 0;

  @override
  String toString() {
    // TODO: implement toString
    return "Base X:$X Y:$Y";
  }

}