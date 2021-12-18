import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veri_haberlesmesi/base.dart';
import 'package:veri_haberlesmesi/devices.dart';
import 'package:veri_haberlesmesi/graph.dart';
import 'package:veri_haberlesmesi/optimal_base.dart';
import 'package:veri_haberlesmesi/singleton.dart';
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

  // Optimal base station instance
  OptimalBase _optimalBase =  OptimalBase();

  // Generic base station instance
  Base _base = Base();

  // Energy-distance order
  int order = 2;

  // Device number
  late int deviceCount;

  double energyConsumptionForPoint = 0;


  // Device list
  List<Device> deviceList = Singleton.instance.deviceListSingleton;


  @override
  void initState(){
    super.initState();
    deviceCount = 10;
  }

  TextEditingController controller = TextEditingController();
  TextEditingController orderController = TextEditingController();

  makeDevices(int number, List<Device> listOfDevice){

    HashMap locationEnergies = HashMap<double, Base>();

    // AFTER CREATING A NUMBER OF DEVICE THAT EVERY DEVICE CONTAINS X & Y POINTS GENERATED RANDOMLY
    // THIS FUNCTION CALCULATES ENERGY CONSUMPTION FOR EVERY POINT(ASSUMED BASE STATION) FOR GIVEN 500 X 500 AREA.
    // THEN SORTS THE LIST AND FINDS OPTIMAL POINT FOR OPTIMAL BASE STATION

    for(int x=0; x<500; x++){
      for(int y=0; y<500; y++){
        for(int i =0; i< listOfDevice.length ; i++) {
          energyConsumptionForPoint += calculateEnergyForValue(listOfDevice[i], x, y,order);
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


    // THE BASE STATION THAT GIVES OPTIMAL ENERGY CONSUMPTION ATTENDED  AS OPTIMAL BASE STATION
    _base = sortedMap.entries.first.value;
    _optimalBase.X = _base.X;
    _optimalBase.Y = _base.Y;
    _optimalBase.energy = _base.energy;


    // CALCULATING ENERGY AND DISTANCE VALUES FOR CENTER BASE STATION
    //
    for(int i =0; i< listOfDevice.length ; i++) {
      listOfDevice[i].distanceFromCenterBase = calculateDistanceFromCenterBase(listOfDevice[i],centerBase);
      listOfDevice[i].energyForCenterBase = calculateEnergyForCenterBase(listOfDevice[i], centerBase, order);

      listOfDevice[i].distanceFromOptimalBase = calculateDistanceFromOptimalBase(listOfDevice[i], _optimalBase);
      listOfDevice[i].energyForOptimalBase = calculateEnergyForOptimalBase(listOfDevice[i], _optimalBase, order);

      energyConsumptionForPoint += listOfDevice[i].energyForCenterBase;
    }
    centerBase.energy = energyConsumptionForPoint;

    print(centerBase.toString());
    print(_optimalBase.toString());


    // RETURNS BASE STATION AS CIRCLE POINTS TO SHOW IN THE MAP
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

        Positioned(
          top: 50,
            right: 400,
            child: Container(
              width: 150,
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Enter Energy Order (distance^x)"),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      ),
                      controller: orderController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: (){
                        if(orderController.text.isNotEmpty){
                          setState(() {
                            order = int.parse(orderController.text);
                          });
                        }
                        print("Distance Order : $order");
                      },
                      child: const Text("Change Distance Order")
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      order == 2 ? "2" : "Distance Order : " + order.toString(), style: const TextStyle(fontSize: 14,color: Colors.black),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black,),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ],
              ),
            )
        ),

        Positioned(
          left: 50,
          top: 50,
          child: Container(
            height: 50,
            width: 200,
            child: ElevatedButton(
              child: const Text(
                "Go to Energy Consumption Graph for Center Base",
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Graph(deviceListToGraph: deviceList,order: order,)));
              },
            ),
          )
        ),

        // Buttons
        Positioned(
          right: 150,
          top: 50,
          child: Container(
            width: 200,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Material(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Enter Device Quantity"),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    ),
                    controller: controller,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                        print("Distance Order : $order");
                      });
                    },
                    child: const Text("Change Device Quantity")
                ),
                const SizedBox(
                  height: 10,
                ),

                // Energy and Distance Values
                ElevatedButton(
                        onPressed: (){
                          setState(() {
                            _optimalBase.X = _base.X;
                            _optimalBase.Y = _base.Y;
                            _optimalBase.energy = _base.energy;
                            energyConsumptionForPoint = 0;

                            for(int i =0; i< deviceList.length ; i++) {
                              deviceList[i].distanceFromCenterBase = calculateDistanceFromCenterBase(deviceList[i],centerBase);
                              deviceList[i].energyForCenterBase = calculateEnergyForCenterBase(deviceList[i], centerBase, order);

                              deviceList[i].distanceFromOptimalBase = calculateDistanceFromOptimalBase(deviceList[i], _optimalBase);
                              deviceList[i].energyForOptimalBase = calculateEnergyForOptimalBase(deviceList[i], _optimalBase, order);

                              energyConsumptionForPoint += deviceList[i].energyForCenterBase;
                            }
                            centerBase.energy = energyConsumptionForPoint;
                            energyConsumptionForPoint = 0;

                            print(centerBase.toString());
                            print(_optimalBase.toString());
                          });
                          print("Distance Order : $order");
                        },
                        child: const Text("Calculate Energy Consumption")
                    ),
                const SizedBox(
                  height: 20,
                ),

                centerBase.energy == 0 ? const CircularProgressIndicator() :  Container(
                  padding: const EdgeInsets.all(10),

                  child: Text(
                    centerBase.energy == 0 ? "" : centerBase.toString(), style: const TextStyle(fontSize: 14,color: Colors.black),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black,),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                _optimalBase.energy == 0 ? const CircularProgressIndicator() : Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    _optimalBase.energy == 0 ? "" : _optimalBase.toString(), style: const TextStyle(fontSize: 14,color: Colors.black),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black,),
                    borderRadius: const BorderRadius.all( Radius.circular(20)),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                centerBase.energy == 0 ? const CircularProgressIndicator() : Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    centerBase.energy == 0 ? "" : "Center Base Average Power Consumption (CenterBase Power/Device Count) : " + (centerBase.energy / deviceList.length).toString(),
                    style: const TextStyle(fontSize: 14,color: Colors.black),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black,),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                _optimalBase.energy == 0 ? const CircularProgressIndicator() : Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    _optimalBase.energy == 0 ? "" : "Optimal Base Average Power Consumption (OptimalBase Power/Device Count) : " + (_optimalBase.energy / deviceList.length).toString(),
                    style: const TextStyle(fontSize: 14,color: Colors.black),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black,),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _optimalBase.energy == 0 ? const CircularProgressIndicator() : Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    _optimalBase.energy == 0 ? "" : "Optimal Base distance from Center Base : " + (calculateOptimalBaseDistanceFromCenterBase(_optimalBase, centerBase)).toString(),
                    style: const TextStyle(fontSize: 14,color: Colors.black),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black,),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
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
