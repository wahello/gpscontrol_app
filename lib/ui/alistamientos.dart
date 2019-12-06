import 'dart:convert';
import '../models/users.dart';
import '../common/wialon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AlistamientoScreen extends StatefulWidget {
  static const routeName = '/alistamientos';
  @override
  createState() => _AlistamientoScreenState();
}

class _AlistamientoScreenState extends State {
  var users = new List<User>();

  _getUsers() {
    API.getUsers().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        users = list.map((model) => User.fromJson(model)).toList();
      });
    });
  }

  initState() {
    super.initState();
    _getUsers();
  }

  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Alistamientos"),
        ),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final usuario = users[index].name;
            final id = users[index].id;
            return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigoAccent,
                    child: Text('$id'),
                    foregroundColor: Colors.white,
                  ),
                  title: Text('$usuario'),
                  subtitle: Text('SlidableDrawerDelegate'),
                ),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'OK',
                  color: Colors.green,
                  icon: Icons.assignment_turned_in,
                  onTap: () => {},
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Tomar Foto',
                  color: Colors.red,
                  icon: Icons.add_a_photo,
                  onTap: () => {},
                ),
              ],
            );
          },
        ));
  }
}
