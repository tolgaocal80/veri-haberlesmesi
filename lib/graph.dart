import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veri_haberlesmesi/center_base.dart';
import 'package:veri_haberlesmesi/utils.dart';
import 'devices.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// for graph drawing


class Graph extends StatefulWidget {
   Graph({Key? key, required this.deviceListToGraph, required this.order}) : super(key: key);

   // RECEIVED DEVICE LIST TO DRAW GRAPH
  List<Device> deviceListToGraph;
  int order;

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {

  List<double> centerEnergyList = [];
  List<Values> values = [];


  // for graph drawing
  _getSeriesData() {
    List<charts.Series<Values, double>> series = [
      charts.Series(
          id: "Energy Ratio",
          data: values,
          domainFn: (Values value, _) => value.deviceNumber,
          measureFn: (Values value, _) => value.energy.toInt(),
          colorFn: (Values value, _) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];
    return series;
  }
  // for graph drawing
  List matchEnergyValues(List energyList, List deviceOrder, List values){
    List deviceCountList = List.generate((deviceOrder.length), (index) => index);
    deviceCountList.add(deviceOrder.length.toInt());
    for(int i =0; i<= energyList.length ; i++) {
      if(i==energyList.length){
        values.last.deviceNumber = i;
      }else{
        Values value = Values(energy: energyList[i], deviceNumber: deviceCountList[i]);
        values.add(value);
      }
    }
    return values;
  }


  /*
  CALCULATES CENTER BASE ENERGY VALUE FOR EVERY DEVICE COUNT
  FOR EXAMPLE IF THERE ARE 10 DEVICE,
  FUNCTION WILL CALCULATE TOTAL CENTER BASE REQUIRED ENERGY VALUE FOR
  device count = 1, => draw graph for required center base energy for 1 device.
  device count = 2, => draw graph for required center base energy for 2 device.
  device count = 3, => draw graph for required center base energy for 3 device.
  ...
   */
  List<double> calculateEnergy(List<Device> devices){
    double energyConsumptionForPoint = 0;
    for(int k=0; k< devices.length ; k++) {
      CenterBase centerBase = CenterBase();
      energyConsumptionForPoint = 0;
      for(int l=0; l<=k; l++){
        devices[l].energyForCenterBase = calculateEnergyForCenterBase(devices[l], centerBase,widget.order);
        energyConsumptionForPoint += devices[l].energyForCenterBase;
      }
      centerBase.energy = energyConsumptionForPoint;
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
            right: 50,
            top: 50,
            child: ElevatedButton(
              child: const Text(
                  "Base Station Map"
              ),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            right: 50,
            top: 100,
            child: ElevatedButton(
              child: const Text(
                  "Calculate"
              ),
              onPressed: (){
                setState(() {
                  centerEnergyList.clear();
                  calculateEnergy(widget.deviceListToGraph);
                  matchEnergyValues(centerEnergyList, widget.deviceListToGraph, values);
                  print(centerEnergyList.length);
                  print(widget.deviceListToGraph.length);
                });
              },
            ),
          ),


          // GRAPH HOLDER
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Center Base Energy Consumption Regarding Device Count",style: TextStyle(
                    fontSize: 20,fontWeight: FontWeight.bold
                ),
                ),
                const Divider(height: 20,),
                Container(
                  height: 600,
                  width: 800,
                  child: values.isEmpty == true ? null :
                  charts.LineChart(
                    _getSeriesData(),
                    animate: true,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// for graph drawing
class Values {
  double energy;
  double deviceNumber;
  Values({required this.energy,required this.deviceNumber});
}