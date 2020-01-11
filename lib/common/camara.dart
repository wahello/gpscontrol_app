import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:EnlistControl/models/caption.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';


// Una pantalla que permite a los usuarios tomar una fotografía utilizando una cámara determinada.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final Caption caption;

  TakePictureScreen({this.caption,Key key,@required this.camera,}) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Caption caption;
  Future<void> _initializeControllerFuture;

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
      appBar: AppBar(title: Text('Tomar evidencia')),
      // Debes esperar hasta que el controlador se inicialice antes de mostrar la vista previa
      // de la cámara. Utiliza un FutureBuilder para mostrar un spinner de carga
      // hasta que el controlador haya terminado de inicializar.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Si el Future está completo, muestra la vista previa
            return CameraPreview(_controller);
          } else {
            // De lo contrario, muestra un indicador de carga
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
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
            MaterialPageRoute(builder: (context) =>DisplayPictureScreen(caption: caption)));
            if (result.toString()!=''){
              caption.setDesc(result);
              Navigator.pop(context, caption);
            }else{
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
  DisplayPictureScreen({this.caption,Key key,}) : super(key: key);

  final myController = TextEditingController();

  String _get_base64image(String imageFilePath){
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
    final upper_header = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50),
          ),
          new Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.circular(70.0),
            ),
            padding: EdgeInsets.all(8.0),
            child: Image.file(File(caption.imagePath)),
          ),
          Padding(padding: EdgeInsets.only(top: 5.0, bottom: 5.0)),
          Text(
            'Casi terminamos!',
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 2.0, bottom: 2.0)),
          Text(
            'Por favor agrega una descripcion',
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 14,
              color: Colors.white,
            ),
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
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if(val.length <= 1) {
                    return "La descripcion no puede estar vacia.";
                  }else{
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
                desc= myController.text;
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
  }

}