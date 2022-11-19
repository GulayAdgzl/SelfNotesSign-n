import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note/src/string.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../service/auth_servis.dart';
import '../src/colors.dart';
import 'home.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isVisible = true;
  bool isLoading = false;

  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "SIGN IN",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.alternate_email,
                            color: SelfColors.kPrimaryColor,
                          ),
                        ),
                        Expanded(
                          child: _emailTextFiald(),
                        )
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.lock,
                          color: SelfColors.kPrimaryColor,
                        ),
                      ),
                      Expanded(
                        child: _passTextField(),
                      ),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(16), child: _loginButton()),
                        SizedBox(height: 10),
                        Container(
                          child: _googleLogButton(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InkWell _googleLogButton() {
    return InkWell(
      onTap: () => _loginWithGoogle(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 2),
            color: Colors.red,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: _googleButtonBody(),
        ),
      ),
    );
  }

  ElevatedButton _loginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: 24),
        maximumSize: Size.fromHeight(46),
        shape: StadiumBorder(),
        backgroundColor: Colors.white.withOpacity(.5),
      ),
      child: isLoading
          ? CircularProgressIndicator(color: SelfColors.orange)
          : Text(SelfText.signup),
      onPressed: () {
        _loginWithEmail();
        if (isLoading) return;
        setState(() => isLoading = true);
      },
    );
  }

  TextField _passTextField() {
    return TextField(
      controller: _passwordController,
      obscureText: _isVisible ? true : false,
      decoration: InputDecoration(
        suffixIcon: InkWell(
          onTap: () {
            if (_isVisible) {
              setState(() {
                _isVisible = false;
              });
            } else {
              setState(() {
                _isVisible = false;
              });
              _isVisible = true;
            }
          },
          child: _isVisible
              ? Icon(
                  Icons.remove_red_eye,
                  color: Colors.orange,
                )
              : Icon(
                  Icons.remove_red_eye_outlined,
                  color: Colors.orange,
                ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: SelfText.password,
      ),
    );
  }

  TextField _emailTextFiald() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: SelfText.email,
      ),
    );
  }

  Center _googleButtonBody() {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
          FontAwesomeIcons.google,
          color: Colors.white,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          SelfText.googleLogin,
          style: TextStyle(color: Colors.white),
        ),
      ],
    ));
  }

  void _loginWithGoogle() {
    _authService.signInWithGoogle().then((value) {
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
          (route) => false);
    });
  }

  InkWell _errorButton() {
    return InkWell(
        onTap: () => _errorButtonOnTap(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 40,
          child: Center(
            child: Text(
              'SelfText.crashlytics',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ));
  }

  void _errorButtonOnTap() {
    FirebaseCrashlytics.instance.crash();
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FirebaseCrashlytics.instance.setCustomKey('str_key', 'hello');
  }

  void _loginWithEmail() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      _authService
          .signInWithEmail(
        _emailController.text,
        _passwordController.text,
      )
          .then((value) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      }).catchError((error) {
        if (error.toString().contains('invalid-email')) {
          _warningToast(SelfText.loginWrongEmailText);
        } else if (error.toString().contains('user-not-found')) {
          _warningToast(SelfText.loginNoAccountText);
        } else if (error.toString().contains('wrong-password')) {
          _warningToast(SelfText.loginWrongPasswordText);
        } else {
          _warningToast(SelfText.errorText);
        }
      }).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    } else {
      _warningToast(SelfText.emptyText);
    }
  }

  Future<bool?> _warningToast(String text) {
    return Fluttertoast.showToast(
        msg: text,
        timeInSecForIosWeb: 2,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14);
  }
}
