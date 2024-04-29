import 'package:chatbot/components/constants.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: appBar_color,
        child: ListView(
          children: [
            Card(
              color: backGround_color,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Image.asset("assets/images/openai_logo.png")),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              color: backGround_color,
            ),
            ListTile(
              leading: Icon(
                Icons.privacy_tip,
                color: Colors.white,
              ),
              title: Text(
                "Privacy Policy",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Divider(
              color: backGround_color,
            ),
            ListTile(
              leading: Icon(
                Icons.share,
                color: Colors.white,
              ),
              title: Text(
                "Share this app",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Divider(
              color: backGround_color,
            ),
            ListTile(
              leading: Icon(
                Icons.contact_mail,
                color: Colors.white,
              ),
              title: const Text(
                "Contact Us",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Divider(
              color: backGround_color,
            ),
          ],
        ),
      );
  }
}