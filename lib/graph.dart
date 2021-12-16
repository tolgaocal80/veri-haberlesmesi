import 'package:draw_graph/models/feature.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veri_haberlesmesi/center_base.dart';
import 'package:veri_haberlesmesi/utils.dart';
import 'devices.dart';
import 'package:draw_graph/draw_graph.dart';


class Graph extends StatefulWidget {
   Graph({Key? key, required this.deviceListToGraph}) : super(key: key);

  List<Device> deviceListToGraph;

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {

  late List<Feature> features = [];
  List<double> centerEnergyList = [];
  List<double> tempList= [];
  List<double> group = [];
  List<double> calculateEnergy(List<Device> devices){

    int energyConsumptionForPoint = 0;

    for(int k=0; k< devices.length ; k++) {
      CenterBase centerBase = CenterBase();
      energyConsumptionForPoint = 0;

      for(int l=0; l<=k; l++){
        devices[l].energyForCenterBase = calculateEnergyForCenterBase(devices[l], centerBase);
        energyConsumptionForPoint += devices[l].energyForCenterBase as int;
      }
      centerBase.energy = energyConsumptionForPoint as double;
      centerEnergyList.add(centerBase.energy);
    }
    return centerEnergyList;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            right: 100,
            top: 50,
            child: ElevatedButton(
              child: const Text(
                  "Baz İstasyonu Haritası"
              ),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),

          Positioned(
            right: 100,
            top: 100,
            child: ElevatedButton(
              child: const Text(
                  "Run"
              ),
              onPressed: (){
                setState(() {
                  centerEnergyList.clear();
                  calculateEnergy(widget.deviceListToGraph);

                  tempList = centerEnergyList;
                  tempList.sort();
                  group = List.generate(centerEnergyList.length, (index) => centerEnergyList[index] * (1/tempList.last));


                  features = [
                    Feature(
                      title: "Center Base Energy Consumption - Device Number Graph",
                      color: Colors.blue,
                      data: group,
                    ),
                  ];
                });
              },
            ),
          ),

          Center(
            child: LineGraph(
              features: features,
              size: Size(900, 700),
              labelX: List.generate(centerEnergyList.length, (index) => (index).toString()),
              labelY: List.generate(centerEnergyList.length, (index) => calculateEnergy(widget.deviceListToGraph)[index].toString()),
              showDescription: true,
              graphColor: Colors.black87,
            ),
          )



        ],
      ),

    );
  }
}
