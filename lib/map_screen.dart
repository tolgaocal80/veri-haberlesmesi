import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veri_haberlesmesi/base.dart';
import 'package:veri_haberlesmesi/devices.dart';
import 'package:veri_haberlesmesi/optimal_base.dart';
import 'package:veri_haberlesmesi/utils.dart';
import 'center_base.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
 }

class _MapScreenState extends State<MapScreen> {

  // Center base station
  CenterBase centerBase = CenterBase();

 // Device list created
  List<Device> deviceList = List.generate(60, (_) => Device());

  double optimalEnergy = 0;
  double energyConsumptionForPoint = 0;

  makeDevices(int number){

    HashMap locationEnergies = HashMap<double, Base>();

    for(int x=0; x<500; x++){
      for(int y=0; y<500; y++){
        for(int i =0; i< deviceList.length ; i++) {
          energyConsumptionForPoint += calculateEnergyForValue(deviceList[i], x, y);
        }
        Base base = Base();
        base.X = x;
        base.Y = y;
        locationEnergies.putIfAbsent(energyConsumptionForPoint, () => base);
        energyConsumptionForPoint = 0;
      }
    }

    var sortedKeys = locationEnergies.keys.toList(growable: false)..sort();

    LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys, key: (k) => k, value: (k) => locationEnergies[k]);

    OptimalBase _optimalBase =  OptimalBase();
    Base _base = Base();

    optimalEnergy = sortedMap.entries.first.key;

    _base = sortedMap.entries.first.value;
    _optimalBase.X = _base.X;
    _optimalBase.Y = _base.Y;


    for(int i =0; i< deviceList.length ; i++) {
      deviceList[i].distanceFromCenterBase = calculateDistanceFromCenterBase(deviceList[i],centerBase);
      deviceList[i].energyForCenterBase = calculateEnergyForCenterBase(deviceList[i], centerBase);

      deviceList[i].distanceFromOptimalBase = calculateDistanceFromOptimalBase(deviceList[i], _optimalBase);
      deviceList[i].energyForOptimalBase = calculateEnergyForOptimalBase(deviceList[i], _optimalBase);
    }

    print("Optimal Energy : "+ optimalEnergy.toString() + " Optimal Base Location : " + sortedMap.entries.first.value.toString());
    print("Optimal Energy : "+ optimalEnergy.toString() + _optimalBase.toString());

    var devices = List.generate(number, (index) =>
        Positioned(
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlueAccent),
          ),
          left: deviceList[index].X.toDouble()-5,
          bottom: deviceList[index].Y.toDouble()-5,
        ),
    );
    devices.add(
        Positioned(
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green),
            ),
          left: _optimalBase.X.toDouble()-8,
          bottom: _optimalBase.Y.toDouble()-8,
        )
    );

    return devices;
  }


  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        // Outer Border
        Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black,width: 1),
            ),
            width: WIDTH.toDouble() + 10,
            height: HEIGHT.toDouble() + 10,
          ),
        ),
        // Center base
        Positioned(
          left: centerBase.X.toDouble()-8,
          bottom: centerBase.Y.toDouble()-8,
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black),
          ),
        ),

        // Devices
        Stack(
        children: makeDevices(60)
        ),

      ],
    ) ;

  }



}
