import 'package:autoly_service/providers/auth_provider.dart';
import 'package:autoly_service/ui/marketPlace/view/market_place_view.dart';
import 'package:autoly_service/utils/common_const.dart';
import 'package:autoly_service/utils/theme_const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../utils/shared_preferences/shared_preferences_helper.dart';

class LoginApiView extends StatefulWidget {
  const LoginApiView({Key key}) : super(key: key);

  @override
  _LoginApiViewState createState() => _LoginApiViewState();
}

class _LoginApiViewState extends State<LoginApiView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _userEmailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  void _login() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      AuthProvider _authProv =
          Provider.of<AuthProvider>(context, listen: false);
      _authProv.setLoading();

      await _authProv
          .login(
        // *********  static values for fast login  *********
        email: "mohamed.ahmed8902@gmail.com",
        password: "testuser123#",
        // email: _emailController.text.trim().toString(), // "mohamed.ahmed8902@gmail.com",
        // password: _passwordController.text.trim().toString(), // "testuser123#",
      )
          .then((value) {
        _authProv.setLoading();
        if (value == null) {
          print('##### value is null}');
          _emailController.clear();
          _passwordController.clear();
        } else {
          print('##### ${value.data.token}');
          // here we should save user from values
          print('##### id is ${value.data.id}}');
          SharedPreferencesHelper.setVal("id", value.data.id);
          SharedPreferencesHelper.setVal("token", value.data.token);
          SharedPreferencesHelper.setVal("user", value);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => const MarketPlaceView(
                      // userPhone: _userPhone,
                      )));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        buildHeaderWithImage(context),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: const Text("Sign in",
              style: TextStyle(
                  color: dusk,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.normal,
                  fontSize: 32.0),
              textAlign: TextAlign.left),
        ),
        SizedBox(
          height: 20.getHeight(),
        ),
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: width * 0.85,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        focusNode: _userEmailFocus,
                        style: TextStyle(
                            color: Colors.black, fontSize: 20.getFontSize()),
                        decoration: InputDecoration(
                          hintText: 'email@gmail.com',
                          hintStyle: TextStyle(
                              color: Colors.grey, fontSize: 20.getFontSize()),
                          filled: true,
                          fillColor: whiteTwo,
                          //warmGrey,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: waterBlue),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: waterBlue),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email address.!';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.getHeight(),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: width * 0.85,
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black, fontSize: 20.getFontSize()),
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Your password',
                            hintStyle: TextStyle(
                                color: Colors.grey, fontSize: 20.getFontSize()),
                            filled: true,
                            fillColor: whiteTwo,
                            //warmGrey,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(
                                color: waterBlue,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: waterBlue,
                              ),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          focusNode: _passwordFocus,
                          validator: (value) {
                            if (value.isEmpty || value.length < 7) {
                              return 'Password must be at least 7 characters long.';
                            }
                            return null;
                          },
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                        )),
                    SizedBox(
                      height: 30.getHeight(),
                    ),
                    Consumer<AuthProvider>(
                      builder: (ctx, authprov, child) => authprov.loading
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                              height: 50,
                              width: width * 0.85,
                              //   padding: EdgeInsets.all(10.0),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  side: const BorderSide(color: Color(0xff0fa2cf)),
                                ),
                                onPressed: () async {
                                  _login();
                                },
                                color: const Color(0xff0fa2cf),
                                textColor: Colors.white,
                                child: Text("Sign in ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Grandstander",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 30.getFontSize()),
                                    textAlign: TextAlign.left),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 30.getHeight(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
