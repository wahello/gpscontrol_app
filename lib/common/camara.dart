import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:EnlistControl/models/caption.dart';
import 'package:EnlistControl/ui/custom_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
<<<<<<< HEAD
import 'package:EnlistControl/common/utils.dart';
import 'package:flutter_login/src/widgets/gradient_box.dart';
import 'package:EnlistControl/common/utils.dart';
=======
>>>>>>> master

// Una pantalla que permite a los usuarios tomar una fotografía utilizando una cámara determinada.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final Caption caption;

  TakePictureScreen({
    this.caption,
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Caption caption;
  Future<void> _initializeControllerFuture;
  Utils utils = new Utils();

  @override
  void initState() {
    super.initState();
    // Para visualizar la salida actual de la cámara, es necesario
    // crear un CameraController.
    _controller = CameraController(
      // Obtén una cámara específica de la lista de cámaras disponibles
      widget.camera,
      // Define la resolución a utilizar
      ResolutionPreset.medium,
    );

    // A continuación, debes inicializar el controlador. Esto devuelve un Future!
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Asegúrate de deshacerte del controlador cuando se deshaga del Widget.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Debes esperar hasta que el controlador se inicialice antes de mostrar la vista previa
      // de la cámara. Utiliza un FutureBuilder para mostrar un spinner de carga
      // hasta que el controlador haya terminado de inicializar.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Si el Future está completo, muestra la vista previa
            final size = MediaQuery.of(context).size;
            final deviceRatio = size.width / size.height;
            return Transform.scale(
              scale: _controller.value.aspectRatio / deviceRatio,
              child: Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: CameraPreview(_controller),
                ),
              ),
            );
          } else {
            // De lo contrario, muestra un indicador de carga
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffff0032),
        child: Icon(utils.getIconForName('foto'), size: 30.0,),
        // Agrega un callback onPressed
        onPressed: () async {
          // Toma la foto en un bloque de try / catch. Si algo sale mal,
          // atrapa el error.
          try {
            // Ensure the camera is initialized
            await _initializeControllerFuture;

            // Construye la ruta donde la imagen debe ser guardada usando
            // el paquete path.
            final path = join(
              //
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved
            await _controller.takePicture(path);
            // En este ejemplo, guarda la imagen en el directorio temporal. Encuentra
            // el directorio temporal usando el plugin `path_provider`.
            // ES DisplayPictureScreen(index: widget.index,imagePath: path);
            caption = widget.caption;
            caption.setImage(path);
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DisplayPictureScreen(caption: caption)));
            if (result.toString() != '') {
              caption.setDesc(result);
              Navigator.pop(context, caption);
            } else {
              Navigator.pop(context, 'algo salio mal..');
            }

            // After the Selection Screen returns a result, hide any previous snackbars
            // and show the new result.

          } catch (e) {
            // Si se produce un error, regístralo en la consola.
            print(e);
          }
        },
      ),
      
    );
  }
}

// Un Widget que muestra la imagen tomada por el usuario
class DisplayPictureScreen extends StatelessWidget {
  Caption caption;
  String desc;
  DisplayPictureScreen({
    this.caption,
    Key key,
  }) : super(key: key);

  final myController = TextEditingController();

  String _get_base64image(String imageFilePath) {
    File imageFile = File(imageFilePath);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    return base64Image;
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    myController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Utils utils = new Utils();

    return Scaffold(
      
        // resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            GradientBox(
              colors: [
                Color(0xff000000),
                Color(0xff282828),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
<<<<<<< HEAD
            SingleChildScrollView(
              child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      child: Container(
                        padding: new EdgeInsets.fromLTRB(25, 110, 25, 120),
                        child: Card(
                          color: Color(0x00ffffff),
                          elevation: 20.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                decoration: new BoxDecoration(
                                    color: Color(0xff464646),
                                    borderRadius: new BorderRadius.only(
                                        topLeft:  const  Radius.circular(60.0),
                                        topRight: const  Radius.circular(60.0)
                                        )
                                ),
                                height: 80,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 24, bottom: 20, left:40 , right: 40),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Agregue la descripción del problema que desea reportar.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "Roboto Condensed",
                                          color: Color(0xffdcdcdc),
                                          fontSize: 15)),
                                    ],
                                  ),
                                  ),
                              ),
                              Container(
                                decoration: new BoxDecoration(
                                    color: Color(0xff282828),
                                ),
                                height: 351,
                                child:Padding(
                                  padding: EdgeInsets.only(top: 30, bottom: 20, left:40 , right: 40),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                            width: 210.0,
                                            height: 210.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: FileImage(File(caption.imagePath),)
                                      )),
                                      ),

                                      Padding(padding: EdgeInsets.only(top:10)),
                                      Center(
                                          child: TextFormField(
                                            controller: myController,
                                            autovalidate: true,
                                            decoration: new InputDecoration(
                                              errorStyle: TextStyle(color: Color(0xffff0032)),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(40)),
                                                borderSide: BorderSide(color: Color(0xffff0032), width: 1)
                                                ),
                                              labelStyle: TextStyle(color: Colors.white30 , fontSize: 13),
                                              labelText: "Descripcion de Novedad",
                                              fillColor: Colors.white38,
                                              border: new OutlineInputBorder(
                                                borderRadius: new BorderRadius.circular(25.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            ),
                                            validator: (val) {
                                              if (val.length <= 1) {
                                                return "La descripcion no puede estar vacia.";
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardType: TextInputType.text,
                                            style: new TextStyle(
                                              color: Color(0xffffffff),
                                              fontFamily: "Poppins",
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  ),
                              ),
                              Container(
                                decoration: new BoxDecoration(
                                    color: Color(0xff00ff32),
                                    borderRadius: new BorderRadius.only(
                                        bottomLeft:  const  Radius.circular(60.0),
                                        bottomRight: const  Radius.circular(60.0)
                                        )
                                ),
                                height: 70,
                                child: Center(
                                  child: FlatButton(
                                    onPressed: () {
                                      /*...*/
                                      desc = myController.text;
                                      Navigator.pop(context, desc);
                                    },
                                    child: Text("Terminar",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black,
                                            fontSize: 19)),
                                    ),
                                ),
                              ),

                            ],
                          ),    
                        ), 
                      ),
                    ),
                    Positioned(
                      top: 30,
                      child: Image.asset("assets/logo2.png", 
                        width: 220,
                      ),
                    ),
                    
                  ],
                ),
              ),
          ],
        ),
      );
=======
          ),
          Padding(padding: EdgeInsets.only(top: 8.0, bottom: 35.0)),
        ],
      ),
    );

    final lower = Container(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Center(
              child: TextFormField(
                controller: myController,
                autovalidate: true,
                decoration: new InputDecoration(
                  labelText: "Descripcion",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if (val.length <= 1) {
                    return "La descripcion no puede estar vacia.";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: MaterialButton(
              child: Text(
                "Guardar",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.blue,
              onPressed: () {
                desc = myController.text;
                Navigator.pop(context, desc);
                //_saveURL(_urlCtrler.text);
              },
            ),
          )
        ],
      ),
    );

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 260.0,
              floating: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                background: upper_header,
              ),
            ),
          ];
        },
        body: lower,
      ),
    );
>>>>>>> master
  }
}
