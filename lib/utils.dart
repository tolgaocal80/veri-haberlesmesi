import 'center_base.dart';
import 'devices.dart';
import 'optimal_base.dart';
import 'dart:math' as math;

var WIDTH = 500;
var HEIGHT = 500;

double calculateDistanceFromCenterBase(Device device , CenterBase centerBase){
  double square = (device.X.toDouble() - centerBase.X.toDouble())*(device.X.toDouble() - centerBase.X.toDouble())
      + (device.Y.toDouble() - centerBase.Y.toDouble())*(device.Y.toDouble() - centerBase.Y.toDouble());
  double distance = math.sqrt(square);
  return distance;
}

double calculateDistanceFromOptimalBase(Device device , OptimalBase optimalBase){
  double square = (device.X.toDouble() - optimalBase.X.toDouble())*(device.X.toDouble() - optimalBase.X.toDouble())
      + (device.Y.toDouble() - optimalBase.Y.toDouble())*(device.Y.toDouble() - optimalBase.Y.toDouble());
  double distance = math.sqrt(square);
  return distance;
}

double calculateEnergyForOptimalBase(Device device, OptimalBase optimalBase){
  double energy = (device.X.toDouble() - optimalBase.X.toDouble())*(device.X.toDouble() - optimalBase.X.toDouble())
      + (device.Y.toDouble() - optimalBase.Y.toDouble())*(device.Y.toDouble() - optimalBase.Y.toDouble());
  return energy;
}

double calculateEnergyForCenterBase(Device device, CenterBase centerBase){
  double energy = (device.X.toDouble() - centerBase.X.toDouble())*(device.X.toDouble() - centerBase.X.toDouble())
      + (device.Y.toDouble() - centerBase.Y.toDouble())*(device.Y.toDouble() - centerBase.Y.toDouble());
  return energy;
}

int calculateEnergyForValue(Device device, int x, int y){
  int energy = (device.X- x)*( device.X- x )
      + ( device.Y-y)*( device.Y-y);
  return energy;
}