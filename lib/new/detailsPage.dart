import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ReadingPage.dart';
import 'ListeningPage.dart';



final FirebaseFirestore firestore = FirebaseFirestore.instance;

CollectionReference<Map<String, dynamic>> booksCollection = FirebaseFirestore.instance.collection('eBook');

Future<List<Map<String, dynamic>>> fetchBooks() async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await booksCollection.get();

  List<Map<String, dynamic>> books = [];
  querySnapshot.docs.forEach((doc) {
    books.add({
      'title': doc['title'],
      'link': doc['link'],
    });
  });

  return books;
}

Map<String, String> bookLinks = {};

class DetailsPage extends StatefulWidget {
  final String imageAddress;
  final String bookname;
  final String authorname;
  final String year;
  final String pages;
  final String link;

  DetailsPage({
    required this.authorname, 
    required this.bookname, 
    required this.year, 
    required this.imageAddress,
    required this.pages,
    required this.link,
  });

  
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
// late Stream<DocumentSnapshot> _stream;


  @override
void initState() {
    super.initState();
    fetchBooks().then((books) {
      books.forEach((book) {
        bookLinks[book['title']] = book['link'];
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      //backgroundColor: Colors.white,
      body:SafeArea(
            child: Container(
          decoration: const BoxDecoration(
              //color: Colors.red,
              gradient: LinearGradient(
                  colors: [Color.fromRGBO(249, 191, 161, 1), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.center
                  //,stops: [0.7,0.9]
                  )),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                height: size.height * 0.075,
                width: size.width,
                //color: Colors.red,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          color: Colors.white.withOpacity(0),
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(
                                constraints.maxHeight * 0.4),
                            splashColor: Colors.white,
                            child: Container(
                              padding:
                                  EdgeInsets.all(constraints.maxHeight * 0.18),
                              //color: Colors.black,
                              height: constraints.maxHeight * 0.8,
                              width: constraints.maxWidth * 0.15,
                              child: const FittedBox(
                                  child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth * 0.54,
                        ),
                        Container(
                          padding: EdgeInsets.all(constraints.maxHeight * 0.18),
                          //color: Colors.black,
                          height: constraints.maxHeight * 0.8,
                          width: constraints.maxWidth * 0.15,
                          child: const FittedBox(
                              child: Icon(
                            Icons.share,
                            color: Colors.white,
                          )),
                        ),
                        Container(
                          padding: EdgeInsets.all(constraints.maxHeight * 0.18),
                          //color: Colors.black,
                          height: constraints.maxHeight * 0.8,
                          width: constraints.maxWidth * 0.15,
                          child: const FittedBox(
                              child: Icon(
                            Icons.bookmark_border,
                            color: Colors.white,
                          )),
                        )
                      ],
                    );
                  },
                ),
              ),
              Hero(
                tag: const Text("Haha"),
                child: Container(
                  height: size.height * 0.4,
                  width: size.width * 0.55,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(size.width * 0.05),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(widget.imageAddress)
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: const Color.fromRGBO(203, 201, 208, 1),
                            blurRadius: 10,
                            spreadRadius: 0.6,
                            offset: Offset(size.width * 0.55 * 0.051,
                                size.height * 0.4 * 0.031))
                      ]),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Positioned(
                            bottom: constraints.maxWidth * 0.04,
                            left: constraints.maxWidth * 0.05,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxHeight * 0.015),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(1),
                                  borderRadius: BorderRadius.circular(
                                      constraints.maxHeight * 0.04)),
                              height: constraints.maxHeight * 0.12,
                              width: constraints.maxWidth * 0.25,
                              child: FittedBox(
                                child: Text(
                                  "⭐ " + 4.5.toString(),
                                  style: GoogleFonts.lato(
                                      textStyle:
                                          const TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.025,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.33),
                height: size.height * 0.06,
                width: size.width,
                //color: Colors.red,
                child: FittedBox(
                    child: Text(
                  widget.bookname,
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(66, 66, 86, 1)),
                )),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.33, vertical: size.width * 0.009),
                height: size.height * 0.03,
                width: size.width,
                //color: Colors.red,
                child: FittedBox(
                    child: Text(
                  widget.authorname,
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(142, 142, 154, 1)),
                )),
              ),
              Container(
                height: size.height * 0.07,
                width: size.width,
                //color: Colors.red,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          //color: Colors.purple,
                          width: constraints.maxWidth * 0.27,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(
                                        constraints.maxHeight * 0.1),
                                    //color: Colors.grey,
                                    height: constraints.maxHeight * 0.6,
                                    width: constraints.maxWidth,
                                    child: FittedBox(
                                        child: Text(
                                      widget.year,
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color: const Color.fromRGBO(66, 66, 86, 1)
                                                  .withOpacity(0.9),
                                              fontWeight: FontWeight.bold)),
                                    )),
                                  ),
                                  Container(
                                    //color: Colors.pink,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: constraints.maxHeight * 0.1),
                                    height: constraints.maxHeight * 0.4,
                                    width: constraints.maxWidth,
                                    child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "Published in",
                                          style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  fontSize: 20,
                                                  color: Color.fromRGBO(
                                                      142, 142, 154, 1),
                                                  fontWeight: FontWeight.w300)),
                                        )),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Container(
                          color: const Color.fromRGBO(203, 201, 208, 1),
                          width: constraints.maxWidth * 0.0031,
                          height: constraints.maxHeight,
                        ),
                        Container(
                          //color: Colors.purple,
                          width: constraints.maxWidth * 0.27,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(
                                        constraints.maxHeight * 0.1),
                                    //color: Colors.grey,
                                    height: constraints.maxHeight * 0.6,
                                    width: constraints.maxWidth,
                                    child: FittedBox(
                                        child: Text(
                                      widget.pages,
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color: const Color.fromRGBO(66, 66, 86, 1)
                                                  .withOpacity(0.9),
                                              fontWeight: FontWeight.bold)),
                                    )),
                                  ),
                                  Container(
                                    //color: Colors.pink,
                                    height: constraints.maxHeight * 0.4,
                                    width: constraints.maxWidth,
                                    child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "Pages",
                                          style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  fontSize: 20,
                                                  color: Color.fromRGBO(
                                                      142, 142, 154, 1),
                                                  fontWeight: FontWeight.w300)),
                                        )),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Container(
                          color: const Color.fromRGBO(203, 201, 208, 1),
                          width: constraints.maxWidth * 0.0031,
                          height: constraints.maxHeight,
                        ),
                        Container(
                          //color: Colors.purple,
                          width: constraints.maxWidth * 0.27,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(
                                        constraints.maxHeight * 0.1),
                                    //color: Colors.grey,
                                    height: constraints.maxHeight * 0.6,
                                    width: constraints.maxWidth,
                                    child: FittedBox(
                                        child: Text(
                                      "187",
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color: const Color.fromRGBO(66, 66, 86, 1)
                                                  .withOpacity(0.9),
                                              fontWeight: FontWeight.bold)),
                                    )),
                                  ),
                                  Container(
                                    //color: Colors.pink,
                                    height: constraints.maxHeight * 0.4,
                                    width: constraints.maxWidth,
                                    child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "Reviews",
                                          style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  fontSize: 20,
                                                  color: Color.fromRGBO(
                                                      142, 142, 154, 1),
                                                  fontWeight: FontWeight.w300)),
                                        )),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),

              Container(
                child: _buildBookDetails(),
              )

],
        )),
      ),
    );
  }

 Widget _buildBookDetails() {
    if (bookLinks.containsKey(widget.bookname)){
      String link = bookLinks[widget.bookname]!;
      return InkWell(
        child: Text(
          link,
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
        onTap: () => launch(link),
      );}
      else {
        return Text("No data availab");
      }
      }
}

