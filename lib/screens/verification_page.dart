import 'dart:io';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:face_attend/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class VerificationPage extends StatefulWidget {
  final String savedImagePath;
  final String downloadedImagePath;
  final String employeeName;

  const VerificationPage({
    required this.savedImagePath,
    required this.downloadedImagePath,
    required this.employeeName,
    super.key
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {

  List<Face>? savedImageFaces;
  List<Face>? downloadedImageFaces;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    detectFaces(widget.savedImagePath, true);
    detectFaces(widget.downloadedImagePath, false);
  }

  Future<void> detectFaces(String imagePath, bool isSavedImage) async {
    try {
      final InputImage inputImage = InputImage.fromFilePath(imagePath);
      final FaceDetector faceDetector = GoogleMlKit.vision.faceDetector();
      final List<Face> detectedFaces = await faceDetector.processImage(inputImage);

      setState(() {
        if (isSavedImage) {
          savedImageFaces = detectedFaces;
        } else {
          downloadedImageFaces = detectedFaces;
        }
        isLoading = false; // Set isLoading to false when face detection is complete
      });

      print("Number of faces detected in ${isSavedImage ? "saved image" : "downloaded image"} : ${detectedFaces.length}");
    } catch (e) {
      print("Error processing image: $e");
      // setState(() {
      //   isLoading = false; // Set isLoading to false to stop loading indicator
      // });
    }
  }

  @override
  Widget build(BuildContext context) {

    // Device's screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.1
              ),
              Text(
                "Check-in Successful",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.055,
                  color: Colors.black,
                  fontWeight: FontWeight.w600
                )
              ),
              SizedBox(
                height: screenHeight * 0.02
              ),
              Text(
                "Photo has been matched",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: Colors.black,
                  letterSpacing: 1
                )
              ),
              Text(
                "successfully",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: Colors.black,
                  letterSpacing: 1
                )
              ),
              SizedBox(
                height: screenHeight * 0.1
              ),
              SizedBox(
                width: screenWidth * 0.5,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.15,
                      backgroundColor: Colors.cyan.withOpacity(0.5),
                      backgroundImage: FileImage(File(widget.savedImagePath))
                    ),
                    Positioned(
                      left: screenWidth * 0.2,
                      child: CircleAvatar(
                        radius: screenWidth * 0.15,
                        backgroundColor: Colors.cyan.withOpacity(0.5),
                        backgroundImage: FileImage(File(widget.downloadedImagePath))
                      )
                    )
                  ]
                )
              ),

              // 
              SizedBox(
                height: screenHeight * 0.05
              ),
              Text(
                "Faces on captured image: ${savedImageFaces?.length}",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1
                )
              ),
              SizedBox(
                height: screenHeight * 0.05
              ),
              Text(
                "Faces on downloaded image: ${downloadedImageFaces?.length}",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1
                )
              )
              //
            ]
          )
        ),
        bottomNavigationBar: SizedBox(
          height: screenHeight * 0.25,
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.1,
                width: screenHeight * 0.1,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(screenWidth)
                ),
                child: Icon(
                  CupertinoIcons.checkmark_alt,
                  size: screenWidth * 0.1,
                  color: Colors.white
                )
              ),
              SizedBox(
                height: screenHeight * 0.05
              ),

              // Home button
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => HomePage(employeeName: widget.employeeName)
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
                    "Home",
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

