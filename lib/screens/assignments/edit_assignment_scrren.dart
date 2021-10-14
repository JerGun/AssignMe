import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/behavior.dart';
import 'package:flutter_assignme/screens/components/text_input.dart';
import 'package:flutter_assignme/screens/components/toast.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class EditAssignmentScreen extends StatefulWidget {
  const EditAssignmentScreen({
    Key? key,
    required this.aid,
    required this.title,
    required this.gid,
    required this.groupName,
    required this.cid,
    required this.channelName,
  }) : super(key: key);

  final String aid;
  final String title;
  final String gid;
  final String groupName;
  final String cid;
  final String channelName;

  @override
  _EditAssignmentScreenState createState() => _EditAssignmentScreenState();
}

class _EditAssignmentScreenState extends State<EditAssignmentScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionsController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  late FToast fToast;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  User? user = FirebaseAuth.instance.currentUser;

  Future editAssignment() async {
    if (titleController.text.isEmpty)
      fToast.showToast(
        child: toast('Title is required.'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
      );
    else if (descriptionsController.text.isEmpty)
      fToast.showToast(
        child: toast('Descriptions is required.'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
      );
    else if (pointsController.text.isEmpty)
      fToast.showToast(
        child: toast('Points is required.'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
      );
    else if (dateController.text.isEmpty)
      fToast.showToast(
        child: toast('Date due is required.'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
      );
    else if (timeController.text.isEmpty)
      fToast.showToast(
        child: toast('Time due is required.'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
      );
    else {
      FirebaseFirestore.instance.collection('assignments').doc(widget.aid).update({
        'title': titleController.text,
        'descriptions': descriptionsController.text,
        'points': num.parse(pointsController.text),
        'dateDue': dateController.text,
        'timeDue': timeController.text,
        'assigner': user!.uid,
      }).then((value) => Navigator.pop(context));
    }
  }

  Future deleteAssignments() async {
    FirebaseFirestore.instance.collection('assignments').doc(widget.aid).delete().then((value) => {Navigator.pop(context), Navigator.pop(context)});
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    DocumentReference assignmentDoc = FirebaseFirestore.instance.collection('assignments').doc(widget.aid);
    assignmentDoc.get().then((value) => {
          print(value['title']),
          titleController.text = value['title'],
          descriptionsController.text = value['descriptions'],
          pointsController.text = value['points'].toString(),
          dateController.text = value['dateDue'],
          timeController.text = value['timeDue'],
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Assignment',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Delete '${widget.title}'",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to delete ${widget.title}.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        backgroundColor: Colors.grey[800],
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancle',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                deleteAssignments();
                              },
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete, color: Colors.red))
          ],
          backgroundColor: Colors.grey[900],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            editAssignment();
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
