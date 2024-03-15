import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:face_attend/constants.dart';
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

  final obj = Constants();

  @override
  Widget build(BuildContext context) {

    // Device's screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ColorfulSafeArea(
      color: obj.kashmirBlue,
      child: Scaffold(
        backgroundColor: obj.whiteShade,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: obj.kashmirBlue,
          toolbarHeight: screenHeight * 0.07,
          title: Text(
            "SMART ATTENDANCE",
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 1
            )
          ),
          centerTitle: true
        ),

        // Camera
        body: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => CameraPage(employeeName: widget.employeeName) // Navigate to camera page
              ));
            },
            child: Container(
              height: screenHeight * 0.2,
              width: screenHeight * 0.2,
              decoration: BoxDecoration(
                color: obj.lavender,
                border: Border.all(
                  color: Colors.grey
                ),
                borderRadius: BorderRadius.circular(screenWidth)
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                size: screenHeight * 0.08,
                color: obj.greyShade
              )
            )
          )
        ),
        bottomNavigationBar: SizedBox(
          height: screenHeight * 0.08,
          child: Column(
            children: [

              // Logout button
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => const Login() // Navigate to login page
                  ));
                },
                child: Container(
                  height: screenHeight * 0.03,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey
                      )
                    )
                  ),
                  child: Text(
                    "Logout",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black
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

