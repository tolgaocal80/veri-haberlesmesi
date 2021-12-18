import 'devices.dart';

class Singleton {

  static final Singleton _instance = Singleton._();

  // private constructor
  Singleton._();

  // static get instance method
  static Singleton get instance => _instance;

  factory Singleton() {
    return _instance;
  }

  List<Device> deviceListSingleton = [];

}