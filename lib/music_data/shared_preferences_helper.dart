import 'package:shared_preferences/shared_preferences.dart';
import 'data.dart';
import 'main_api_service.dart';

class SharedPreferencesHelper{

  static void SetName(String Name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Name',Name);
    Data.mName = Name;
    prefs.setInt('GameLevel', Data.mCurrentIndex);
    prefs.setInt('GameCoins', Data.TOTAL_COINS);
    MainApiService.AddName();
  }

  static void GetName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Data.mName = prefs.getString('Name')??"";
  }
  static void SetGame() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('GameLevel', Data.mCurrentIndex);
    prefs.setInt('GameCoins', Data.TOTAL_COINS);
    Data.mName = prefs.getString('Name')??"";
    MainApiService.UpDaya();
  }

  static void SetMo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('mo', true);
    MainApiService.UpDaya();
  }







}