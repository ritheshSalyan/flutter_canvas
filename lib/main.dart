// import 'package:cached_network_image/cached_network_image.dart';
import 'package:canvas/canvas/canvas_board.dart';
import 'package:canvas/canvas/canvas_controller.dart';
import 'package:canvas/canvas/canvas_item_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CanvasController controller = CanvasController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Row(
          children: [
            Expanded(
                child: ListView.builder(
              // physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) => CanvasItemWidget(
                  child:index.isEven?Image.network(
                 "https://i.pinimg.com/564x/ec/75/8f/ec758f6e2b748649f7515004c26d3827.jpg"
                          ,
                          // fit: BoxFit.contain,
                          ):Image.network( "https://www12.lunapic.com/do-not-link-here-use-hosting-instead/159698327726736170?4734465283")
                          ),
            )),
            Expanded(
                flex: 2,
                child: CanvasBoard(
                  controller: controller,
                )),
          ],
        ));
  }
}
