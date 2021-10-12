import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/behavior.dart';
import 'package:flutter_assignme/screens/components/text_input.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

class AddAssignmentScreen extends StatefulWidget {
  const AddAssignmentScreen({Key? key}) : super(key: key);

  @override
  _AddAssignmentScreenState createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionsController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();

  Future addAssignments() async {
    FirebaseFirestore.instance.collection('assignments').add({
      'title': titleController.text,
      'descriptions': descriptionsController.text,
      'points': num.parse(pointsController.text),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          showRoundedDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 1),
                            lastDate: DateTime(DateTime.now().year + 1),
                            borderRadius: 16,
                          );
                        },
                        child: Text('Date'),
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
    );
  }
}
