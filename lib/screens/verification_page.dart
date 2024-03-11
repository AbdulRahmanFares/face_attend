import 'dart:convert';
import 'dart:io';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:face_attend/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_face_api/face_api.dart' as regula;

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

  bool isLoading = true;
  bool isMatch = false;

  @override
  void initState() {
    super.initState();
    compareFaces();
  }

  Future<void> compareFaces() async {
    try {
      final image1 = regula.MatchFacesImage();
      final image2 = regula.MatchFacesImage();

      // Set image bitmaps
      image1.bitmap = base64Encode(File(widget.savedImagePath).readAsBytesSync());
      image1.imageType = regula.ImageType.PRINTED;

      image2.bitmap = base64Encode(File(widget.downloadedImagePath).readAsBytesSync());
      image2.imageType = regula.ImageType.PRINTED;

      // Prepare request
      final request = regula.MatchFacesRequest();
      request.images = [image1, image2];

      // Perform face matching
      final response = await regula.FaceSDK.matchFaces(jsonEncode(request));

      // Parse response
      final result = regula.MatchFacesResponse.fromJson(jsonDecode(response)!);
      final similarity = result?.results[0]?.similarity ?? 0.0;

      // Define threshold
      const threshold = 0.6; // Adjust threshold as needed
      // A lower threshold may lead to more strict matching criteria,
      // while a higher threshold may result in more lenient matching

      // Update isMatch based on similarity
      setState(() {
        isMatch = similarity >= threshold;
        isLoading = false;
        print("Similarity: $similarity");
        print("Is face match: $isMatch");
      });
    } catch (e) {
      print("Error comparing faces: $e");
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
                isMatch
                  ? "Check-in Successful"
                  : "Face Not Matched",
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
                isMatch
                  ? "Photo has been matched"
                  : "Please try again or contact support",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: Colors.black,
                  letterSpacing: 1
                )
              ),
              Text(
                isMatch
                  ? "successfully"
                  : "",
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
                      backgroundColor: isMatch
                        ? Colors.green
                        : Colors.red,
                      child: CircleAvatar(
                        radius: screenWidth * 0.14,
                        backgroundColor: Colors.cyan.withOpacity(0.5),
                        backgroundImage: FileImage(File(widget.savedImagePath))
                      )
                    ),
                    Positioned(
                      left: screenWidth * 0.2,
                      child: CircleAvatar(
                        radius: screenWidth * 0.15,
                        backgroundColor: isMatch
                          ? Colors.green
                          : Colors.red,
                        child: CircleAvatar(
                          radius: screenWidth * 0.14,
                          backgroundColor: Colors.cyan.withOpacity(0.5),
                          backgroundImage: FileImage(File(widget.downloadedImagePath))
                        ),
                      )
                    )
                  ]
                )
              )
            ]
          )
        ),
        bottomNavigationBar: SizedBox(
          height: screenHeight * 0.25,
          child: Column(
            children: [
              Image.asset(
                isMatch
                  ? "assets/tick.png"
                  : "assets/cross.png",
                height: screenHeight * 0.1
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

