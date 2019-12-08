import 'package:flutter/material.dart';
import 'loginscreen.dart';
 
String urlReset = "http://itschizo.com/aidil_qayyum/etrash/php/resetpass.php";
 
class ResetPass extends StatefulWidget {
  final String email;

  const ResetPass({Key key, this.email}) : super(key: key);
    @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child:Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: new IconThemeData(color: Color(0xFFFFB74D))
          ),
      
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                //clipper: WaveClipper1(),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Reset Password",
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w700,
                            fontSize: 30),
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: 90,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              child: TextField(
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Material(
                      child: Icon(
                        Icons.email,
                        color: Colors.orange[300],
                      ),
                    ),
                    border: InputBorder.none,
                  ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
            ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 82),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Color(0xFFFFB74D)),
                child: FlatButton(
                  child: Text(
                    "Send Link",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  onPressed: () {

                  },
                ),
              )),
        ],
      ),
      ),
    );
  }
  
    Future<bool> _onBackPressAppBar() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
}