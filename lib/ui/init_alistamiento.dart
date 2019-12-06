import 'package:flutter/material.dart';
import 'package:GPS_CONTROL/data/services/odoo_api.dart';
import 'package:GPS_CONTROL/data/services/odoo_response.dart';
import 'package:GPS_CONTROL/data/services/utils.dart';
import 'package:GPS_CONTROL/pages/partner_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:GPS_CONTROL/pages/settings.dart';
import 'package:GPS_CONTROL/data/pojo/partners.dart';
import 'package:GPS_CONTROL/pages/profile.dart';

class InitAlistamiento extends StatefulWidget {
  InitAlistamiento({this.data});
  final data;
  static const routeName = '/init_alist';
  @override
  _InitAlistamientoState createState() => _InitAlistamientoState();
}

class _InitAlistamientoState extends State<InitAlistamiento> {
  Odoo _odoo;
  List<Partner> _partners = [];
  bool _isLoading = false;

  _getPartners() async {
    _isLoading = true;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _odoo = Odoo(url: preferences.getString("odooUrl"))
      ..searchRead("res.partner", [], []).then(
            (OdooResponse res) {
          if (!res.hasError()) {
            setState(() {
              _isLoading = false;
              String session = preferences.getString("session");
              session = session.split(",")[0].split(";")[0];
              for (var i in res.getRecords()) {
                _partners.add(
                  new Partner(
                    id: i["id"],
                    email: i["email"] is! bool ? i["email"] : "N/A",
                    name: i["name"],
                    phone: i["phone"] is! bool ? i["phone"] : "N/A",
                    imageUrl: preferences.getString("odooUrl") +
                        "/web/content?model=res.partner&field=image&" +
                        session +
                        "&id=" +
                        i["id"].toString(),
                  ),
                );
              }
            });
          } else {
            setState(() {
              _isLoading = false;
            });
            Utils(context: context)
                .showMessage("Warning", res.getErrorMessage());
          }
        },
      );
  }

  @override
  void initState() {
    super.initState();
    Utils().isConnected().then((isInternet) {
      if (!isInternet) {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: Text("No Internet Connection!")));
        setState(() {
          _isLoading = false;
        });
      }
    });
    //_getPartners();
  }

  @override
  Widget build(BuildContext context) {
    final emptyView = Container(
      alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.warning,
              color: Colors.grey.shade300,
              size: 100,
            ),
            Padding(
              padding: EdgeInsets.all(1.0),
              child: Text(
                "Alistamientos aun no disponibles",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Iniciar alistamiento"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Settings(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _partners.length > 0
          ? ListView.builder(
        itemCount: _partners.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, i) => InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PartnerDetails(
                  data: _partners[i],
                ),
              ),
            );
          },
          child: Column(
            children: <Widget>[
              Divider(
                height: 10.0,
              ),
              ListTile(
                leading: CircleAvatar(
                  foregroundColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                  NetworkImage(_partners[i].imageUrl),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _partners[i].name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                subtitle: Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    _partners[i].email,
                    style:
                    TextStyle(color: Colors.grey, fontSize: 15.0),
                  ),
                ),
              )
            ],
          ),
        ),
      )
          : emptyView,
    );
  }
}
