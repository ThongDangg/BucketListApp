import 'package:bucketlist/screens/add_screen.dart';
import 'package:bucketlist/screens/view_screen.dart';
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

      if (response.data is List) {
        bucketListData = response.data;
      } else {
        bucketListData = [];
      }
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

    //cần fallback value ?? false vi ko chac co ton tai element de true va false hay khong
    List<dynamic> filteredList = bucketListData.where((element)=> (!element?["completed"]) ?? false).toList();

    return filteredList.length <1 ? Center(child: Text("No data on bucket list")) : ListView.builder(
      //cu phap phai nho
      itemCount: bucketListData.length,
      itemBuilder: (BuildContext context, int index) {
        return (bucketListData[index] is Map && (!bucketListData[index]?["completed"]) ?? false ) //nhớ kĩ dòng và hiểu dòng code này vì hơi phức tạp 
            ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ViewItemScreen(
                            index: index,
                            title: bucketListData[index]['item'] ?? "",
                            image: bucketListData[index]['image'] ?? "",
                          );
                        },
                      ),
                    ).then((value){ //tu load lai data khi back to listview screen
                      if(value == "refresh")
                      getData();
                    });
                  },
                  leading: CircleAvatar(
                    radius:
                        25, //với circleavatar thì radius để chỉnh độ bự của hình
                    backgroundImage: NetworkImage(
                      bucketListData[index]?['image'] ??
                          "", // 1 dau cham hoi nghia la we are instructing that that if this object is null, then directly move to the fallback value and don't take this key.
                    ),
                  ),
                  title: Text(bucketListData[index]?['item'] ?? ""),
                  trailing: Text(
                    bucketListData[index]?['cost'].toString() ?? "",
                    style: TextStyle(fontSize: 15),
                  ), //vì cost mình khai báo trong api kiểu dữ liệu là interger nên muốn thành text phải ép kiểu nó
                ),
            )
            : SizedBox(); //buộc phải có ?? "" để cho get api có sai cũng trả về null
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
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddBucketListScreen(newIndex: bucketListData.length,); //cách này đc sử dụng recommend sử dụng nhiều hơn
              },
            ),
          ).then((value){
            if(value == "refresh"){
              getData();
            }
          });
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
          //refresh indicator will not work if the list is empty
          //bọc listview bằng cái này để có thể refresh list cho data mới vào
          onRefresh: () async {
            getData();
          },
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : isError
              ? errorWidget(texterror: "con cawjc")
              :  ListDataWidget(),
        ),
      ),
    );
  }
}
