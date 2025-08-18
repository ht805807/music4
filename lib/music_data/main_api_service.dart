import 'package:http/http.dart' as http;
import 'package:music4/music_data/data.dart';

class MainApiService {

  static void AddName() async {
    const String url = "http://caryapp.nuxmax.com/game/AddNameData_Music4.php";
    Map<String, String> postData = {
      'name': Data.mName
    };
    await http.post(
      Uri.parse(url),
      body: postData,
    );
  }

  static void UpDaya() async {
    const String url = "http://caryapp.nuxmax.com/game/register_Music4.php";
    Map<String, String> postData = {
    'name': Data.mName,
    'fraction': (Data.mCurrentIndex+1).toString(),
    'country': Data.TOTAL_COINS.toString()
    };
    await http.post(
      Uri.parse(url),
      body: postData,
    );
  }
}