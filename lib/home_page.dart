import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test1/add_book.dart';
import 'package:flutter/material.dart';
import 'package:test1/book_categories.dart';
import 'package:test1/ebook.dart';
import 'package:test1/fitness_app/bottom_navigation_view/bottom_bar_view.dart';
import 'package:test1/fitness_app/fitness_app_theme.dart';
import 'package:test1/fitness_app/my_diary/my_diary_screen.dart';
import 'package:test1/fitness_app/training/training_screen.dart';
import 'package:test1/model/user_mode.dart';
import 'package:test1/models/data.dart';
import 'package:test1/new/detailsPage.dart';
import 'package:test1/update_book.dart';

import 'fitness_app/models/tabIcon_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  final CollectionReference _reference = FirebaseFirestore.instance.collection('eBook');

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

   AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = MyDiaryScreen(animationController: animationController);
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
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  final List ebookType = [
    [
      'Fiction',
      true,
    ],
    // [
    //   'Non-Fiction',
    //   false,
    // ],
    [
      'History',
      false,
    ],
    [
      'Romance',
      false,
    ],
    [
      'Popular',
      false,
    ],
  ];

  void ebookTypeSelected(int index) {
    setState(() {
      for (int i = 0; i < ebookType.length; i++) {
        ebookType[i][1] = false;
      }
      ebookType[index][1] = true;
    }
    );
  }

  @override 
 Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Firebase CRUD'),
        //   centerTitle: true,
        // ),
        body: FutureBuilder<QuerySnapshot>(
          future: _reference.get(),
          builder: (context, snapshot) {
            // Check for error
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            // if data received
            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data!;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              // Convert data to List
              List<Ebook> ebooks = documents
                  .map((e) => Ebook(
                      id: e['id'],
                      title: e['title'],
                      author: e['author'],
                      description: e['description'],
                      image: e['image'],
                      year: e['year'],
                      page: e['page'],
                      link: e['link'],))
                  .toList();
                  _getBook(ebooks);
                  return Stack(
                children: <Widget>[
                  _getBody(ebooks),
                  bottomBar(),
                ],
              );
            } else {
              // Show Loading
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: (() {
        //     //
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const AddBook(),
        //         ));
        //     //
        //   }),
        //   child: const Icon(Icons.add),
        // ),
        
        );
  }


  Widget _getBook(ebooks) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const Icon(Icons.menu),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 25.0),
            child: Icon(Icons.person),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "Find the best ebook for you",
                  style: GoogleFonts.bebasNeue(
                    fontSize: 56,
                  ),
                ),
              ),
        
              const SizedBox(height: 25),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Find your ebook..',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600),
                    )
                  ),
                ),
              ),
        
              const SizedBox(height: 25,),
        
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ebookType.length,
                  itemBuilder: (context, index) {
                    return EbookCate(
                      ebookCate: ebookType[index][0], 
                      isSelected: ebookType[index][1], 
                      onTap: () {
                        ebookTypeSelected(index);
                      },);
              }),
              ),
        
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ebooks.length,
                  itemBuilder: (context, index) {
                  return  Padding(
                      padding: const EdgeInsets.only(left: 25.0, bottom: 25),
                      child: Container(
                        width: 100,
                        decoration: const BoxDecoration(
                          // borderRadius: BorderRadius.circular(20),
                          color: Colors.transparent,
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(0, 255, 0, 0),
                            side: const BorderSide(color: Colors.transparent, width: 0),
                            minimumSize: const Size(0, 0),
                          ),
                          onPressed: (() {
                            Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const AddBook()));
                          }),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
        
                          ClipRRect(
                            // borderRadius: BorderRadius.circular(20),
                            child: Container(
                              alignment: Alignment.topCenter,
                              constraints: const BoxConstraints(
                                maxHeight: 130,
                                // minHeight: 0
                              ),
                              child: Image.network(ebooks[index].image)
                            ),
                          ),
        
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ebooks[index].title.length > 15
                                                      ? ebooks[index].title.substring(0, 10) + '...' :
                                                      ebooks[index].title,
                                  style: const TextStyle(fontSize: 15, color: Color.fromARGB(255, 0, 0, 0))
                                ),
                                // Text(
                                //   ebooks[index].author,
                                //   style: TextStyle(color: Colors.grey[700]),
                                // ),
                              ],
                            ),
                          ),
        
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                          child: Icon(
                            Icons.edit,
                            color: const Color.fromARGB(255, 255, 0, 0).withOpacity(0.75),
                          ),
                          onTap: () { Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateBook(ebook: ebooks[index]),
                                    ));},
                        ),
                        InkWell(
                          child: Icon(Icons.delete,                         
                          color: const Color.fromARGB(255, 255, 0, 0).withOpacity(0.75),),
                          onTap: () {
                             _reference.doc(ebooks[index].id).delete();
                                // To refresh
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ));
                          },
                        )
                            ],
                          )
                        ],
                        ),)
                      ),
                    );
                }
                )
              ),
        
              const SizedBox()
            ],
          ),
      ),
    );
  }

  int indx = 0;

  Widget _getBody(ebooks) {
     var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                // color: Colors.amberAccent,
                width: double.infinity,
                height: size.height * 0.091,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: constraints.maxHeight * 0.9,
                          width: constraints.maxWidth * 0.20,
                          color: Color.fromARGB(255, 255, 255, 255),
                          child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Icon(
                                Icons.menu,
                                size: 35,
                                color: Color.fromRGBO(44, 44, 44, 1),
                              )),
                        ),
                        SizedBox(
                          width: constraints.maxWidth * 0.35,
                        ),
                        Container(
                          height: constraints.maxHeight * 0.8,
                          width: constraints.maxWidth * 0.3,
                          color: Color.fromARGB(255, 255, 255, 255),
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Hello ${loggedInUser.firstName}",
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 19,
                                  color: Color.fromRGBO(44, 44, 44, 1),
                                )),
                              )),
                        ),
                        Container(
                          height: constraints.maxHeight * 0.6,
                          width: constraints.maxHeight * 0.6,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(
                                  constraints.maxHeight * 0.3),
                              image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/design_course/userImage.png'))),
                        )
                      ],
                    );
                  },
                ),
              ),
              Container(
                height: size.height * 0.06,
                width: double.infinity,
                // color: Colors.purple,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.02),
                          height: constraints.maxHeight * 0.7,
                          // color: Color.fromARGB(255, 250, 9, 9),
                          child: Center(
                            child: Text(
                              // " “An equation for me has no meaning, unless it expresses a thought of God.”",
                              "FIND YOUR BOOK",
                              textAlign: TextAlign.center,
                              // maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                                      fontSize: 20)),
                            ),
                          ),
                        ),
                        // Container(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: constraints.maxWidth * 0.02),
                        //   height: constraints.maxHeight * 0.3,
                        //   color: Colors.white,
                        //   child: Center(
                        //     child: Text(
                        //       // "― Srinivasa Ramanujan",
                        //       textAlign: TextAlign.center,
                        //       maxLines: 4,
                        //       overflow: TextOverflow.fade,
                        //       style: GoogleFonts.lato(
                        //           textStyle: const TextStyle(
                        //               fontWeight: FontWeight.w300,
                        //               fontSize: 17)),
                        //     ),
                        //   ),
                        // )
                      ],
                    );
                  },
                ),
              ),
              Container(
                // color: Colors.green,
                height: size.height * 0.0001,
              ),
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(size.height * 0.05),
                child: Container(
                    width: size.width * 0.9,
                    height: size.height * 0.07,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius:
                            BorderRadius.circular(size.height * 0.05)),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              //color: Colors.white,
                              height: constraints.maxHeight * 0.9,
                              width: constraints.maxWidth * 0.2,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Icon(
                                  Icons.search,
                                  size: 30,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ),
                            ),
                            SizedBox(
                                //color: Colors.red,
                                width: constraints.maxWidth * 0.6,
                                height: constraints.maxHeight,
                                child: TextField(
                                  decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      filled: false,
                                      hintText: "Search by Title,Author,Genre",
                                      hintStyle: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black
                                                  .withOpacity(0.4)))),
                                  cursorColor: Colors.black45,
                                  onChanged: (stringSearch) {},
                                )),
                            SizedBox(
                              // color: Colors.white,
                              height: constraints.maxHeight * 0.9,
                              width: constraints.maxWidth * 0.192,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Icon(
                                  Icons.filter_list,
                                  size: 30,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    )),
              ),
              SizedBox(
                height: size.height * 0.006,
              ),
              SizedBox(
                height: size.height *
                    (1 +
                        (-0.07 -
                            0.005 -
                            0.1 -
                            0.091 -
                            0.042)), //color: Colors.red,

                child: ListView(
                  children: [
                    SizedBox(
                      //color: Colors.red,
                      height: size.height * 0.35,
                      width: double.infinity,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            children: [
                              Container(
                                  // color: Colors.purple,
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight * 0.15,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: constraints.maxWidth * 0.03),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            color: Color.fromARGB(255, 255, 255, 255),
                                            height: constraints.maxHeight,
                                            width: constraints.maxWidth * 0.5,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "Special For You",
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black
                                                            .withOpacity(0.85),
                                                        fontSize: 25)),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            color: Color.fromARGB(255, 255, 255, 255),
                                            height: constraints.maxHeight,
                                            width: constraints.maxWidth * 0.2,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "view all",
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        fontSize: 15)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  )),
                              SizedBox(
                                  //color: Colors.green,
                                  height: constraints.maxHeight * 0.85,
                                  width: constraints.maxWidth,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: ebooks.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailsPage(
                                                      authorname:
                                                          ebooks[index]
                                                              .author,
                                                      bookname:
                                                          ebooks[index]
                                                              .title,
                                                      year:
                                                          ebooks[index]
                                                              .year,
                                                      imageAddress:
                                                          ebooks[index]
                                                              .image,
                                                      pages: 
                                                          ebooks[index]
                                                              .page,
                                                      link:
                                                          ebooks[index].link
                                                    ),
                                                  ),
                                                ),
                                                child: Hero(
                                                  tag: const Text("Haha"),
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal:
                                                            constraints.maxWidth *
                                                                0.025),
                                                    width: constraints.maxWidth *
                                                        0.34,
                                                    height:
                                                        constraints.maxHeight *
                                                            0.84,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromARGB(255, 255, 255, 255),
                                                        borderRadius: BorderRadius
                                                            .circular(constraints
                                                                    .maxHeight *
                                                                0.081),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                                ebooks[index]
                                                                    .image)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              blurRadius: 3,
                                                              spreadRadius: 2,
                                                              offset:
                                                                  const Offset(4, 1),
                                                              color: Colors.black
                                                                  .withOpacity(
                                                                      0.1))
                                                        ]),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: constraints.maxHeight *
                                                    0.01,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: constraints.maxWidth *
                                                        0.05),
                                                height: constraints.maxHeight *
                                                    0.07,
                                                width:
                                                    constraints.maxWidth * 0.39,
                                                //color: Colors.red,
                                                child: FittedBox(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      ebooks[index].title.length > 15
                                                      ? ebooks[index].title.substring(0, 10) + '...' :
                                                      ebooks[index].title,
                                                      style: GoogleFonts.lato(
                                                          color: const Color.fromRGBO(66, 66, 86, 1),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ))
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      //color: Colors.red,
                      height: size.height * 0.45,
                      width: double.infinity,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            children: [
                              Container(
                                  // color: Colors.purple,
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight * 0.1,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: constraints.maxWidth * 0.03),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            color: Color.fromARGB(255, 255, 255, 255),
                                            height: constraints.maxHeight,
                                            width: constraints.maxWidth * 0.5,
                                            child: FittedBox(
                                              alignment: Alignment.topLeft,
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "Popular",
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black
                                                            .withOpacity(0.85),
                                                        fontSize: 23)),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            color: Color.fromARGB(255, 255, 255, 255),
                                            height: constraints.maxHeight,
                                            width: constraints.maxWidth * 0.2,
                                            child: FittedBox(
                                              alignment: Alignment.centerRight,
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "view all",
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        fontSize: 15)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  )),
                              Container(
                                // color: Colors.red,
                                width: constraints.maxWidth,
                                height: constraints.maxHeight * 0.08,
                                padding: EdgeInsets.symmetric(
                                    horizontal: constraints.maxWidth * 0.03),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              indx = 0;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    constraints.maxHeight *
                                                        0.33),
                                            height: constraints.maxHeight * 0.8,
                                            width: constraints.maxWidth / 5,
                                            decoration: BoxDecoration(
                                                color: indx == 0
                                                    ? const Color(0xff132137)   
                                                    : const Color.fromRGBO(
                                                        238, 238, 238, 1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        constraints.maxHeight *
                                                            0.3)),
                                            child: FittedBox(
                                                child: Text(
                                              "Self-Help",
                                              style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      color: indx == 0
                                                          ? Colors.white
                                                          : const Color.fromRGBO(171,
                                                              171, 179, 1))),
                                            )),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              indx = 1;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    constraints.maxHeight *
                                                        0.33),
                                            height: constraints.maxHeight * 0.8,
                                            width: constraints.maxWidth / 5,
                                            decoration: BoxDecoration(
                                                color: indx == 1
                                                    ? const Color(0xff132137)  
                                                    : const Color.fromRGBO(
                                                        238, 238, 238, 1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        constraints.maxHeight *
                                                            0.3)),
                                            child: FittedBox(
                                                child: Text(
                                              "Finance",
                                              style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      color: indx == 1
                                                          ? Colors.white
                                                          : const Color.fromRGBO(171,
                                                              171, 179, 1))),
                                            )),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              indx = 2;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    constraints.maxHeight *
                                                        0.33),
                                            height: constraints.maxHeight * 0.8,
                                            width: constraints.maxWidth / 5,
                                            decoration: BoxDecoration(
                                                color: indx == 2
                                                    ? Color(0xff132137)   
                                                    : const Color.fromRGBO(
                                                        238, 238, 238, 1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        constraints.maxHeight *
                                                            0.3)),
                                            child: FittedBox(
                                                child: Text(
                                              "Fantasy",
                                              style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      color: indx == 2
                                                          ? Colors.white
                                                          : const Color.fromRGBO(171,
                                                              171, 179, 1))),
                                            )),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              indx = 3;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    constraints.maxHeight *
                                                        0.33),
                                            height: constraints.maxHeight * 0.8,
                                            width: constraints.maxWidth / 5,
                                            decoration: BoxDecoration(
                                                color: indx == 3
                                                    ? Color(0xff132137)  
                                                    : const Color.fromRGBO(
                                                        238, 238, 238, 1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        constraints.maxHeight *
                                                            0.3)),
                                            child: FittedBox(
                                                child: Text(
                                              "Comedy",
                                              style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      color: indx == 3
                                                          ? Colors.white
                                                          : const Color.fromRGBO(171,
                                                              171, 179, 1))),
                                            )),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: constraints.maxHeight * 0.031,
                              ),
                              SizedBox(
                                  // color: Colors.green,
                                  height: constraints.maxHeight * 0.7,
                                  width: constraints.maxWidth,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: popular.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        constraints.maxWidth *
                                                            0.025),
                                                width:
                                                    constraints.maxWidth * 0.35,
                                                height: constraints.maxHeight *
                                                    0.84,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            constraints
                                                                    .maxHeight *
                                                                0.081),
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(ebooks[index].image)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 3,
                                                          spreadRadius: 2,
                                                          offset: const Offset(4, 1),
                                                          color: Colors.black
                                                              .withOpacity(0.1))
                                                    ]),
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      bottom:
                                                          constraints.maxWidth *
                                                              0.02,
                                                      left:
                                                          constraints.maxWidth *
                                                              0.02,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    constraints
                                                                            .maxHeight *
                                                                        0.015),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    constraints
                                                                            .maxHeight *
                                                                        0.04)),
                                                        height: constraints
                                                                .maxHeight *
                                                            0.12,
                                                        width: constraints
                                                                .maxWidth *
                                                            0.12,
                                                        child: FittedBox(
                                                          child: Text(
                                                            "⭐ " +
                                                                popular[index]
                                                                    .rating
                                                                    .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: constraints.maxHeight *
                                                    0.01,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                height: constraints.maxHeight *
                                                    0.07,
                                                width:
                                                    constraints.maxWidth * 0.39,
                                                //color: Colors.red,
                                                child: FittedBox(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      popular[index].bookname,
                                                      style: GoogleFonts.lato(
                                                          color: const Color.fromRGBO(
                                                              66, 66, 86, 1),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )),
                                              ),
                                              SizedBox(
                                                  height:
                                                      constraints.maxHeight *
                                                          0.05,
                                                  width: constraints.maxWidth *
                                                      0.39,
                                                  //color: Colors.red,
                                                  child: FittedBox(
                                                      child: Text(
                                                    popular[index].authorName,
                                                    style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7))),
                                                  )))
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ))
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0 || index == 2) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      MyDiaryScreen(animationController: animationController);
                });
              });
            } else if (index == 1 || index == 3) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      TrainingScreen(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
