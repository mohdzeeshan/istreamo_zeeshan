import 'package:hive/hive.dart';
import 'package:istreamo_zeeshan/model/Data.dart';

Future cacheToLocalDB(List<JakesDataModel> JakesData) async {
  await Hive.openBox('cachedData');
  Box box = Hive.box('cachedData');
    box.put("data" ,JakesData);
    print("No of objects in hive${box.values}");
}

Future fetchedDataFromLocalDB() async {
  List cachedData;
  await Hive.openBox('cachedData');
  Box box = Hive.box('cachedData');
  cachedData = box.get("data");
  print(cachedData);
  return cachedData;

}
Future clearCachedData() async
{
  await Hive.openBox('cachedData');
  Box box = Hive.box('cachedData');
  await box.clear();
}