import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';

class Utils {
  String name;

  IconData getIconForName(String iconName) {
    switch (iconName) {
      case '0':
        {
          return FontAwesomeIcons.idCard;
        }
      case '1':
        {
          return FontAwesomeIcons.idBadge;
        }
        break;
      case '2':
        {
          return FontAwesomeIcons.question;
        }
        break;
      case '3':
        {
          return FontAwesomeIcons.volumeUp;
        }
        break;
      case '4':
        {
          return FontAwesomeIcons.tachometerAlt;
        }
        break;
      case '5':
        {
          return FontAwesomeIcons.userCircle;
        }
        break;
      case '6':
        {
          return FontAwesomeIcons.userCheck;
        }
        break;
      case '7':
        {
          return FontAwesomeIcons.tools;
        }
        break;
      case '8':
        {
          return FontAwesomeIcons.toolbox;
        }
        break;
      case '9':
        {
          return FontAwesomeIcons.lowVision;
        }
        break;
      case '10':
        {
          return FontAwesomeIcons.fireExtinguisher;
        }
        break;
      case '11':
        {
          return FontAwesomeIcons.medkit;
        }
        break;
      case '12':
        {
          return FontAwesomeIcons.replyAll;
        }
        break;
      case '13':
        {
          return FontAwesomeIcons.car;
        }
        break;
      case '14':
        {
          return FontAwesomeIcons.compressArrowsAlt;
        }
        break;
      case '15':
        {
          return FontAwesomeIcons.searchengin;
        }
        break;
      case '16':
        {
          return FlatIcons.stopwatch;
        }
        break;
      case '17':
        {
          return FontAwesomeIcons.carBattery;
        }
        break;
      case '18':
        {
          return FontAwesomeIcons.carCrash;
        }
        break;
      case '19':
        {
          return FontAwesomeIcons.circleNotch;
        }
        break;
      case '20':
        {
          return FontAwesomeIcons.gasPump;
        }
        break;
      case '21':
        {
          return FontAwesomeIcons.levelDownAlt;
        }
        break;
      case '22':
        {
          return FontAwesomeIcons.filter;
        }
        break;
      case '23':
        {
          return FontAwesomeIcons.water;
        }
        break;
      case '24':
        {
          return FontAwesomeIcons.solidStopCircle;
        }
        break;
      case '25':
        {
          return FontAwesomeIcons.userTimes;
        }
        break;
      case '26':
        {
          return FontAwesomeIcons.airbnb;
        }
        break;
      case '27':
        {
          return FontAwesomeIcons.trafficLight;
        }
        break;
      case '28':
        {
          return FontAwesomeIcons.accessibleIcon;
        }
        break;
      case '29':
        {
          return FontAwesomeIcons.alignCenter;
        }
        break;
      case '30':
        {
          return FontAwesomeIcons.envira;
        }
        break;
      case '31':
        {
          return FontAwesomeIcons.mobileAlt;
        }
        break;
      case '32':
        {
          return FontAwesomeIcons.flagCheckered;
        }
        break;
      default:
        {
          return FontAwesomeIcons.home;
        }
    }
  }
}
