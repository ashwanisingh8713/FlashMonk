import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:monk_mvp/home/homePage.dart';


late final FirebaseAuth _auth;
late final GoogleSignIn _googleSignIn;
String? userName = "Meet Up";

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                userName!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: SignInButton(
                Buttons.Google,
                text: "Sign in/up with Google",
                onPressed: () {
                   getUserInfo(context);
                  // if (user?.displayName != null) {
                  //   setState(() {
                  //     userName = user?.displayName;
                  //   });
                  // }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn();
    _googleSignIn.signOut();
  }
}

void getUserInfo(BuildContext context) async{
User? user = await signInWithGoogle();
if(user!.displayName!.isNotEmpty){
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HomePageWether(user: user,)));
}
}

Future<User?> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

  final GoogleSignInAuthentication googleAuthentication =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuthentication.accessToken,
      idToken: googleAuthentication.idToken);
  final authResult = await _auth.signInWithCredential(credential);
  User? user = authResult.user;
  return user;
}
