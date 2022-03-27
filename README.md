# veri_haberlesmesi


![](https://docs.google.com/uc?export=download&id=1FQFOSO4Wev08ISxIpywHnDFl-XGM2dky)

https://docs.google.com/uc?export=download&id=1FQFOSO4Wev08ISxIpywHnDFl-XGM2dky

## Data-Communications Project

1)  In this project, we will create a random generated  list of "Receiver Devices"  than, this devices will be distributed to a 500 x 500 area.

2) Than a "Center Base Station" will be created which its coordinates are (250,250).

3) After that, required energy consumption of every point of the 500 x 500 area, will be calculated for every point. 

4) For example if it would be "Base Station" on the point (1,245) how much energy would require to run a base station for the given device list.

5) After every point, the minimal energy required "Base Station" point will be "Optimal Base Station" point.

* Distance - Energy relation defaults to order = 2, which means energy calcualtion will **Energy=Distance^2**.
If you can change order to 3 or whatever number, calculation will be **Energy = Distance^x**.

# Explanation of Classes

GENERIC BASE STATION
WHEN CALCULATING OPTIMAL BASE STATION, EVERY POINT ON MAP WILL TREATED AS GENERIC BASE
AFTER FOUND OPTIMAL POINT WE WILL PASS THAT BASE VALUES TO IT

```
class Base{
  late int X;
  late int Y;
  double energy = 0;
}
```


CENTER BASE LOCATION
THIS CLASS GENERATES A BASE STATION CENTERED TO GIVEN AREA
EVERY BASE STATION HAS 3 FIELD, "required energy",  "X coordinate", "Y coordinate"

```
class CenterBase {
  double energy = 0;
  late int Y;
  late int X;
  CenterBase(){
    Y = (HEIGHT / 2) as int;
    X = (WIDTH / 2) as int;
  }
}
```

THIS CLASS MEMBERS WILL BE TREATED AS A DEVICE (NODE, RECEIVER, USER etc..)
EVERY DEVICE HAS A X,Y COORDINATE AND DISTANCE AND ENERGY VALUES
```
class Device{
  late int Y;
  late int X;
  math.Random valueGiver = math.Random();
  Device(){
    Y = valueGiver.nextInt(HEIGHT);
    X = valueGiver.nextInt(WIDTH);
  }
  late double distanceFromOptimalBase;
  late double distanceFromCenterBase;
  late double energyForOptimalBase;
  late double energyForCenterBase;
}
```

for graph drawing
```
class Graph extends StatefulWidget {
}
```

MAP SCREEN
```
class MapScreen {

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

    // THE BASE STATION THAT GIVES OPTIMAL ENERGY CONSUMPTION ATTENDED  AS OPTIMAL BASE STATION
    _base = sortedMap.entries.first.value;
    _optimalBase.X = _base.X;
    _optimalBase.Y = _base.Y;
    _optimalBase.energy = _base.energy;

    // CALCULATING ENERGY AND DISTANCE VALUES FOR CENTER BASE STATION
    
    for(int i =0; i< listOfDevice.length ; i++) {
      listOfDevice[i].distanceFromCenterBase = calculateDistanceFromCenterBase(listOfDevice[i],centerBase);
      listOfDevice[i].energyForCenterBase = calculateEnergyForCenterBase(listOfDevice[i], centerBase, order);

      listOfDevice[i].distanceFromOptimalBase = calculateDistanceFromOptimalBase(listOfDevice[i], _optimalBase);
      listOfDevice[i].energyForOptimalBase = calculateEnergyForOptimalBase(listOfDevice[i], _optimalBase, order);

      energyConsumptionForPoint += listOfDevice[i].energyForCenterBase;
    }
    centerBase.energy = energyConsumptionForPoint;
 }
```

THE OPTIMAL BASE STATION, WILL BE CALCULATED AFTER THE DEVICES DISTRIBUTED TO THE AREA
```
class OptimalBase{
  late int Y;
  late int X;
  double energy = 0;
}
```

USED FUNCTIONS

```
// BASE LOCATION AREA METRICS
var WIDTH = 500;
var HEIGHT = 500;

// "order" VALUE REQUIRED FOR CALCULATING ENERGY-DISTANCE RELATION
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
```



## 
