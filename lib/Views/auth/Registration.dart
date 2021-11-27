import 'package:church/ModelView/MyLogin.dart';
import 'package:church/Views/Widgets/CustomButton.dart';
import 'package:church/Views/Widgets/Header.dart';
import 'package:church/Views/auth/Choice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../tools.dart';
import 'OTP.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool otp = true, _loader = false;
  String _otpValue = " ", _verificationId = "", _error = "";
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _otp = TextEditingController();

  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final GlobalKey<FormState> key2 = GlobalKey<FormState>();
  bool _autoValidate = true;

  @override
  void dipose() {
    super.dispose();
    _otp.dispose();
    _phoneNumber.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            const Header(
              title: "Se Connecter",
              pad: true,
            ),
            const Spacer(),
            _loader
                ? const Center(
                    child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ))
                : Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 20),
                      child: otp
                          ? Form(
                              key: key,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller: _phoneNumber,
                                    validator: (value) {
                                      try {
                                        if (value!.isEmpty)
                                          return "le numéro  doit faire 9 chiffres";
                                        if (value.length != 9)
                                          return "le numéro  doit faire 9 chiffres";
                                        if (6000000000 < int.parse(value))
                                          return "le numéro est ne respecte pas les normes";
                                      } catch (e) {
                                        return "le numéro est invalide";
                                      }
                                    },
                                    decoration: inputStyle.copyWith(
                                        hintText: "Numéro de téléphone",
                                        prefixText: "+237 ",
                                        prefixIcon: const Icon(Icons.phone)),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomButton(
                                    title: "Connectez-vous!",
                                    onClick: () async {
                                      if (key.currentState!.validate()) {
                                        FocusScope.of(context).unfocus();

                                        String phone =
                                            _phoneNumber.value.text.trim();
                                        setState(() {
                                          _loader = !_loader;
                                        });

                                        try {
                                          await _auth.verifyPhoneNumber(
                                            phoneNumber: "+237" + phone,
                                            verificationCompleted:
                                                (PhoneAuthCredential
                                                    credential) async {
                                              await _auth.signInWithCredential(
                                                  credential);

                                              if (_auth.currentUser?.uid !=
                                                  null) {
                                                Navigator.pushNamed(
                                                    context, '/signIn');
                                              }
                                            },
                                            verificationFailed:
                                                (FirebaseAuthException e) {
                                              if (e.code ==
                                                  'invalid-phone-number') {
                                                print(
                                                    'The provided phone number is not valid.');
                                              }
                                            },
                                            codeSent: (String verificationId,
                                                int? resendToken) async {
                                              setState(() {
                                                _verificationId =
                                                    verificationId;
                                                _loader = !_loader;
                                                otp = !otp;
                                              });
                                            },
                                            codeAutoRetrievalTimeout:
                                                (String verificationId) {},
                                          );
                                        } catch (error) {
                                          setState(() {
                                            _error = "Une erreur est survenu";
                                          });
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ))
                          : Container(
                              // height: MediaQuery.of(context).size.height / 2.2,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: _loader
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                      color: kPrimaryColor,
                                    ))
                                  : Form(
                                      key: key2,
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          const Center(
                                            child: Text(
                                              "Confimer votre numéro de téléphone ",
                                              style: kBoldTextPrimaryColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.phone,
                                            controller: _otp,
                                            validator: (value) {
                                              try {
                                                if (value!.isEmpty) {
                                                  return "le code ne doit pas être vide";
                                                }
                                                if (value.length != 6) {
                                                  return "le code  doit faire 6 chiffres";
                                                }
                                              } catch (e) {
                                                return "le numéro est invalide";
                                              }
                                            },
                                            decoration: inputStyle.copyWith(
                                              hintText: "Ecrire le code",
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.8,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2.0,
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: CustomButton(
                                                title: "Confirmer",
                                                onClick: () async {
                                                  if (key2.currentState!
                                                      .validate()) {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    try {
                                                      PhoneAuthCredential
                                                          credential =
                                                          PhoneAuthProvider
                                                              .credential(
                                                                  verificationId:
                                                                      _verificationId,
                                                                  smsCode: _otp
                                                                      .value
                                                                      .text);
                                                      await _auth
                                                          .signInWithCredential(
                                                              credential);
                                                      setState(() {
                                                        _loader = _loader;
                                                      });

                                                      if (_auth.currentUser
                                                              ?.uid !=
                                                          null) {
                                                        Navigator.pushNamed(
                                                            context, '/signIn');
                                                      }
                                                    } catch (error) {
                                                      setState(() {
                                                        _error =
                                                            "Le code saisie est invalide";
                                                      });
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                    ),
                  ),
            const Spacer(
              flex: 2,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                _error.toString(),
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
