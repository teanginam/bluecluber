import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {

    final _formKey = GlobalKey<FormState>();
    String? name;
    String? information;
    String? introduction;
    String? tag;
    String? category;

    return Scaffold(
      appBar: AppBar(title: Text("Post Page")),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(children: [

              TextFormField(
                onSaved: ((value) {
                  name = value!;
                }),
                decoration: InputDecoration(
                  hintText: 'name'
                ),
              ),
              TextFormField(
                onSaved: ((value) {
                  information = value!;
                }),
                decoration: InputDecoration(
                  hintText: 'information'
                ),
              ),
              TextFormField(
                onSaved: ((value) {
                  introduction = value!;
                }),
                decoration: InputDecoration(
                  hintText: 'introduction'
                ),
              ),
              TextFormField(
                onSaved: ((value) {
                  tag = value!;
                }),
                decoration: InputDecoration(
                  hintText: 'tag'
                ),
              ),
              TextFormField(
                onSaved: ((value) {
                  category = value!;
                }),
                decoration: InputDecoration(
                  hintText: 'category'
                ),
              ),

            ]),
          ),
          ElevatedButton(
            onPressed: () {
              _formKey.currentState!.save();
              
              FirebaseFirestore.instance.collection('Club').doc().set(
                {
                  'name' : name,
                  'information' : information,
                  'introduction' : introduction,
                  'tag' : tag,
                  'category' : category,
                }
              );
              setState(() {
                
              });
            },
            child: Center(child: Text("완료")),
          )
        ],
        
      ),
      
    );
  }
}