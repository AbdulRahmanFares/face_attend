import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:face_attend/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String employeeName = "";
  String hintText = "Name";
  Color hintTextColor = Colors.black54;
  TextEditingController nameController = TextEditingController();
  
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
              Text(
                "LOGIN",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.05,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2
                )
              ),
              SizedBox(
                height: screenHeight * 0.05
              ),

              // Name
              Container(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05
                ),
                height: screenHeight * 0.07,
                width: screenWidth * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey
                  )
                ),
                child: TextFormField(
                  controller: nameController,
                  maxLines: 1,
                  cursorColor: Colors.grey,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      color: hintTextColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18)
                  )
                )
              ),
              SizedBox(
                height: screenHeight * 0.05
              ),

              // Login button
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    if (nameController.text == "Bala") {
                      employeeName = nameController.text;
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => HomePage(employeeName: employeeName)
                      ));
                    } else if (nameController.text == "Esakki") {
                      employeeName = nameController.text;
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => HomePage(employeeName: employeeName)
                      ));
                    } else if (nameController.text == "Faraz") {
                      employeeName = nameController.text;
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => HomePage(employeeName: employeeName)
                      ));
                    } else if (nameController.text == "Shakthi") {
                      employeeName = nameController.text;
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => HomePage(employeeName: employeeName)
                      ));
                    } else {
                      setState(() {
                        nameController.clear();
                        hintText = "Enter a valid name";
                        hintTextColor = Colors.red;
                      });
                    }
                  } else {
                    setState(() {
                      hintTextColor = Colors.red;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  fixedSize: Size(screenWidth * 0.8, screenHeight * 0.07),
                  shape: const RoundedRectangleBorder()
                ),
                child: Text(
                  "Login",
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
                    color: Colors.white,
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
