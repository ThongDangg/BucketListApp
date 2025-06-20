import 'package:bucketlist/addBucketList.dart';
import 'package:bucketlist/viewItem.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> bucketListData = [];
  bool isLoading = false;
  bool isError = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    //phai nho cu phap cua toan bo
    //GET data trong API
    //de? tranh runtime error thi phai su dung try catch
    try {
      Response response = await Dio().get(
        "https://flutterapitest1-505cb-default-rtdb.firebaseio.com/bucketlist.json",
      ); //phải có await đặt trước hành động mình sắp làm, //thay vì sử dụng var thì sử dụng response để store trong dio package
      //khuc nay quan trong
      bucketListData = response.data;
      isLoading = false;
      isError = false;
      setState(() {});
    } catch (e) //e nghia la exception
    {
      isError = true;
      isLoading = false;
      setState(() {});
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: Text(
      //         "Cannot connect to the server ! Try after few seconds ",
      //       ),
      //     );
      //   },
      // );
    }
  }

  Widget errorWidget({required texterror}) {
    //that's how create a custom widget inside of a dart file without add new file
    //required de? mua' callback function thoai =)))
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning),
          Text("$texterror"),
          ElevatedButton(onPressed: getData, child: Text("Try again")),
        ],
      ),
    );
  }

  Widget ListDataWidget() {
    return ListView.builder(
      //cu phap phai nho
      itemCount: bucketListData.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ViewItemScreen(
                      title: bucketListData[index]['item'] ?? "",
                      image: bucketListData[index]['image'] ?? "",
                    );
                  },
                ),
              );
            },
            leading: CircleAvatar(
              radius: 25, //với circleavatar thì radius để chỉnh độ bự của hình
              backgroundImage: NetworkImage(
                bucketListData[index]['image'] ?? "",
              ),
            ),
            title: Text(bucketListData[index]['item'] ?? ""),
            trailing: Text(
              bucketListData[index]['cost'].toString() ?? "",
              style: TextStyle(fontSize: 15),
            ), //vì cost mình khai báo trong api kiểu dữ liệu là interger nên muốn thành text phải ép kiểu nó
          ),
        ); //buộc phải có ?? "" để cho get api có sai cũng trả về null
      },
    );
  }

  @override
  void initState() {
    // nơi để khởi tạo 1 lần mặc định cho app
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddBucketListScreen(); //cách này đc sử dụng recommend sử dụng nhiều hơn
              },
            ),
          );
        },
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Bucket list"),

        actions: [
          InkWell(
            onTap: getData,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: Expanded(
        // thuong` thi phai goi list view bang expanded de tranh loi layout
        child: RefreshIndicator(
          //bọc listview bằng cái này để có thể refresh list cho data mới vào
          onRefresh: () async {
            getData();
          },
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : isError
              ? errorWidget(texterror: "con cawjc")
              : ListDataWidget(),
        ),
      ),
    );
  }
}
