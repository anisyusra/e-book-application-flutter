import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test1/home_page.dart';
import 'dart:io';


class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override 
  State<AddBook> createState() => _AddBook();
}

class _AddBook extends State<AddBook> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController yearController = TextEditingController(); 
  final TextEditingController linkController = TextEditingController();
  final TextEditingController pageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String imageName = "";
  XFile? imagePath;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  FirebaseStorage storageRef = FirebaseStorage.instance;
  String collectionName = "eBook";

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding (
          padding: const EdgeInsets.all(10.0),
          child: _isLoading ? const Center(child: CircularProgressIndicator(),) :
        Column(
          children: [

            //Upload image
            SizedBox(
              height: 230,
              child: imageName == "" ? Image.network('https://cdn.asaha.com/assets/img/nocover.jpg') : Image.file(File(imagePath!.path)),
            ),
            const SizedBox(
              height: 5,
            ),
            IconButton(
              icon: const Icon(Icons.camera),
              onPressed: () {
                imagePicker();
              }, 
            ),

            //Enter title
            const Padding(
              padding: EdgeInsets.only(right: 330),
              child: Text(
                textAlign: TextAlign.start,
                'Title',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Enter Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            //Enter Author
            const Padding(
              padding: EdgeInsets.only(right: 310),
              child: Text(
                textAlign: TextAlign.start,
                'Author',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: authorController,
              decoration: const InputDecoration(
                hintText: 'Author',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            //Enter Year
            const Padding(
              padding: EdgeInsets.only(right: 330),
              child: Text(
                textAlign: TextAlign.start,
                'Year',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: yearController,
              decoration: const InputDecoration(
                hintText: 'Year',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),

             const SizedBox(
              height: 30,
            ),

            //Enter Page
            const Padding(
              padding: EdgeInsets.only(right: 330),
              child: Text(
                textAlign: TextAlign.start,
                'Page',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: pageController,
              decoration: const InputDecoration(
                hintText: 'Enter Page',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            //Enter Link
            const Padding(
              padding: EdgeInsets.only(right: 330),
              child: Text(
                textAlign: TextAlign.start,
                'Link',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              keyboardType: TextInputType.url,
              controller: linkController,
              decoration: const InputDecoration(
                hintText: 'Enter link',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            //Enter Description
            const Padding(
              padding: EdgeInsets.only(right: 280),
              child: Text(
                textAlign: TextAlign.start,
                'Description',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: descriptionController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Enter Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 139, 96, 96)),
                  onPressed: () {
                    _uploadEbook();
                    Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ));
                  }, 
                  child: const Text('Add')
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                  onPressed: () {}, 
                  child: const Text('Reset')
                )
              ],
            ),

            const SizedBox(
              height: 30,
            ),

          ],
        )
      )
      ),
    );
  }

  _uploadEbook() async {
    setState(() {
      _isLoading = true;
    });

    var uniqueKey = firestoreRef.collection(collectionName).doc();
    String uploadFileName = 
        DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    Reference reference = 
        storageRef.ref().child(collectionName).child(uploadFileName);
    UploadTask uploadTask = reference.putFile(File(imagePath!.path));

    uploadTask.snapshotEvents.listen((event) {
      print(event.bytesTransferred.toString() + 
          "\t" + 
          event.totalBytes.toString());
    });

    await uploadTask.whenComplete(() async {
      var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();

      if(uploadPath.isNotEmpty) {
        firestoreRef.collection(collectionName).doc(uniqueKey.id).set({
        "id": uniqueKey.id,
        "title":titleController.text,
        "author":authorController.text,
        "page":pageController.text,
        "year":yearController.text,
        "link":linkController.text,
        "description":descriptionController.text,
        "image":uploadPath
      }).then((value) => _showMessage("Record Inserted."));
      } else {
        _showMessage("Somethimh While Uploading Image.");
      }
      setState(() {
        _isLoading = false;
        titleController.text = "";
        authorController.text = "";
        pageController.text = "";
        yearController.text = "";
        linkController.text = "";
        descriptionController.text = "";
        imageName = "";
      });
    });
    
  }

  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
      ));
  }

  imagePicker() async {
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    setState(() {
      imagePath = image;
      imageName = image.name.toString();
    });
  }
}
}