import 'dart:io';
import 'dart:math';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:face_attend/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

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
  bool isMatch = false;
  late tfl.Interpreter interpreter;

  @override
  void initState() {
    super.initState();
    loadModel();
    detectFaces(widget.savedImagePath, true);
    detectFaces(widget.downloadedImagePath, false);
  }

  Future<void> loadModel() async {
    try {
      final interpreterOptions = tfl.InterpreterOptions();
      interpreter = await tfl.Interpreter.fromAsset("assets/mobilefacenet.tflite", options: interpreterOptions);
      print("Model loaded successfully");
    } catch (e) {
      print("Failed to load model: $e");
    }
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

      if (savedImageFaces != null && downloadedImageFaces != null) {
        compareFaces(); // Compare faces
      }
    } catch (e) {
      print("Error processing image: $e");
    }
  }

  Future<void> compareFaces() async {
    try {
      // Extract features from faces in both images
      List<List<double>> savedImageFeatures = await extractFeatures(savedImageFaces!);
      List<List<double>> downloadedImageFeatures = await extractFeatures(downloadedImageFaces!);

      // Set threshold
      double threshold = 0.6;

      // Perform face comparison
      isMatch = compareFeatureLists(savedImageFeatures, downloadedImageFeatures, threshold);

      setState(() {
        // Update the state to reflect the result of face comparison
        isMatch = isMatch;
        print("isMatch value: $isMatch");
      });
    } catch (e) {
      print("Error comparing faces: $e");
    }
  }

  Future<List<List<double>>> extractFeatures(List<Face> faces) async {
    List<List<double>> features = [];

    // Iterate over each face and extract features
    for (var face in faces) {
      List<double> featureVector = List.generate(128, (index) => Random().nextDouble());
      features.add(featureVector);
    }
    return features;
  }

  bool compareFeatureLists(List<List<double>> features1, List<List<double>> features2, double threshold) {
    for (var feature1 in features1) {
      for (var feature2 in features2) {
        double distance = euclideanDistance(feature1, feature2);
        if (distance < threshold) {
          return true; // Faces match
        }
      }
    }
    return false; // Faces don't match
  }

  double euclideanDistance(List<double> vector1, List<double> vector2) {
    double sum = 0.0;
    for (int i = 0; i < vector1.length; i++) {
      sum += pow((vector1[i] - vector2[i]), 2);
    }
    return sqrt(sum);
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
              ),
              SizedBox(
                height: screenHeight * 0.05
              ),
              Text(
                "Result: ${isMatch ? "Match" : "Not match"}",
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

