import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import '../model/ExamTerm.dart';
import 'calendar_view.dart';
import 'login_view.dart';
import 'map_view.dart';
import 'package:lab3/widgets/location_choose.dart';



class ExamTermsView extends StatefulWidget {
  const ExamTermsView({super.key});

  @override
  State<ExamTermsView> createState() => _ExamTermsViewState();
}

class _ExamTermsViewState extends State<ExamTermsView> {
  List<ExamTerm> examTerms = [];


  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime;
  LatLong? _location;


  void updateLocation(LatLong newValue) {
    setState(() {
      _location = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Exam terms'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.logout_outlined),
              onPressed: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
            const Text('Exam terms'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () {
              if (examTerms.isNotEmpty) {
                _navigateToMapView(examTerms);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              _navigateToCalendarView(examTerms);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddTermDialog();
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: examTerms.length,
        itemBuilder: (context, index) {
          return _buildCard(examTerms[index]);
        },
      ),
    );
  }

  Widget _buildCard(ExamTerm term) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              term.subject,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Date: ${term.date}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            Text(
              'Time: ${term.time}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddTermDialog() async {
    TextEditingController subjectController = TextEditingController();
    TextEditingController dateTextController = TextEditingController();
    TextEditingController timeTextController = TextEditingController();
    TextEditingController addressController = TextEditingController();

    TimeOfDay? selectedTime;




    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Exam Term'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: dateTextController,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                            dateTextController.text =
                            "${pickedDate.year}-${pickedDate.month}-${pickedDate
                                .day}";
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                          dateTextController.text =
                          "${pickedDate.year}-${pickedDate.month}-${pickedDate
                              .day}";
                        });
                      }
                    },
                  ),
              //  ],
             // ),
              const SizedBox(height: 8.0),
             // Row(
               // children: [
                  Expanded(
                    child: TextFormField(
                      controller: timeTextController,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        labelText: 'Time',
                      ),
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          setState(() {
                            selectedTime = pickedTime;
                            timeTextController.text =
                            "${pickedTime.hour.toString().padLeft(
                                2, '0')}:${pickedTime.minute.toString().padLeft(
                                2, '0')}";
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime;
                          timeTextController.text =
                          "${pickedTime.hour.toString().padLeft(
                              2, '0')}:${pickedTime.minute.toString().padLeft(
                              2, '0')}";
                        });
                      }
                    },
                  ),

                ],

              ),
              const SizedBox(height: 8.0),
              Center(
                child: OutlinedButton(
                  child: Text(locationString()),
                  onPressed: () {
                    Navigator.push(context, _createRouteLocationPick());
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  examTerms.add(
                    ExamTerm(
                      subject: subjectController.text,
                      date: "${selectedDate.year}-${selectedDate
                          .month}-${selectedDate.day}",
                      time: selectedTime != null
                          ? "${selectedTime!.hour.toString().padLeft(2,
                          '0')}:${selectedTime!.minute.toString().padLeft(2,
                          '0')}"
                          : "",
                      dateTime: selectedDate,
                      long:  _location!.longitude,
                      lat:  _location!.latitude,

                    ),
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToCalendarView(List<ExamTerm> exams) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CalendarView(exams: exams),
      ),
    );
  }

  void _navigateToMapView(List<ExamTerm> exams) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapView(
          long: -1,
          lat: -1,
          exams: examTerms,
        ),
      ),
    );
  }

  Route _createRouteLocationPick() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          LocationChoose(updateLocation),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  String locationString() {
    // if (_location == null) {
      return "Choose location";
    //}
    //return "${_location?.latitude} ${_location?.longitude}";
  }




}




Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _logout(context);
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}

void _logout(BuildContext context) {
  // Perform any logout-related logic here
  FirebaseAuth.instance.signOut();
  // Navigate to the login page
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginView()),
  );
}

