import 'package:e_trash/eTrashdetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_trash/etrash.dart';
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:e_trash/user.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'SlideRightRoute.dart';

double perpage = 1;

class TabScreen extends StatefulWidget {
  final User user;

  TabScreen({Key key, this.user});

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";
  List data;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    
   SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepOrange));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
           
            body: RefreshIndicator(
              key: refreshKey,
              color: Colors.deepOrange,
              onRefresh: () async {
                await refreshList();
              },
              child: ListView.builder(
                  //Step 6: Count the data
                  itemCount: data == null ? 1 : data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Stack(children: <Widget>[
                              Image.asset(
                                "assets/images/back.png",
                                fit: BoxFit.fitWidth,
                              ),
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Text("E-Trash",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 300,
                                    height: 140,
                                    child: Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.person,
                                                    ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    widget.user.name
                                                            .toUpperCase() ??
                                                        "Not registered",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.location_on,
                                                    ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(_currentAddress),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.rounded_corner,
                                                    ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                      "Item Radius within " +
                                                          widget.user.radius +
                                                          " KM"),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.credit_card,
                                                  ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text("You have " +
                                                      widget.user.credit +
                                                      " Credit"),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              color: Colors.deepOrange,
                              child: Center(
                                child: Text("Items Available",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (index == data.length && perpage > 1) {
                      return Container(
                        width: 250,
                        color: Colors.white,
                        child: MaterialButton(
                          child: Text(
                            "Load More",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {},
                        ),
                      );
                    }
                    index -= 1;
                    return Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 2,
                        child: InkWell(
                          onTap: () => _onETrashDetail(
                            data[index]['etid'],
                            data[index]['etprice'],
                            data[index]['etdesc'],
                            data[index]['etowner'],
                            data[index]['etimage'],
                            data[index]['ettime'],
                            data[index]['ettitle'],
                            data[index]['etlatitude'],
                            data[index]['etlongitude'],
                            data[index]['etrating'],
                            widget.user.radius,
                            widget.user.name,
                            widget.user.credit,
                          ),
                          onLongPress: _onETrashDelete,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white),
                                      image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                    "http://itschizo.com/aidil_qayyum/etrash/images/${data[index]['etimage']}.jpg"
                                  )))),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            data[index]['ettitle']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        RatingBar(
                                          itemCount: 5,
                                          itemSize: 12,
                                          initialRating: double.parse(
                                            data[index]['etrating']
                                                .toString()),
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("RM " + data[index]['etprice']),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(data[index]['ettime']),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )));
  }

  _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality},${place.postalCode},${place.country}";
        init();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> makeRequest() async {
    String urlLoadETs = "http://itschizo.com/aidil_qayyum/etrash/php/load_items.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Items");
    pr.show();
    http.post(urlLoadETs, body: {
      "email": widget.user.email ?? "notavail",
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
      "radius": widget.user.radius ?? "15",
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["etrash"];
        perpage = (data.length / 10);
        print("data");
        print(data);
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  Future init() async {
    this.makeRequest();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  void _onETrashDelete() {
    print("Delete");
  }

  void _onETrashDetail(
      String etid,
      String etprice,
      String etdesc,
      String etowner,
      String etimage,
      String ettime,
      String ettitle,
      String etlatitude,
      String etlongitude,
      String etrating,
      String email,
      String name,
      String credit) {
        Etrash etrash = new Etrash(
        etid: etid,
        ettitle: ettitle,
        etowner: etowner,
        etdesc: etdesc,
        etprice: etprice,
        ettime: ettime,
        etimage: etimage,
        etworker: null,
        etlat: etlatitude,
        etlon: etlongitude,
        etrating:etrating );
    print(data);

    Navigator.push(context, SlideRightRoute(page: EtrashDetail(etrash: etrash, user: widget.user)));
  }
}
