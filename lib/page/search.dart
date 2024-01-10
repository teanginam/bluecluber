import 'package:flutter/material.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: 90,
                      child: Text(
                        "검색",
                        style: TextStyle(fontSize: 20),
                      )),
                  // SizedBox(
                  //   width: 70,
                  //   child: TextButton(
                  //       onPressed: () {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => const listv()));
                  //       },
                  //       child: const Text("전체보기")),
                  // )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.all(24),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(25)),
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Icon(
                        Icons.search,
                        size: 40,
                      ),
                    ),
                    // TextField(
                    //   decoration: InputDecoration(labelText: "동아리 검색"),
                    // )
                  ],
                ),
              ),
            ),
            const Text("data"),
//             TextButton(
//               onPressed:() {
//                 Firestore.instance.collection("you_Collection_Path").add({
//   "key":value //your data which will be added to the collection and collection will be created after this
// }).then((_){
//   print("collection created");
// }).catchError((_){
//   print("an error occured");
// });
//               }, , child: const Text("ddd"))
          ],
        ),
      ),
    );
  }
}
