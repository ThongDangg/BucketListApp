import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddBucketListScreen extends StatefulWidget {
  int newIndex;
  AddBucketListScreen({super.key, required this.newIndex});

  @override
  State<AddBucketListScreen> createState() => _AddBucketListScreenState();
}

class _AddBucketListScreenState extends State<AddBucketListScreen> { 
//Là một class trong Flutter giúp bạn kiểm soát và truy cập nội dung của một TextField hoặc TextFormField.
  TextEditingController itemText = TextEditingController();
  TextEditingController costText = TextEditingController();

  TextEditingController imageURLText = TextEditingController();

  Future<void> addData() async {
    //in the patch request we need to send a map object.

    try {
      Map<String, dynamic> data = {
        "completed": false,
        "cost": costText.text,
        "image":
            imageURLText.text,
        "item": itemText.text,
      };

      Response response = await Dio().patch(
        "https://flutterapitest1-505cb-default-rtdb.firebaseio.com/bucketlist/${widget.newIndex}.json",
        data: data,
      );
      Navigator.pop(context, "refresh");
    } catch (e) {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var addForm = GlobalKey<FormState> (); //tạo key cho form
    return Scaffold(
      appBar: AppBar(title: Text("Add bucket list")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: addForm,
          child: Column(
            children: [
              TextFormField( //lý do xài texformfield vì nó có an argument called validator used for validating the form.
                autovalidateMode: AutovalidateMode.onUserInteraction, //validate in realtime whenever user interact with form
                validator: (value){
                  if(value.toString().length < 3){
                    return "Must be more than 3 characters";
                  }
                  if(value == null || value.isEmpty){
                    return "This must not be empty";
                  }
                },
                controller: itemText,
                decoration: InputDecoration(label: Text("Item"))),
              SizedBox(height: 30),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.toString().length < 3) {
                    return "Must be more than 3 characters";
                  }
                  if (value == null || value.isEmpty) {
                    return "This must not be empty";
                  }
                },
                controller: costText,
                decoration: InputDecoration(label: Text("Estimated Cost")),
              ),
              SizedBox(height: 30),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.toString().length < 3) {
                    return "Must be more than 3 characters";
                  }
                  if (value == null || value.isEmpty) {
                    return "This must not be empty";
                  }
                },
                controller: imageURLText,
                decoration: InputDecoration(label: Text("Image URL"))),
              SizedBox(height: 30),
          
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        if(addForm.currentState!.validate()){ //if validation successful then this condition will return
                        addData();
                        print("Success");

                        }else{
                          print("Something wrong");
                        }
                      },
                      child: Text("Add Item"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
