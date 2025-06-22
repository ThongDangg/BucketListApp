import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ViewItemScreen extends StatefulWidget {
  String title;
  String image;
  int index;
  ViewItemScreen({
    super.key,
    required this.title,
    required this.image,
    required this.index,
  });

  @override
  State<ViewItemScreen> createState() => _ViewItemScreenState();
}

class _ViewItemScreenState extends State<ViewItemScreen> {
  Future<void> deleteData() async {
    Navigator.pop(context);
    try {
      Response response = await Dio().delete(
        "https://flutterapitest1-505cb-default-rtdb.firebaseio.com/bucketlist/${widget.index}.json",
      );
      Navigator.pop(context, "refresh");
    } catch (e) {
      print("Error");
    }
  }

  Future<void> markAsComplete() async {
    //in the patch request we need to send a map object.

    try {
      Map<String, dynamic> data = {"completed": true};

      Response response = await Dio().patch(
        "https://flutterapitest1-505cb-default-rtdb.firebaseio.com/bucketlist/${widget.index}.json",
        data: data,
      );
      Navigator.pop(context, "refresh");
    } catch (e) {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 1) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Are you sure want to delete "),
                      actions: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                        InkWell(onTap: deleteData, child: Text("Confirm")),
                      ],
                    );
                  },
                );
              }
              if (value == 2) {
                markAsComplete();
              }

              print(value);
            },
            itemBuilder: (context) {
              //no expect cai popupmenuitem nene phai chieu no

              return [
                PopupMenuItem(value: 1, child: Text("Delete")),
                PopupMenuItem(value: 2, child: Text("Mark as complete")),
              ];
            },
          ),
        ],
        title: Text("${widget.title}"),
      ),
      body: Column(
        
        children: [
          Text(widget.index.toString()),
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.image),
              ),
            ),
          ),
        ],
      ), //cách thêm ảnh thường dùng
    );
  }
}
