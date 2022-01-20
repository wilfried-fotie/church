import 'package:church/ModelView/Invite.dart';
import 'package:church/ModelView/MyLogin.dart';
import 'package:church/Views/Widgets/CustomButton.dart';
import 'package:church/Views/Widgets/Header.dart';
import 'package:church/Views/auth/Choice.dart';
import 'package:church/Views/auth/SignIn.dart';
import 'package:church/helper/SharedPref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Services/UserServices.dart';
import '../../tools.dart';
import 'OTP.dart';
import 'UpdateProfil.dart';

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
        child: ListView(
          children: [
            const Header(
              title: "Se Connecter",
              pad: true,
            ),
            _loader
                ? const Center(
                    child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ))
                : Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 60),
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
                                            setState(() {
                                              _loader = false;
                                              otp = false;
                                            });
                                            if (e.code ==
                                                'invalid-phone-number') {
                                              setState(() {
                                                _error =
                                                    "Numéro de tel invalide";
                                              });
                                            }
                                          },
                                          codeSent: (String verificationId,
                                              int? resendToken) async {
                                            setState(() {
                                              _verificationId = verificationId;
                                              _loader = !_loader;
                                              otp = !otp;
                                            });
                                          },
                                          codeAutoRetrievalTimeout:
                                              (String verificationId) {},
                                        );
                                      } catch (error) {
                                        if (mounted) {
                                          setState(() {
                                            _error = "Une erreur est survenu";
                                          });
                                        }
                                      }
                                    }
                                  },
                                ),
                              ],
                            ))
                        : Container(
                            // height: MediaQuery.of(context).size.height / 2.2,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _loader
                                ? const Center(
                                    child: CircularProgressIndicator(
                                    color: kPrimaryColor,
                                  ))
                                : Form(
                                    key: key2,
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        const Center(
                                          child: Text(
                                            "Confimer votre numéro de téléphone ",
                                            style: kBoldTextPrimaryColor,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
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
                                                    BorderRadius.circular(20)),
                                            child: CustomButton(
                                              title: "Confirmer",
                                              onClick: () async {
                                                if (key2.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    _loader = true;
                                                  });
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
                                                  } catch (error) {
                                                    if (mounted) {
                                                      setState(() {
                                                        _error =
                                                            "Le code saisie est invalide";
                                                        _loader = false;
                                                      });
                                                    }
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        StreamBuilder<int>(
                                            stream: _stream,
                                            builder: (context, snapshot) {
                                              if (!_loader &&
                                                  snapshot.hasData &&
                                                  snapshot.data! < 5) {
                                                return Text(
                                                  "Si vous ne recevez pas le code au bout de 30 s reessayer " +
                                                      snapshot.data.toString() +
                                                      " seconds",
                                                  textAlign: TextAlign.center,
                                                );
                                              } else {
                                                return TextButton(
                                                    child: const Text(
                                                        "Essayez de nouveau"),
                                                    onPressed: () {
                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //       builder: (context) =>
                                                      //           const Registration()),
                                                      // );
                                                      setState(() {
                                                        otp = true;
                                                        _error = "";
                                                        _otp.text = "";
                                                      });
                                                    });
                                              }
                                            }),
                                      ],
                                    ),
                                  )),
                  ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                _error.toString(),
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
            const Text(
              "Mode Invité accéder à l'application sans vous enregistrer",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                alignment: Alignment.center,
                child: CustomButton(
                    title: "Mode Invité",
                    onClick: () async {
                      ProfilPreferences.toggleInvite();
                      context.read<Invite>().toggleStatus();
                    }))
          ],
        ),
      ),
    );
  }

  final Stream<int> _stream =
      Stream.periodic(const Duration(milliseconds: 1000), (value) => value);
}
