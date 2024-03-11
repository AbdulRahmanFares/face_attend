import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:face_attend/screens/camera_page.dart';
import 'package:face_attend/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  final String employeeName;

  const HomePage({
    required this.employeeName,
    super.key
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    // Device's screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ColorfulSafeArea(
      color: Colors.teal,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.teal,
          title: Text(
            "SMART ATTENDANCE",
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 1
            )
          ),
          centerTitle: true
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => CameraPage(employeeName: widget.employeeName)
                  ));
                },
                icon: Icon(
                  Icons.camera_rounded,
                  size: screenHeight * 0.1,
                  color: Colors.grey
                )
              ),
              SizedBox(
                height: screenHeight * 0.05
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => const Login() // Navigate to login page
                  ));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.3,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey
                    )
                  ),
                  child: Text(
                    "LOGOUT",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1
                    )
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}

