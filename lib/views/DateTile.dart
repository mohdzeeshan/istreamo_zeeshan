import 'package:flutter/material.dart';
import 'package:istreamo_zeeshan/helper/local_auth.dart';
import 'package:istreamo_zeeshan/model/Data.dart';
import 'package:istreamo_zeeshan/views/GitView.dart';
import 'package:webview_flutter/webview_flutter.dart';
class DataTile extends StatefulWidget {
  JakesDataModel jakesData;
  DataTile(@required this.jakesData);

  @override
  _DataTileState createState() => _DataTileState();
}

class _DataTileState extends State<DataTile> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print("tapped");
        Navigator.push(context, MaterialPageRoute(builder: (context) => GitView(gitUrl: widget.jakesData.url,)));
      },
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Image.network(widget.jakesData.image),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.jakesData.name,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  maxLines: 2,
                ),
                Text(
                  widget.jakesData.description,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  maxLines: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton.icon(
                        onPressed: null,
                        icon: Icon(Icons.code),
                        label: Text(widget.jakesData.language)),

                    TextButton.icon(
                        onPressed: null,
                        icon: Icon(Icons.bug_report),
                        label:
                        Text(widget.jakesData.openIssuesCount.toString())),
                    TextButton.icon(
                        onPressed: null,
                        icon: Icon(Icons.face),
                        label: Text(widget.jakesData.watchers_count.toString())),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}