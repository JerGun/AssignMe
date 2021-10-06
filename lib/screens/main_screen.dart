import 'package:flutter/material.dart';
import 'package:flutter_assignme/services/authentication_service.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  final Duration duration = const Duration(milliseconds: 300);
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: duration,
      left: isCollapsed ? 0 : 0.85 * MediaQuery.of(context).size.width,
      right: isCollapsed ? 0 : -0.85 * MediaQuery.of(context).size.width,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[800],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 60,
              color: Colors.grey[850],
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      child: Icon(Icons.menu, color: Colors.white),
                      onTap: () {
                        setState(() {
                          if (isCollapsed)
                            _controller.forward();
                          else
                            _controller.reverse();
                          isCollapsed = !isCollapsed;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("General",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                    Icon(Icons.attach_file, color: Colors.white),
                    SizedBox(width: 20),
                    Icon(Icons.assignment, color: Colors.white),
                    SizedBox(width: 20),
                    Icon(Icons.people, color: Colors.white),
                  ],
                ),
              ),
            ),
            Text("HOME"),
            TextButton(
              onPressed: () {
                context.read<AuthenticationService>().signOutWithGoogle();
              },
              child: Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
