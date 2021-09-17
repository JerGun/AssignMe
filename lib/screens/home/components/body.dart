import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints.expand(),
          child: Image.asset(
            'assets/images/login.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.45,
          child: Column(
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              SizedBox(height: 20),
              Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '',
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
