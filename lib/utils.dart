import 'center_base.dart';
import 'devices.dart';
import 'optimal_base.dart';
import 'dart:math' as math;

// BASE LOCATION AREA METRICS
var WIDTH = 500;
var HEIGHT = 500;

// order VALUE REQUIRED FOR CALCULATING ENERGY-DISTANCE RELATION
// FOR EXAMPLE IF Energy=Distance^2, the order value will be 2.

// CALCULATES DISTANCE FROM CENTER BASE STATION AND RETURNS THE VALUE
double calculateDistanceFromCenterBase(Device device , CenterBase centerBase){

  // DISTANCE CALCULATED BY PISAGOR THEOREM
  // x^2 + y^2 = z^2 => distance = z

  double square = (device.X.toDouble() - centerBase.X.toDouble())*(device.X.toDouble() - centerBase.X.toDouble())
      + (device.Y.toDouble() - centerBase.Y.toDouble())*(device.Y.toDouble() - centerBase.Y.toDouble());
  double distance = math.sqrt(square);
  return distance;
}

// CALCULATES DISTANCE FROM OPTIMAL BASE STATION TO CENTER BASE AND RETURNS THE VALUE
double calculateOptimalBaseDistanceFromCenterBase(OptimalBase device , CenterBase centerBase){

  // DISTANCE CALCULATED BY PISAGOR THEOREM
  // x^2 + y^2 = z^2 => distance = z

  double square = (device.X.toDouble() - centerBase.X.toDouble())*(device.X.toDouble() - centerBase.X.toDouble())
      + (device.Y.toDouble() - centerBase.Y.toDouble())*(device.Y.toDouble() - centerBase.Y.toDouble());
  double distance = math.sqrt(square);
  return distance;
}

// CALCULATES DISTANCE FROM OPTIMAL BASE STATION AND RETURNS THE VALUE
double calculateDistanceFromOptimalBase(Device device , OptimalBase optimalBase){

  // DISTANCE CALCULATED BY PISAGOR THEOREM
  // x^2 + y^2 = z^2 => distance = z

  double square = (device.X.toDouble() - optimalBase.X.toDouble())*(device.X.toDouble() - optimalBase.X.toDouble())
      + (device.Y.toDouble() - optimalBase.Y.toDouble())*(device.Y.toDouble() - optimalBase.Y.toDouble());
  double distance = math.sqrt(square);
  return distance;
}

// CALCULATES ENERGY FOR OPTIMAL BASE STATION AND RETURNS THE VALUE
double calculateEnergyForOptimalBase(Device device, OptimalBase optimalBase, int order){

  // DISTANCE CALCULATED BY PISAGOR THEOREM
  // x^2 + y^2 = z^2 => distance = z

  // ENERGY CALCULATED BY ORDER-DISTANCE RELATION
  // FOR EXAMPLE IF GIVEN ORDER IS 3 => energy = distance^3

  double distance = calculateDistanceFromOptimalBase(device,optimalBase);
  double energy = math.pow(distance, order).toDouble();
  return energy;
}

// CALCULATES ENERGY FROM CENTER BASE STATION AND RETURNS THE VALUE
double calculateEnergyForCenterBase(Device device, CenterBase centerBase, int order){

  // DISTANCE CALCULATED BY PISAGOR THEOREM
  // x^2 + y^2 = z^2 => distance = z

  // ENERGY CALCULATED BY ORDER-DISTANCE RELATION
  // FOR EXAMPLE IF GIVEN ORDER IS 3 => energy = distance^3

  double distance = calculateDistanceFromCenterBase(device,centerBase);
  double energy = math.pow(distance, order).toDouble();
  return energy;
}

// CALCULATES ENERGY FOR GIVEN BASE AND RETURNS THE VALUE
double calculateEnergyForValue(Device device, int x, int y, int order){

  // DISTANCE CALCULATED BY PISAGOR THEOREM
  // x^2 + y^2 = z^2 => distance = z

  // ENERGY CALCULATED BY ORDER-DISTANCE RELATION
  // FOR EXAMPLE IF GIVEN ORDER IS 3 => energy = distance^3

  int distance2 = (device.X- x)*( device.X- x )
      + ( device.Y-y)*( device.Y-y);
  double distance = math.sqrt(distance2);

  double energy = math.pow(distance, order).toDouble();

  return energy;
}