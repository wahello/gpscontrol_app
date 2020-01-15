import 'package:flutter/material.dart';
import 'package:EnlistControl/common/CustomButton.dart';
import 'package:EnlistControl/ui/login.dart';
import 'package:connectivity/connectivity.dart';
import 'package:toast/toast.dart';


class Home extends StatelessWidget {
  bool online;

  Future<String> verifyConexion(BuildContext context) async {
     var connectivityResult = await (Connectivity().checkConnectivity());
     if (connectivityResult == ConnectivityResult.mobile) {
       online = true;
       Toast.show("Estas conectado a datos moviles.", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
     }else if (connectivityResult == ConnectivityResult.wifi) {
       online = true;
       Toast.show("Estas conectado a WIFI.", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
     }else{
       online = false;
       Toast.show("Estas sin conexion", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
     }
     return null;
  }

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
                  "assets/logo2.png",
                  width: 300,
                ),
                SizedBox(
                  height: 15.0,
                ),
                FutureBuilder(
                  future: verifyConexion(context),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CustomButton(
                              onPressed: () {
                                if(online!=null){
                                  if(online==false){
                                    Toast.show("Estas sin conexion. Intenta Reconectarte.", context,
                                          duration: 5, gravity: Toast.BOTTOM);
                                  }else{
                                    Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => WebviewLogin("http://tracking.gpscontrolcolombia.com/login.html")));
                                  }
                                }
                              },
                              text: "Iniciar Sesion",
                              color: online==true?Colors.blue:Colors.grey,
                              width: 250.0,
                            );
                    } else if (snapshot.hasError) {
                      throw snapshot.error;
                    } else {
                       CircularProgressIndicator();
                    }
                  },
                ),
                SizedBox(
                  height: 25.0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
