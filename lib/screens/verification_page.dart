import 'dart:convert';
import 'dart:io';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:face_attend/constants.dart';
import 'package:face_attend/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class VerificationPage extends StatefulWidget {
  final String savedImagePath;
  final String downloadedImagePath;
  final String employeeName;

  const VerificationPage({
    required this.savedImagePath,
    required this.downloadedImagePath,
    required this.employeeName,
    Key? key
  }) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {

  final obj = Constants();
  bool isLoading = true;
  bool isMatch = false;

  @override
  void initState() {
    super.initState();
    startFaceComparison();
  }

  // Function to perform face comparison asynchronously
  Future<void> startFaceComparison() async {
    try {
      // Perform face comparison in the background
      await compareFaces();
    } catch (e) {
      print("Error comparing faces: $e");
    } finally {
      // Once the comparison is done (successful or not), set isLoading to false
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to compare faces
  Future<void> compareFaces() async {
    final image1File = File(widget.savedImagePath);
    final image2File = File(widget.downloadedImagePath);

    // Wait for both files to be read and encoded concurrently
    List<List<int>> encodedImages = await Future.wait([
      image1File.readAsBytes(),
      image2File.readAsBytes()
    ]);

    final image1 = regula.MatchFacesImage();
    final image2 = regula.MatchFacesImage();

    // Set image bitmaps from the encoded images
    image1.bitmap = base64Encode(encodedImages[0]);
    image1.imageType = regula.ImageType.PRINTED;

    image2.bitmap = base64Encode(encodedImages[1]);
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
      print("Similarity: $similarity");
      print("Is face match: $isMatch");
    });
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
                isLoading
                  ? "Hold Still"
                  : isMatch
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
                isLoading
                  ? "while we work our magic"
                  : isMatch
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
                      backgroundColor: isLoading
                        ? obj.kashmirBlue
                        : isMatch
                          ? Colors.green
                          : Colors.redAccent,
                      child: CircleAvatar(
                        radius: screenWidth * 0.14,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: screenWidth * 0.13,
                          backgroundColor: Colors.cyan.withOpacity(0.5),
                          backgroundImage: FileImage(File(widget.savedImagePath))
                        )
                      )
                    ),
                    Positioned(
                      left: screenWidth * 0.2,
                      child: CircleAvatar(
                        radius: screenWidth * 0.15,
                        backgroundColor: isLoading
                          ? obj.kashmirBlue
                          : isMatch
                            ? Colors.green
                            : Colors.redAccent,
                        child: CircleAvatar(
                          radius: screenWidth * 0.14,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: screenWidth * 0.13,
                            backgroundColor: Colors.cyan.withOpacity(0.5),
                            backgroundImage: FileImage(File(widget.downloadedImagePath))
                          )
                        )
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
              isLoading
                ? SizedBox(
                  height: screenHeight * 0.1,
                  child: LoadingAnimationWidget.hexagonDots(
                    color: Colors.cyan.withOpacity(0.3),
                    size: screenHeight * 0.1
                  )
                )
                : Image.asset(
                  isMatch
                    ? "assets/tick.png"
                    : "assets/cross.png",
                  height: screenHeight * 0.1
                ),
              SizedBox(
                height: screenHeight * 0.05
              ),

              // Home button
              isLoading
                ? const SizedBox()
                : GestureDetector(
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

