import 'package:GPS_CONTROL/models/pseudouser.dart';
import 'package:GPS_CONTROL/ui/init_alistamiento.dart';
import 'package:flutter/widgets.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  String navigateScreen;
  String imagePath;
  static PseudoUser user;

  setPseudoUser(PseudoUser user){
    user = user;
  }

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/hotel/hotel_booking.png',
      navigateScreen: '/init_alistamiento',
    ),
    HomeList(
      imagePath: 'assets/fitness_app/fitness_app.png',
      navigateScreen: '/',
    ),
    HomeList(
      imagePath: 'assets/design_course/design_course.png',
      navigateScreen: '/',
    ),
  ];
}
