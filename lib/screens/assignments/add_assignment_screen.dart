import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/behavior.dart';
import 'package:flutter_assignme/screens/components/text_input.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';

class AddAssignmentScreen extends StatefulWidget {
  const AddAssignmentScreen({
    Key? key,
    required this.gid,
    required this.groupName,
    required this.cid,
    required this.channelName,
  }) : super(key: key);

  final String gid;
  final String groupName;
  final String cid;
  final String channelName;

  @override
  _AddAssignmentScreenState createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionsController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  User? user = FirebaseAuth.instance.currentUser;

  Future addAssignments() async {
    FirebaseFirestore.instance.collection('assignments').add({
      'gid': widget.gid,
      'groupName': widget.groupName,
      'cid': widget.cid,
      'channelName': widget.channelName,
      'title': titleController.text,
      'descriptions': descriptionsController.text,
      'points': num.parse(pointsController.text),
      'dateDue': dateController.text,
      'timeDue': timeController.text,
      'assigner': user!.uid,
    }).then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Assignments',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.grey[900],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addAssignments();
          },
          child: Icon(
            Icons.save,
            color: Colors.grey[850],
          ),
          backgroundColor: Colors.yellow,
        ),
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: Behavior(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.grey[850],
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Text(
                                'Title',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextInput(controller: titleController, hint: 'Title'),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Text(
                                'Descriptions',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextInput(
                              controller: descriptionsController,
                              hint: 'Descriptions',
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Text(
                                'Points',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextInput(
                              controller: pointsController,
                              hint: 'Points',
                              textInputType: TextInputType.number,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Text(
                                'Date due',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                DateTime? newDateTime = await showRoundedDatePicker(
                                  context: context,
                                  fontFamily: 'Prompt',
                                  theme: ThemeData(
                                    primaryColor: Colors.grey[900],
                                    dialogBackgroundColor: Colors.grey[800],
                                    textTheme: TextTheme(
                                      body1: TextStyle(color: Colors.white),
                                      caption: TextStyle(color: Colors.grey[300]),
                                    ),
                                  ),
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(DateTime.now().year - 1),
                                  lastDate: DateTime(DateTime.now().year + 1),
                                  borderRadius: 20,
                                  styleDatePicker: MaterialRoundedDatePickerStyle(
                                    paddingMonthHeader: EdgeInsets.only(top: 16),
                                    textStyleMonthYearHeader: TextStyle(color: Colors.white),
                                    colorArrowNext: Colors.white,
                                    colorArrowPrevious: Colors.white,
                                  ),
                                );
                                if (newDateTime != null)
                                  setState(() {
                                    selectedDate = newDateTime;
                                    dateController.text = DateFormat.yMd().format(selectedDate);
                                  });
                              },
                              child: TextInput(
                                controller: dateController,
                                hint: 'Date due',
                                enabled: false,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Text(
                                'Time due',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final timePicked = await showRoundedTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  borderRadius: 20,
                                  theme: ThemeData(
                                    primaryColor: Colors.grey[900],
                                    dialogBackgroundColor: Colors.grey[800],
                                    textTheme: TextTheme(
                                      caption: TextStyle(color: Colors.grey[300]),
                                    ),
                                  ),
                                );
                                if (timePicked != null)
                                  setState(() {
                                    selectedTime = timePicked;
                                    DateTime time = DateFormat("hh:mma").parse(selectedTime.format(context).replaceAll(' ', ''));
                                    timeController.text = DateFormat("HH:mm").format(time);
                                  });
                              },
                              child: TextInput(
                                controller: timeController,
                                hint: 'Time due',
                                enabled: false,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
