import 'dart:io';
import 'package:provider/provider.dart';
import 'package:tttttt/models/event.dart';
import 'package:tttttt/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tttttt/providers/event_provider.dart';
import 'package:tttttt/providers/notification_provider.dart';
import 'package:tttttt/providers/user_provider.dart';

class WritingPage extends StatefulWidget {
  final id;
  const WritingPage({super.key, required this.id});

  @override
  State<WritingPage> createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final UserProvider userProvider = UserProvider();

  String selectedValue = '공지';
  String? imageUrl;
  List<String> dropdownItems = ['공지', '행사'];
  XFile? _pickedImage;

  @override
  Widget build(BuildContext context) {
    var _noti = Noti(
      title: '',
      content: '',
      clubId: widget.id,
      userId: userProvider.currentUser!.uid,
    );

    var _event = Event(
      title: '',
      content: '',
      clubId: widget.id,
      userId: userProvider.currentUser!.uid,
      imageUrl: '',
      dateTime: DateTime.now()
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close)),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedValue,
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      items: dropdownItems.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        _formKey.currentState!.save();

                        if (selectedValue == '공지') {
                          await Provider.of<NotificationProvider>(context,
                                  listen: false)
                              .upload(_noti);
                          Navigator.pop(context);
                        }

                        if (selectedValue == '행사') {
                          if (_pickedImage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("이미지를 선택하세요."),
                              ),
                            );
                          } else {
                            Navigator.pop(context);
                            await Provider.of<EventProvider>(context, listen: false)
                                .upload(_event, _pickedImage!);
                            
                          }
                        }
                      },
                      icon: const Icon(Icons.check)),
                ],
              ),
              const Divider(
                thickness: 1,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        onSaved: (value) {
                          if (selectedValue == '공지') {
                            _noti.title = value;
                          }
                          if (selectedValue == '행사') {
                            _event.title = value;
                          }
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 12,
                          ),
                          hintText: '제목',
                          hintStyle: TextStyle(fontSize: 20.0),
                          border: InputBorder.none,
                        )),
                    const Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: TextFormField(
                        maxLines: null,
                        onSaved: (value) {
                          if (selectedValue == '공지') {
                            _noti.content = value;
                          }
                          if (selectedValue == '행사') {
                            _event.content = value;
                          }
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(
                            12,
                          ),
                          hintText: '내용을 입력하세요',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // image picker ----------------------------------------------
              if (selectedValue == '행사')
                Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        thickness: 1,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                pickImage();
                              },
                              child: Text("사진 선택")),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _pickedImage = null;
                                });
                              },
                              child: Text("선택 취소")),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // 선택한 image 나타내기
                      _pickedImage == null
                          ? Container()
                          : Image.file(
                              File(_pickedImage!.path),
                            )
                    ],
                  ),
                ), //
            ],
          ),
        ),
      ),
    );
  }

  //이미지 선택
  void pickImage() async {
    await Permission.photosAddOnly.request();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) // 취소버튼 누르면 이미지 없어지길래 추가함
      setState(() {
        _pickedImage = image; //provider로 하기!!
      });
  }

//   // 행사 or 공지 글 업로드
//   void upload() async {
//     Get.back();
//     _formKey.currentState!.save();
//     if(_pickedImage != null)
//     {File file = File(_pickedImage!.path);
//  // firestorage에 올리고
//       await FirebaseStorage.instance
//           .ref('clubs/${club['category']}/${club['name']}/events/$title.jpg')
//           .putFile(file);
// // downloadUrl을 얻은다음에
//       imageUrl = await FirebaseStorage.instance
//           .ref('clubs/${club['category']}/${club['name']}/events/$title.jpg')
//           .getDownloadURL();}

//     // 파이어스토어에 업로드
//     await FirebaseFirestore.instance
//         .doc(club['path'])
//         .collection(selectedValue == '공지' ? 'notifications' : 'events')
//         .add({
//       'title': title,
//       'content': content,
//       'time': Timestamp.now(),
//       if(_pickedImage != null) // 선택한 이미지가 있을 경우에만 img필드추가
//       'imgUrl' : imageUrl,
//     });
//   }
}
