import 'dart:async';

import 'package:GPS_CONTROL/models/users.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/transition_route_observer.dart';
import '../widgets/fade_in.dart';
import '../common/constants.dart';
import '../widgets/round_button.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:GPS_CONTROL/models/post.dart';

class DashboardScreen extends StatefulWidget {
  //final User userdata;
  //DashboardScreen({this.userdata});
  static const routeName = '/dashboard';
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  Post post;
  User baseUser;
  String ssap;
  String username = "";
  String token = "";
  var uri = "https://hst-api.wialon.com/wialon/ajax.html?svc=token/login&params={%22token%22:%22";
  var arg = "%22,%22operateAs%22:%22";
  var endless = "%22}";  //User base_user;
  SharedPreferences preferences;
  final routeObserver = TransitionRouteObserver<PageRoute>();
  static const headerAniInterval =
      const Interval(.1, .3, curve: Curves.easeOut);
  Animation<double> _headerScaleAnimation;
  AnimationController _loadingController;

  Future<bool> _goToLogin(BuildContext context) {
    preferences.clear();
    return Navigator.of(context)
        .pushReplacementNamed('/')
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  Future <User> getPrefs() async {
    preferences =  await SharedPreferences.getInstance();
    //base_user.name = preferences.getString('user');
    //base_user.passwd = preferences.getString('ssap');
    username = preferences.getString('user');
    ssap = preferences.getString('ssap');
    token = preferences.getString('token');
    baseUser = new User(token, username, username, ssap);
    print('Se obtuvo satisfactoriamente los siguientes valores ...');
    print('usuario: '+username+' pass: '+ssap+' token: '+token);
    _getDatawialon();
    return baseUser;
  }

  @override
  void initState() {
    print('entramos al metodo init state Dash');
    getPrefs().then((User user){
      
    });
    super.initState();
    // aqui se setea la info de usuario guardada para mostrar en dashboar base_user = widget.data;
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _headerScaleAnimation =
        Tween<double>(begin: .6, end: 1).animate(CurvedAnimation(
      parent: _loadingController,
      curve: headerAniInterval,
    ));
  }


  Future<dynamic> _getVehiclesWialon() async {
      String url = "https://hst-api.wialon.com/wialon/ajax.html?svc=core/search_items&params={%22spec%22:{%22itemsType%22:%22avl_unit%22,%22propName%22:%22trailers%22,%22propValueMask%22:%22%22,%22sortType%22:%22trailers%22,%22propType%22:%22propitemname%22},%22force%22:1,%22flags%22:4097,%22from%22:0,%22to%22:0}&sid=";
      Response res = await get(url+post.eid);

    if (res.statusCode == 200) {
      var bodyfull = await jsonDecode(res.body);
      print(bodyfull);
      return bodyfull ;
    } else {
      print('pailas');
      throw "Can't get posts.";
    }
  }
  
  Future<String> _getDatawialon() async {
    Response res = await get(uri+token+arg+username+endless);
    if (res.statusCode == 200) {
      var bodyfull = jsonDecode(res.body);
      var body = bodyfull['user'];
      print(bodyfull['user']);
      print(body['id']);
      print(preferences.getString('token'));
      post = new Post(
        eid: bodyfull['eid'],
        giSid:bodyfull['gis_sid'] ,
        au:bodyfull['au'] ,
        tm: bodyfull['tm'],
        username: body['nm'],
        userId: body['id'],
        token: token, );
    } else {
      print('pailas');
      throw "Can't get posts.";
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _loadingController.dispose();
    super.dispose();
  }

  @override
  void didPushAfterTransition() => _loadingController.forward();

  AppBar _buildAppBar(ThemeData theme) {
    final menuBtn = IconButton(
      color: Colors.blue,
      icon: const Icon(FontAwesomeIcons.bars),
      onPressed: () => _goToLogin(context),
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color: Colors.blue,
      onPressed: () => _goToLogin(context),
    );
    final title = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Hero(
              tag: Constants.logoTag,
              child: Image.asset(
                'assets/logo1.png',
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ],
      ),
    );

    return AppBar(
      leading: FadeIn(
        child: menuBtn,
        controller: _loadingController,
        offset: .3,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.startToEnd,
      ),
      actions: <Widget>[
        FadeIn(
          child: signOutBtn,
          controller: _loadingController,
          offset: .3,
          curve: headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
        ),
      ],
      title: title,
      backgroundColor: theme.primaryColor.withOpacity(.1),
      elevation: 0,
      textTheme: theme.accentTextTheme,
      iconTheme: theme.accentIconTheme,
    );
  }
  initUser(){
    //base_user.name = '';
    //base_user.passwd = '';
  }
  Widget _buildHeader(ThemeData theme) {
    print('se imprimio primero -- build header');


    return ScaleTransition(
      scale: _headerScaleAnimation,
      child: FadeIn(
        controller: _loadingController,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.bottomToTop,
        offset: .5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Bienvenido ', style: theme.textTheme.caption),
            Padding(
              padding: EdgeInsets.all(2),
              child: Column(
                children: <Widget>[
                  //Text('user: '+ post.username==null ? "" : post.username),
                  //Text('sid: '+post.eid==null ? "" : post.eid),
                  //Text('id_wialon: '+post.userId.toString()==null ? "" : post.userId),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildButton({Widget icon, String label, Interval interval}) {
    return RoundButton(
      icon: icon,
      label: label,
      loadingController: _loadingController,
      interval: Interval(
        interval.begin,
        interval.end,
        curve: ElasticOutCurve(0.42),
      ),
      onPressed: () {},
    );
  }
  Widget _buildButton1({Widget icon, String label, Interval interval}) {
    return RoundButton(
      icon: icon,
      label: label,
      loadingController: _loadingController,
      interval: Interval(
        interval.begin,
        interval.end,
        curve: ElasticOutCurve(0.42),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/init_alist');
      },
    );
  }

  Widget _buildButton2({Widget icon, String label, Interval interval}) {
    return RoundButton(
      icon: icon,
      label: label,
      loadingController: _loadingController,
      interval: Interval(
        interval.begin,
        interval.end,
        curve: ElasticOutCurve(0.42),
      ),
      onPressed: () {
        _getVehiclesWialon();
        Navigator.pushNamed(context, '/init_alist');
      },
    );
  }

  Widget _buildDashboardGrid() {
    const step = 0.04;
    const aniInterval = 0.75;

    return GridView.count(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 20,
      ),
      childAspectRatio: .9,
      // crossAxisSpacing: 5,
      crossAxisCount: 3,
      children: [
        _buildButton(
          icon: Icon(FontAwesomeIcons.user),
          label: 'Perfil',
          interval: Interval(0, aniInterval),
        ),
        _buildButton1(
          icon: Icon(Icons.assignment),
          label: 'Alistamiento',
          interval: Interval(step, aniInterval + step),
        ),
        _buildButton2(
          icon: Icon(FontAwesomeIcons.history),
          label: 'Historial',
          interval: Interval(step * 2, aniInterval + step * 2),
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.ellipsisH),
          label: 'Other',
          interval: Interval(0, aniInterval),
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.search, size: 20),
          label: 'Buscar',
          interval: Interval(step, aniInterval + step),
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.slidersH, size: 20),
          label: 'Configuracion',
          interval: Interval(step * 2, aniInterval + step * 2),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () => _goToLogin(context),
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(theme),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.primaryColor.withOpacity(.1),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 40),
                    Expanded(
                      flex: 2,
                      child: _buildHeader(theme),
                    ),
                    Expanded(
                      flex: 8,
                      child: ShaderMask(
                        // blendMode: BlendMode.srcOver,
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            tileMode: TileMode.clamp,
                            colors: <Color>[
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              // Colors.red,
                              // Colors.yellow,
                            ],
                          ).createShader(bounds);
                        },
                        child: _buildDashboardGrid(),
                      ),
                    ),
                  ],
                ),
                //if (!kReleaseMode) _buildDebugButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
