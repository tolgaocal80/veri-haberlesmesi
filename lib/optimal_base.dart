

// THE OPTIMAL BASE STATION, WILL BE CALCULATED AFTER THE DEVICES DISTRIBUTED TO THE AREA
class OptimalBase{
  late int Y;
  late int X;

  double energy = 0;

  @override
  String toString() {
    // TODO: implement toString
    return "Optimal Base Location \n X: $X Y: $Y \n Energy Consumption: $energy";
  }
}