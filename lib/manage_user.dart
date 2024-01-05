import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:test1/home_screen.dart';
import 'package:test1/model/user_mode.dart';
import 'package:test1/profiles.dart';

class ManageUser extends StatelessWidget {

 
  final UserModel userModel;

  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();

    FirebaseStorage storageRef = FirebaseStorage.instance;
    final CollectionReference _reference = FirebaseFirestore.instance.collection('eBook');

    ManageUser({super.key, required this.userModel});

  @override
  Widget build(BuildContext context){

    firstNameEditingController.text = userModel.firstName!;
    secondNameEditingController.text = userModel.secondName!;
    emailEditingController.text = userModel.email!;
    passwordEditingController.text = userModel.uid!;
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text("Edit", style: Theme.of(context).textTheme.headline4),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100), child: const Image(image: AssetImage("assets/Picture1.png"))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.amber),
                      child: const Icon(
                        LineAwesomeIcons.camera,
                        color: Colors.black,
                        size: 20.0,
                      ),
                    )
                  )
                ],
              ),

              const SizedBox(height: 50),

              Form(child: Column(
                children: [
                  TextFormField(
                    controller: firstNameEditingController,
                    enabled: false,
                    decoration: 
                    const InputDecoration(label: Text("First Name"), prefixIcon: Icon(LineAwesomeIcons.user)),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: secondNameEditingController,
                    enabled: false,
                    decoration: 
                    const InputDecoration(label: Text("Second Name"), prefixIcon: Icon(LineAwesomeIcons.user)),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailEditingController,
                    enabled: false,
                    decoration: 
                    const InputDecoration(label: Text("Email"), prefixIcon: Icon(LineAwesomeIcons.envelope_1)),
                  ),
                  const SizedBox(height: 20),
                  // TextFormField(
                  //   controller: passwordEditingController,
                  //   decoration: 
                  //   const InputDecoration(label: Text("Password"), prefixIcon: Icon(Icons.fingerprint)),
                  // ),
                  // const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                    // _updateProfile();
                        Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ));},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, side: BorderSide.none, shape: const StadiumBorder()),
                      child: const Text("Delete Profile", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  
                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text.rich(
                        TextSpan(
                          text: "Joined on",
                          style: TextStyle(fontSize: 12),
                          children: [
                            TextSpan(text: "Joined at", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                          ]
                        )
                      ),
                      ElevatedButton(
                        onPressed: () {}, 
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.1),
                        elevation: 0,
                        foregroundColor: Colors.red,
                          shape: const StadiumBorder(),
                          side: BorderSide.none
                      ),
                        child: const Text("Delete"))
                    ],
                  )
                ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  // _updateProfile() async{
    
  //   UserModel updateProfile = UserModel(
  //     uid: userModel.uid,
  //     firstName: firstNameEditingController.text,
  //     secondName: secondNameEditingController.text,
  //     email: emailEditingController.text,
  //   );

  //   final collectionReference = FirebaseFirestore.instance.collection('users');
  //   collectionReference.doc(updateProfile.uid).update(updateProfile.toJson());
  // }
}