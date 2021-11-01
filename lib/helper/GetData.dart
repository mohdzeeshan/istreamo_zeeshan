// import 'dart:convert';
//
// import 'package:api_cache_manager/api_cache_manager.dart';
// import 'package:api_cache_manager/models/cache_db_model.dart';
// import 'package:data_connection_checker/data_connection_checker.dart';
// import 'package:istreamo_zeeshan/model/Data.dart';
// import 'package:http/http.dart' as http;
//
// class GetData{
//   List<JakesDataModel> fetchedApiData = [];
//
//   getData(int perpage) async {
//
//     String url = "https://api.github.com/users/JakeWharton/repos?page=$perpage&per_page=10";
//     bool result = await DataConnectionChecker().hasConnection;
//     if(result == true){
//       print("Live Data");
//       var response = await http.get(Uri.parse(url));
//       print(response.statusCode);
//       if (response.statusCode == 200) {
//
//         APICacheDBModel apiCacheDBModel =
//         APICacheDBModel(key: "data", syncData: response.body);
//         APICacheManager().addCacheData(apiCacheDBModel);
//         var jsonData = jsonDecode(response.body);
//
//         jsonData.forEach((element) {
//           if (element['language'] != null &&
//               element["name"] != null &&
//               element["owner"]["avatar_url"] != null &&
//               element["description"] != null &&
//               element["watchers_count"] != null &&
//               element["open_issues_count"] != null &&
//               element["html_url"] != null) {
//             // filters all null data fields
//
//             JakesDataModel characterModel = JakesDataModel.fromJson(element);
//             fetchedApiData.add(characterModel);
//
//           }
//         });
//
//       }
//       return fetchedApiData;
//
//     }
//     else{
//       List<JakesDataModel> cachedApiData = [];
//       print("local Storage");
//       var cacheData = await APICacheManager().getCacheData("data");
//       var jsonData  = jsonDecode(cacheData.syncData);
//
//       jsonData.forEach((element) {
//         if (element['language'] != null &&
//             element["name"] != null &&
//             element["owner"]["avatar_url"] != null &&
//             element["description"] != null &&
//             element["watchers_count"] != null &&
//             element["open_issues_count"] != null &&
//             element["html_url"] != null) {
//           // filters all null data fields
//
//           JakesDataModel characterModel = JakesDataModel.fromJson(element);
//           fetchedApiData.add(characterModel);
//         }
//
//       });
//
//
//     }
//
//   }
// }