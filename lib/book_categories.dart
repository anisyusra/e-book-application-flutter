import 'package:flutter/material.dart';

class EbookCate extends StatelessWidget {
  final String ebookCate;
  final bool isSelected;
  final VoidCallback onTap;

  EbookCate({
    required this.ebookCate,
    required this.isSelected,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10,),
        child: Container(
          width: 90,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9.0),
            color: isSelected ? Color.fromARGB(255, 184, 255, 235): Color.fromARGB(255, 255, 255, 255),
          ),
          child:Text(
              textAlign: TextAlign.center,
               ebookCate,
            style: TextStyle(
              height: 2.5,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Color.fromARGB(255, 255, 255, 255): Color.fromARGB(255, 0, 0, 0),
            )
            ),
        ),
      ),
    );
  }
}