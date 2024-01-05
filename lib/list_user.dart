import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:test1/manage_user.dart';
import 'package:test1/model/user_mode.dart';
import 'package:test1/profiles.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserList createState() => _UserList();
}

class _UserList extends State<UserList> {

  String name = "";

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  

  @override 
Widget build(BuildContext context){
    final CollectionReference _reference = FirebaseFirestore.instance.collection('users');

    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var iconColor = isDark ? Colors.yellow : Colors.red;

    return Scaffold(
      appBar: AppBar(
            title: Card(
          child: TextField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        )),

 body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;

                      QuerySnapshot querySnapshot = snapshots.data!;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              // Convert data to List
              List<UserModel> usermodels = documents
                  .map((e) => UserModel(
                      uid: e['uid'],
                      email: e['email'],
                      firstName: e['firstName'],
                      secondName: e['secondName'],))
                  .toList();

                      if (name.isEmpty) {
                        return ElevatedButton(
                          onPressed: (){Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ManageUser(userModel: usermodels[index]),
                                ));},
                          child: ListTile(
                            title: Text(
                              data['email'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),

                            
                            // subtitle: Text(
                            //   data['email'],
                            //   maxLines: 1,
                            //   overflow: TextOverflow.ellipsis,
                            //   style: TextStyle(
                            //       color: Colors.black54,
                            //       fontSize: 16,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            // leading: CircleAvatar(
                            //   backgroundImage: NetworkImage(data['image']),
                            // ),


                           trailing: SizedBox(
                  width: 60,child: 
                    InkWell(
                      child: Icon(
                        Icons.delete,
                        color: Colors.black.withOpacity(0.75),
                      ),
                      onTap: () { 
                        _reference.doc(usermodels[index].uid).delete();
                            // To refresh
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserList(),
                                ));},
                    ),
                          ),
                          )
                        );
                      }
                      if (data['email']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return ListTile(
                          title: Text(
                            data['email'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          // subtitle: Text(
                          //   data['email'],
                          //   maxLines: 1,
                          //   overflow: TextOverflow.ellipsis,
                          //   style: TextStyle(
                          //       color: Colors.black54,
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          // leading: CircleAvatar(
                          //   backgroundImage: NetworkImage(data['image']),
                          // ),
                        );
                      }
                      return Container();
                    });
          },
        )    );
  }

  Widget _getUserList(usermodels) {
    return usermodels.isEmpty
        ? const Center(
          child: Text(
            'No Student Yet\nClick + to start adding',
            textAlign: TextAlign.center,
          ),
        )
        : ListView.builder(
          itemCount: usermodels.length,
          itemBuilder: ((context, index) {
            // UserModel user = usermodels.firstWhere((user) => user.uid == "${loggedInUser.uid}");
            return Card(
            color: Colors.grey,
            child: ElevatedButton(
              onPressed: () {
              },
              child: ListTile(
                title: Text(usermodels[index].email),
              ),
            )
          );})
          );
  }
}
