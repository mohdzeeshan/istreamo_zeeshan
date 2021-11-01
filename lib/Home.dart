import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:istreamo_zeeshan/helper/hive_helper.dart';
import 'package:istreamo_zeeshan/views/DateTile.dart';
import 'helper/local_auth.dart';
import 'model/Data.dart';
import 'package:permission_handler/permission_handler.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<JakesDataModel> fetchedData = [];
  List cachedData = [];
  int pageNumber = 1;
  bool _loading = true;
  ScrollController _scrollController;
  bool isConnected;

  askPermissions ()async{
    var storagePermission = await Permission.storage.status;
    var sensorPermission = await Permission.sensors.status;
    if(!storagePermission.isGranted){
      await  Permission.storage.request();
    }
    if(!sensorPermission.isGranted){
      await  Permission.sensors.request();
    }

  }

  getData(int perpage) async {
    String url = "https://api.github.com/users/JakeWharton/repos?page=$perpage&per_page=8";
    print(perpage);
      print("Live Data");
      var response = await http.get(Uri.parse(url));
      print(response.statusCode);
      if (response.statusCode == 200) {
        clearCachedData();
       var jsonData = jsonDecode(response.body);
        jsonData.forEach((element) {
          if (element['language'] != null &&
              element["name"] != null &&
              element["owner"]["avatar_url"] != null &&
              element["description"] != null &&
              element["watchers_count"] != null &&
              element["open_issues_count"] != null &&
              element["html_url"] != null) {
              // filters all null data fields

            JakesDataModel jakesData = JakesDataModel.fromJson(element);
            fetchedData.add(jakesData);
            try{
              cacheToLocalDB(fetchedData);
            }
            catch(e){
              print(e);
            }

          }
        });

        setState(() {
          _loading = false;
          pageNumber++;

        });
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Requesting New Data. Please Try Again')));
      }
  }

  getCachedDataFromLocalDB()async{
    print("local Storage");
    cachedData = await fetchedDataFromLocalDB();

    setState(() {
      _loading = false;
    });

  }

  checkConnectionAndCallMethod()async{
    await DataConnectionChecker().hasConnection.then((value) {

        print("Connection from then: $value");
        isConnected = value;
        if(isConnected == true)
          {
            getData(pageNumber);
          }
        else{
          getCachedDataFromLocalDB();
        }
      });
  }

  @override
  void initState()  {

    super.initState();

    fingerPrintAuth();
    checkConnectionAndCallMethod();

      _scrollController = ScrollController();
      _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    fetchedData.clear();
    Hive.close();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jake's Git"),
      ),
      body: _loading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Column(
                  children: <Widget>[
                    ListView.separated(
                      itemCount:  isConnected ? fetchedData.length : cachedData.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {

                        if(isConnected == true && index == fetchedData.length-1)
                          return Container(
                            color: Colors.transparent,
                            height: 40,
                              width: 40,
                              child: SizedBox(child: Center(child: CircularProgressIndicator())));

                          else
                        return  DataTile(isConnected ? fetchedData[index] : cachedData[index]);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          thickness: 1,
                          color: Colors.black,
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
  fingerPrintAuth() async {
    await LocalAuthApi.hasBiometrics().then((value) async{
      if(value){
        final isAuthenticated = await LocalAuthApi.authenticate();
        print(isAuthenticated);
        if (!isAuthenticated) {
          fingerPrintAuth();
        }
      }
      else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Your Title"),
            content: const Text(
            "FingerPrint Not Supported"),
            actions: [
              new ElevatedButton(
                child: const Text("Ok"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
    },
        );
      }
    });

  }

  _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent *0.75) {
      print("List Scrolled");
      getData(pageNumber);
    }
  }
}
