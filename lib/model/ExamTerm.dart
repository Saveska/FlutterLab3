class ExamTerm {
  String subject;
  String date;
  String time;
  DateTime dateTime;
  double long;
  double lat;


  ExamTerm({
    required this.subject,
    required this.date,
    required this.time,
    required this.dateTime,
    required this.lat,
    required this.long
  });


  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'dateTime': dateTime.toIso8601String(),
      'long': long,
      'lat': lat
    };
  }
}