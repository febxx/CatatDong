import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Icon setIcon(String title) {
  if (title == null) {
    return Icon(FontAwesomeIcons.random);
  }
  title = title.toLowerCase();

  switch (title) {
    case 'makanan':
      return Icon(FontAwesomeIcons.utensils);
      break;
    case 'game':
      return Icon(Icons.gamepad);
      break;
    case 'belanja':
      return Icon(FontAwesomeIcons.shoppingBag);
      break;
    case 'rumah':
      return Icon(FontAwesomeIcons.home);
      break;
    case 'kesehatan':
      return Icon(FontAwesomeIcons.briefcaseMedical);
      break;
    case 'telepon':
      return Icon(FontAwesomeIcons.phone);
      break;
    case 'pendidikan':
      return Icon(Icons.school);
      break;
    case 'gaji':
      return Icon(FontAwesomeIcons.wallet);
      break;
    case 'investasi':
      return Icon(FontAwesomeIcons.piggyBank);
      break;
    case 'lotre':
      return Icon(FontAwesomeIcons.dice);
      break;
    default:
      return Icon(FontAwesomeIcons.random);
  }
}