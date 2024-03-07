import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:face_attend/screens/camera_page.dart';
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
      color: Colors.white,
      child: Scaffold(
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
              Container(
                alignment: Alignment.center,
                height: screenHeight * 0.07,
                width: screenWidth * 0.7,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey
                  )
                ),
                child: Text(
                  "SMART ATTENDANCE",
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.045,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1
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

