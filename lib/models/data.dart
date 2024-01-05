class Booksdata {
  String bookname;
  String authorName;
  String imagePath;
  int year;
  double rating ;
  String link;
  Booksdata(
      {required this.authorName,
      required this.bookname,
      required this.year,
      required this.imagePath,required this.rating,
      required this.link});
}

List<Booksdata> continueReading = [
  Booksdata(
      bookname: "Wings of Fire",
      authorName: "APJ Abdul Kalam",
      year: 64,
      imagePath: 'assets/images/APJ.jpg',
      rating: 4.8,
      link: 'https://manybooks.net//mnybks-registration-form?download_nid=127668'),
  Booksdata(
      bookname: "The Arsonist",
      authorName: "Chloe Hooper",
      year: 16,
      imagePath: 'assets/images/ChloeHooper.jpg', rating: 4.8,
      link: 'https://manybooks.net//mnybks-registration-form?download_nid=127668'),
  Booksdata(
      bookname: "Harry Potter",
      authorName: "J.K Rowling",
      year: 44,
      imagePath: 'assets/images/HarryPotter.jpeg', rating: 4.8,
      link: 'https://manybooks.net//mnybks-registration-form?download_nid=127668'),
];

List<Booksdata> popular = [
  Booksdata(
      bookname: "This is How It Always Is",
      authorName: "Laurie Frankel",
      year: 0,
      imagePath: 'assets/images/ThisisHow.jpeg',
      rating: 4.5,
      link: 'https://manybooks.net//mnybks-registration-form?download_nid=127668'
      ),

  Booksdata(
      bookname: "In A Land Of Paper Gods",
      authorName: "Rebecca Mackenzie",
      year: 0,
      imagePath: 'assets/images/rebbeca.jpg',
      rating: 4.3,
      link: 'https://manybooks.net//mnybks-registration-form?download_nid=127668'
      ),
  Booksdata(
      bookname: "The Guest List",
      authorName: "Lucy Foley",
      year: 0,
      imagePath: 'assets/images/theguest.jpeg',
      rating: 4.0,
      link: 'https://manybooks.net//mnybks-registration-form?download_nid=127668'
      ),
      
];
