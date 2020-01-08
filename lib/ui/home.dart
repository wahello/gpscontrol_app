import 'package:flutter/material.dart';
import 'package:GPS_CONTROL/common/CustomButton.dart';
import 'package:GPS_CONTROL/ui/login.dart';


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Image.asset(
              "assets/images/foody.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/logo2.png",width: 300,
                ),
                SizedBox(
                  height: 15.0,
                ),
                CustomButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  text: "Iniciar Sesion",
                  color: Colors.blue,
                  width: 250.0,
                ),
                SizedBox(
                  height: 5.0,
                ),
                CustomButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  text: "Sin Conexion",
                  color: Colors.black,
                  width: 250.0,
                ),
                SizedBox(
                  height: 50.0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}