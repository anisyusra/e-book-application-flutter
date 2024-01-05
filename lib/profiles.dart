import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:test1/list_user.dart';
import 'package:test1/model/user_mode.dart';
import 'package:test1/update_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen>{

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromJson(value.data()!);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context){
    final CollectionReference _reference = FirebaseFirestore.instance.collection('users');

    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var iconColor = isDark ? Colors.yellow : Colors.red;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text('Hi', style: Theme.of(context).textTheme.headline4),
        actions: [
          IconButton(onPressed: () {Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const UserList()));}, icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        ],),

        body: FutureBuilder<QuerySnapshot>(
          future: _reference.get(),
          builder: (context, snapshot) {
            // Check for error
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }

            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data!;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              // Convert data to List
              List<UserModel> usermodels = documents
                  .map((e) => UserModel(
                      uid: e['uid'],
                      email: e['email'],
                      firstName: e['firstName'],
                      secondName: e['secondName'],))
                  .toList();
              return _getProfile(usermodels);
            } else {
              // Show Loading
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
          },
        ),
      );
  }

  Widget _getProfile(usermodels) {
    return usermodels.isEmpty
        ? const Center(
          child: Text(
            'Please Register',
            textAlign: TextAlign.center,
          ),
        )
        :ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
      UserModel user = usermodels.firstWhere((user) => user.uid == "${loggedInUser.uid}");
      return Card(
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
                      borderRadius: BorderRadius.circular(100), child: const Image(image: AssetImage("assets/Picture1.png"))
                    ),),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.black,),
                  child: const Icon(LineAwesomeIcons.alternate_pencil, size: 20.0, color: Colors.black)),
                    )
                ],
              ),
                const SizedBox(height: 10),
                Text("${loggedInUser.firstName} ${loggedInUser.secondName}", style: Theme.of(context).textTheme.headline4),
                Text("${loggedInUser.email}", style: Theme.of(context).textTheme.bodyText2),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateProfileScreen(userModel: user),
                                ));},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff132137), side: BorderSide.none, shape: const StadiumBorder()
                    ),
                    child: const Text("EDIT PROFILE", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),

                ProfileMenuWidget(title: "Settings", icon: LineAwesomeIcons.cog, onPress: (){},),
                ProfileMenuWidget(
                  title: "Logout",
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {},
                ),
              ]
            )
          )
      ); } );
  }
}

class ProfileMenuWidget extends StatelessWidget{
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.yellow.withOpacity(0.1),
                    ),
                    child: Icon(icon, color: Colors.yellow),
                  ),
                  title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.apply(color: textColor)),
                  trailing: endIcon? Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  
                  child: const Icon(LineAwesomeIcons.angle_right, size: 18.0, color: Colors.grey)) : null 
                );
  }
}