import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veri_haberlesmesi/base.dart';
import 'package:veri_haberlesmesi/devices.dart';
import 'package:veri_haberlesmesi/graph.dart';
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
  OptimalBase _optimalBase =  OptimalBase();
  Base _base = Base();

  late String centerBaseInfo;
  late String optimalBaseInfo;

  late int deviceCount;

  double energyConsumptionForPoint = 0;

  // Device list created

  late List<Device> deviceList = [];

  @override
  void initState(){
    super.initState();
    deviceCount = 10;
  }

  TextEditingController controller = TextEditingController();

  makeDevices(int number, List<Device> listOfDevice){

    HashMap locationEnergies = HashMap<double, Base>();

    for(int x=0; x<500; x++){
      for(int y=0; y<500; y++){
        for(int i =0; i< listOfDevice.length ; i++) {
          energyConsumptionForPoint += calculateEnergyForValue(listOfDevice[i], x, y);
        }
        Base base = Base();
        base.X = x;
        base.Y = y;
        base.energy = energyConsumptionForPoint;
        locationEnergies.putIfAbsent(energyConsumptionForPoint, () => base);
        energyConsumptionForPoint = 0;
      }
    }

    var sortedKeys = locationEnergies.keys.toList(growable: false)..sort();
    LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys, key: (k) => k, value: (k) => locationEnergies[k]);

    _base = sortedMap.entries.first.value;

    _optimalBase.X = _base.X;
    _optimalBase.Y = _base.Y;
    _optimalBase.energy = _base.energy;

    // Calculating Energy Consumption for Center Base Station
    for(int i =0; i< listOfDevice.length ; i++) {
      listOfDevice[i].distanceFromCenterBase = calculateDistanceFromCenterBase(listOfDevice[i],centerBase);
      listOfDevice[i].energyForCenterBase = calculateEnergyForCenterBase(listOfDevice[i], centerBase);

      listOfDevice[i].distanceFromOptimalBase = calculateDistanceFromOptimalBase(listOfDevice[i], _optimalBase);
      listOfDevice[i].energyForOptimalBase = calculateEnergyForOptimalBase(listOfDevice[i], _optimalBase);

      energyConsumptionForPoint += listOfDevice[i].energyForCenterBase;
    }

    centerBase.energy = energyConsumptionForPoint;

    print(centerBase.toString());
    print(_optimalBase.toString());

    centerBaseInfo = centerBase.toString();
    optimalBaseInfo = _optimalBase.toString();

    var devices = List.generate(listOfDevice.length, (index) =>
        Positioned(
          child: Container(
            child: GestureDetector(
              onTap: (){
              },
            ),
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlueAccent),
          ),
          left: listOfDevice[index].X.toDouble()-5,
          bottom: listOfDevice[index].Y.toDouble()-5,
        ),
    );
    devices.add(Positioned(
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green),
            ),
          left: _optimalBase.X.toDouble()-8,
          bottom: _optimalBase.Y.toDouble()-8,
        ));

    return devices;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        // Buttons
        Positioned(
          right: 150,
          top: 50,
          child: Container(
            width: 200,
            height: 600,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                // Enter Device Number
                Material(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Cihaz Sayısı Giriniz"),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    ),
                    controller: controller,
                    keyboardType: TextInputType.number,
                  ),
                ),
                ElevatedButton(
                    onPressed: (){
                      setState(() {
                        if(controller.text.isNotEmpty){
                          deviceCount = int.parse(controller.text);
                          deviceList = List.generate(deviceCount, (_) => Device());
                        }else{
                          return;
                        }
                      });
                    },
                    child: Text("Change Device Number")
                ),


                // Energy and Distance Values
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          setState(() {
                            _optimalBase.X = _base.X;
                            _optimalBase.Y = _base.Y;
                            _optimalBase.energy = _base.energy;
                            energyConsumptionForPoint = 0;

                            for(int i =0; i< deviceList.length ; i++) {
                              deviceList[i].distanceFromCenterBase = calculateDistanceFromCenterBase(deviceList[i],centerBase);
                              deviceList[i].energyForCenterBase = calculateEnergyForCenterBase(deviceList[i], centerBase);

                              deviceList[i].distanceFromOptimalBase = calculateDistanceFromOptimalBase(deviceList[i], _optimalBase);
                              deviceList[i].energyForOptimalBase = calculateEnergyForOptimalBase(deviceList[i], _optimalBase);

                              energyConsumptionForPoint += deviceList[i].energyForCenterBase;
                            }
                            centerBase.energy = energyConsumptionForPoint;
                            energyConsumptionForPoint = 0;

                            print(centerBase.toString());
                            print(_optimalBase.toString());
                          });
                        },
                        child: Text("Calculate Energy Consumption")
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    centerBase.energy == 0 ? CircularProgressIndicator() :  Container(
                      padding: EdgeInsets.all(10),

                      child: Text(
                        centerBase.energy == 0 ? "" : centerBase.toString(), style: TextStyle(fontSize: 14,color: Colors.black),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black,),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _optimalBase.energy == 0 ? CircularProgressIndicator() : Container(
                      padding: EdgeInsets.all(10),

                      child: Text(
                        _optimalBase.energy == 0 ? "" : _optimalBase.toString(), style: TextStyle(fontSize: 14,color: Colors.black),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black,),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),


                  ],
                ),

                // Energy Graph
                ElevatedButton(
                  child: const Text(
                      "Enerji Tüketimi Grafiğine Gidin",
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Graph(deviceListToGraph: deviceList,)));
                  },
                ),

              ],
            ),
          )

        ),
        // Devices
        Stack(
            children: makeDevices(deviceCount,deviceList)
        ),
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
      ],
    ) ;
  }



}
