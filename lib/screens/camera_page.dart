import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:face_attend/screens/verification_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  final String employeeName;

  const CameraPage({
    required this.employeeName,
    super.key
  });

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  late CameraController cameraController;
  bool isFrontCamera = true;
  String cameraEntryType = "";
  String savedImagePath = "";
  String downloadedImagePath = "";
  bool isImageCaptured = false;

  @override
  void initState() {
    super.initState();
    cameraController = CameraController(
      const CameraDescription(
        name: "DummyCamera",
        lensDirection: CameraLensDirection.front,
        sensorOrientation: 0
      ),
      ResolutionPreset.high
    );
    initializeCamera();
    getImagePathAndDownloadImage(widget.employeeName);
  }

  Future<void>  initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
      (cam) => cam.lensDirection == (isFrontCamera ? CameraLensDirection.front : CameraLensDirection.back)
    );
    cameraController = CameraController(camera, ResolutionPreset.high);
    await cameraController.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  // Capture image from camera
  Future<void> captureImage() async {
    final XFile? capturedImage = await cameraController.takePicture();
    
    if (capturedImage != null) {
      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String appPath = appDirectory.path;
      final String fileName = "captured_image_${DateTime.now().day}_${DateTime.now().month}_${DateTime.now().year}_${DateTime.now().hour}_${DateTime.now().minute}_${DateTime.now().second}.JPG"; // Eg: captured_image_15/2/2024_15_28.JPG
      final String filePath = "$appPath/$fileName";

      await File(capturedImage.path).copy(filePath);

      final File savedImageFile = File(filePath);
      if (await savedImageFile.exists()) {
        if (mounted) {
          setState(() {
            savedImagePath = filePath;
            isImageCaptured = true;
            cameraEntryType = "IN";
            print("File uploaded successfully");
            print("Uploaded file path: $filePath");
            print("Uploaded file name: $fileName");
          });
        }
      }
    }
  }

  // Get the image path from the server
  Future<void> getImagePathAndDownloadImage(String employeeName) async {
    final Dio dio = Dio();
    final response = await dio.get(
      // "https://epistatehealth.com/Fares/smart_attendance/get_image_path",
      "https://hgilapp.000webhostapp.com/SmartAttendanceAPI/get_image_path.php",
      queryParameters: {"employeeName" : employeeName}
    );

    final String message = response.data;
    print("Message from server: $message");

    if (message == "Employee not in the list") {
      // When employee not in the list
      print("Employee not in the list");
    } else if (message == "Image path is empty") {
      // When image path is empty
      print("Image path is empty");
    } else {
      // When image path is not empty
      // final String imageUrl = "https://epistatehealth.com/Fares/smart_attendance/$message";
      final String imageUrl = "https://hgilapp.000webhostapp.com/SmartAttendanceAPI/$message";
      await downloadAndSaveImage(imageUrl, employeeName);
    }
  }

  // Download and save an Image from a given URL
    Future<void> downloadAndSaveImage(String imageUrl, String employeeName) async {
    final Dio dio = Dio();
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String appPath = appDirectory.path;
    final String fileName = "downloaded_image_of_$employeeName.JPG";
    final String filePath = "$appPath/$fileName";

    await dio.download(imageUrl, filePath);

    if (mounted) {
      setState(() {
        downloadedImagePath = filePath;

        print("Image downloaded and saved to: $filePath");
        print("File name: $fileName");

        print("Saved image path: $widget.savedImagePath");
        print("Downloaded image path: $downloadedImagePath");

        // compareFaces(savedImagePath, downloadedImagePath);
      });
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Device's screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: isImageCaptured
              ? Image.file(
                File(savedImagePath),
                fit: BoxFit.cover // Maintain aspect ratio and fill the entire space
              )
              : CameraPreview(cameraController)
          ),
          Positioned(
            bottom: screenHeight * 0.05,
            left: screenWidth * 0.1,
            child: Container(
              padding: EdgeInsets.only(
                left: screenHeight * 0.02,
                right: screenHeight * 0.02
              ),
              height: screenHeight * 0.11,
              width: screenWidth * 0.8,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(screenWidth)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // Cancel button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigate to home page
                    },
                    child: Container(
                      height: screenHeight * 0.07,
                      width: screenHeight * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(screenWidth * 0.1)
                      ),
                      child: Icon(
                        CupertinoIcons.chevron_back,
                        color: Colors.white,
                        size: screenHeight * 0.03,
                      )
                    )
                  ),

                  // Capture / IN or OUT button
                  GestureDetector(
                    onTap: () {
                      if (cameraEntryType == "IN") {
                        // Navigate to verification page
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => VerificationPage(savedImagePath: savedImagePath, downloadedImagePath: downloadedImagePath, employeeName: widget.employeeName)
                        ));
                      } else {
                        // Capture image
                        captureImage();
                      }
                    },
                    child: Container(
                      height: screenHeight * 0.07,
                      width: screenHeight * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.1)
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cameraEntryType, // Display camera entry type value when image is captured
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1
                        )
                      )
                    )
                  ),

                  // Switch camera / retake button
                  GestureDetector(
                    onTap: () {
                      if (isImageCaptured) {
                        // Retake
                        setState(() {
                          cameraEntryType = ""; // Reset cameraEntryType
                          isImageCaptured = false; // Reset isImageCaptured
                        });
                        initializeCamera();
                      } else {
                        // Switch camera
                        setState(() {
                          isFrontCamera = !isFrontCamera;
                        });
                        initializeCamera();
                      }
                    },
                    child: Container(
                      height: screenHeight * 0.07,
                      width: screenHeight * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(screenWidth * 0.1)
                      ),
                      child: Icon(
                        isImageCaptured
                        ? CupertinoIcons.arrow_clockwise // For retake
                        : CupertinoIcons.arrow_2_circlepath, // For camera switch
                        color: Colors.white,
                        size: screenHeight * 0.03,
                      )
                    )
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }
}

