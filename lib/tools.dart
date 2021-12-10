import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF2ECD77);
Color kSecondaryColor = const Color(0xFFFEFF66).withOpacity(.8);
const Color kNormalColor = Color(0xFF000000);
const Color kTextColor = Color(0xFF5E6762);
const Color kBackColor = Color(0xFFCBF1DD);
const TextStyle kPrimaryText = TextStyle(
    color: kPrimaryColor,
    fontFamily: "Noto",
    fontSize: 25,
    fontWeight: FontWeight.w900);

const TextStyle kPrimaryTextWhite = TextStyle(
    color: Colors.white,
    fontFamily: "Noto",
    fontSize: 25,
    fontWeight: FontWeight.w900);

const TextStyle kPrimaryTextWhiteSmall = TextStyle(
    color: Colors.white,
    fontFamily: "Noto",
    fontSize: 18,
    fontWeight: FontWeight.w900);

const TextStyle kPrimaryTextSmall = TextStyle(
    color: kTextColor,
    fontFamily: "Noto",
    fontSize: 18,
    fontWeight: FontWeight.w900);

const TextStyle kBoldTextWhite = TextStyle(
    color: Colors.white,
    fontFamily: "Noto",
    fontSize: 18,
    fontWeight: FontWeight.bold);
const TextStyle kBoldTextPrimaryColor = TextStyle(
    color: kPrimaryColor,
    fontFamily: "Noto",
    fontSize: 18,
    fontWeight: FontWeight.bold);

const TextStyle kBoldText =
    TextStyle(fontFamily: "Noto", fontSize: 17, fontWeight: FontWeight.bold);

const InputDecoration inputStyle = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  labelStyle: TextStyle(color: kTextColor, fontFamily: "Noto"),
  hintStyle: TextStyle(fontFamily: "Noto", fontWeight: FontWeight.w600),
  contentPadding: EdgeInsets.all(12),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kTextColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

const TextStyle kBold = TextStyle(
    color: kTextColor,
    fontFamily: "Noto",
    fontSize: 15,
    fontWeight: FontWeight.w600);
const TextStyle kBoldWhite = TextStyle(
    color: Colors.white,
    fontFamily: "Noto",
    fontSize: 15,
    fontWeight: FontWeight.w600);
const TextStyle kBoldBlack = TextStyle(
    color: Colors.black,
    fontFamily: "Noto",
    fontSize: 20,
    fontWeight: FontWeight.w600);
