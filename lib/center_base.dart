import 'package:veri_haberlesmesi/base.dart';
import 'package:veri_haberlesmesi/utils.dart';

class CenterBase extends Base{

  late int Y;
  late int X;

  CenterBase(){
    Y = (HEIGHT / 2) as int;
    X = (WIDTH / 2) as int;
  }

}