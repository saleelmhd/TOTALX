import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totalx/View/HOMEPAGE/homepage.dart';
import 'package:totalx/View/LOGIN/verify.dart';

class GetOTP extends StatefulWidget {
  const GetOTP({super.key});

  @override
  _GetOTPState createState() => _GetOTPState();
}

class _GetOTPState extends State<GetOTP> {
  TextEditingController _phoneNumberController = TextEditingController();

  final key = GlobalKey<FormState>();

 final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initiatePhoneVerification(BuildContext context) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '$selectedcountrycode${_phoneNumberController.text}',
        verificationCompleted: (PhoneAuthCredential credential) {
          signInWithPhoneCredential(context, credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Verification failed: ${e.message}'),
            ),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          // Navigate to OTP screen after code is sent
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyOTP(
                    verificationid: verificationId,
                    mobilenumber:
                        '$selectedcountrycode${_phoneNumberController.text}')),
          );
        },timeout: Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }
 Future<void> storePhoneNumber(String phoneNumber) async {
  try {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      'phoneNumber': phoneNumber,
       'id':_auth.currentUser!.uid,
    });
  } catch (e) {
    print('Error storing phone number: $e');
  }
}

// Function to sign in with phone credential
  Future<void> signInWithPhoneCredential(
      BuildContext context, PhoneAuthCredential credential) async {
    try {
      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      // Check if the user is signed in
      if (authResult.user != null) {
          await storePhoneNumber(authResult.user!.phoneNumber!);
//User signed in successfully, navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(),
          ),
        );
      } else {
        // Handle sign in failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in failed'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  final selectedcountrycode = '+91';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(key: key,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Center(
                      child: SizedBox(
                    height: 100,
                    width: 150,
                    child: Image.asset('images/getotp.png'),
                  )),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Enter Phone Number',
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField( autofillHints: [AutofillHints.oneTimeCode],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Phone Number';
                      }
                      return null;
                    },
                  
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Enter Phone Number',
                        labelStyle: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w300, fontSize: 10),
                        enabledBorder: OutlineInputBorder(
                          // Set border color when TextField is not focused
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 0.3,
                          ), // You may keep it red or change it to another color
                        ),
                      )),
                  const SizedBox(height: 20.0),
                  RichText(
                    text: TextSpan(
                      text: 'By Continuing, I agree to TotalX’s ',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: Colors.black,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: 'Terms and condition ',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue,
                          ),
                        ),
                        TextSpan(
                          text: '& ',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'privacy policy',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          MediaQuery.of(context).size.width,
                          40,
                        ),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white),
                    onPressed:()async{
                       if (key.currentState!.validate()) {
                      // try {
                      //   await FirebaseAuth.instance.verifyPhoneNumber(
                      //     phoneNumber:
                      //         '${selectedcountrycode + _phoneNumberController.text}',
                      //     verificationCompleted:
                      //         (PhoneAuthCredential credential) {},
                      //     verificationFailed: (FirebaseAuthException e) {},
                      //     codeSent: (String verificationId, int? resendToken) {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => OtpScreen(
                      //               verificationid: verificationId,
                      //               mobilenumber:
                      //                   '$selectedcountrycode${_phoneNumberController.text}',
                      //             ),
                      //           ));
                      //       log('the phone credial block enter ');
                      //     },
                      //     codeAutoRetrievalTimeout: (String verificationId) {},
                      //   );
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //       duration: Duration(seconds: 2),
                      //       content: Text('otp send succes')));
                      // } catch (e) {
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //       duration: Duration(seconds: 3),
                      //       content: Text('error$e')));
              
                      //   log('errro $e');
                      // }
                      await initiatePhoneVerification(context);
                    }
                    },
                    child: const Text('Get OTP'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
