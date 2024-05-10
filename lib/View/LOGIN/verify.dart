import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:totalx/View/HOMEPAGE/homepage.dart';

class VerifyOTP extends StatelessWidget {
  final String verificationid;
  final String mobilenumber;
  VerifyOTP({
    super.key,
    required this.verificationid,
    required this.mobilenumber,
  });
  final _formState = GlobalKey<FormState>();
  final otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formState,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset('images/verify.png'),
                ),
                Row(
                  children: [
                    Text(
                      'OTP Verification',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Enter the verification code we just sent to your number +91 *******21.',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400, fontSize: 12),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 60, width: MediaQuery.of(context).size.width,
                  // color: Colors.blue,
                  child: Pinput(
                    length: 6,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "enter otp";
                      } else {
                        return null;
                      }
                    },
                    controller: otpController,
                    defaultPinTheme: PinTheme(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                              width: 1,
                              style: BorderStyle.solid,
                              color: Colors.grey.shade300,
                            )
                            // border: Border.all(),
                            )),
                    // preFilledWidget: SizedBox(
                    //   height: 4.5.h,
                    //   width: 10.w,
                    // ),
                    // border: Border.all(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't Get OTP ? ",
                      style: GoogleFonts.montserrat(fontSize: 11),
                    ),
                    Text(
                      "Resend",
                      style: GoogleFonts.montserrat(fontSize: 11,color:Colors.blue),
                    ),
                  ],
                ),  const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          MediaQuery.of(context).size.width,
                          40,
                        ),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      if (_formState.currentState!.validate()) {
                        // verifyotp(context);
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationid,
                                smsCode: otpController.text);
            
                        // Sign the user in (or link) with the credential
                        await _auth.signInWithCredential(credential);
                        await storePhoneNumber(
                            mobilenumber);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Homepage(),
                            ));
                      }
                    },
                    child: const Text(
                      "Verify",
                    )),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Future<void> storePhoneNumber(String phoneNumber) async {
  try {
    String? uid = _auth.currentUser?.uid; // Get current user's UID, may be null
    if (uid != null) {
      await _firestore.collection('users').doc(uid).set({
        'phoneNumber': phoneNumber,
        'id': uid,
      });
      print('Phone number stored successfully.');
    } else {
      print('Error storing phone number: Current user is null');
    }
  } catch (e) {
    print('Error storing phone number: $e');
  }
}


}
