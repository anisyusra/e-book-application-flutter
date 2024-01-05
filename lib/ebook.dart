import 'dart:convert';

Ebook ebookFromJson(String str) => Ebook.fromJson(json.decode(str));

String ebookToJson(Ebook data) => json.encode(data.toJson());

class Ebook {
  Ebook({
    this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.page,
    required this.link,
    required this.description,
    required this.image,
  });

  String? id;
  final String title;
  final String author;
  final String year;
  final String page;
  final String link;
  final String description;
  final String image;

  factory Ebook.fromJson(Map<String, dynamic> json) => Ebook(
        id: json["id"],
        link: json["link"],
        title: json["title"],
        author: json["author"],
        year: json["year"],
        page: json["page"],
        description: json["description"],
        image: json["image"],
      );
  
  Map<String, dynamic> toJson() => {
        "id": id,
        "link": link,
        "title": title,
        "author": author,
        "year": year,
        "page": page,
        "description": description,
        "image": image,
      };

}