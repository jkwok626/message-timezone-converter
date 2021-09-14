import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: MyApp(),
));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Message Timezone Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final inputCont = TextEditingController();

  @override
  void dispose() {
    inputCont.dispose();
    super.dispose();
  }

  String conInput = '';

  updateText() {
    setState(() {
      conInput = inputCont.text;
    });
  }

  //String test = DateTime.now().timeZoneOffset.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                        child: Text('Dropdown 1'),
                        onPressed: () {

                        }
                    ),
                    ElevatedButton(
                        child: Text('Dropdown 2'),
                        onPressed: () {

                        }
                    ),
                  ]
              ),
              SizedBox(height: 15),
              TextField(
                controller: inputCont,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Enter a Message',
                  labelStyle: TextStyle(
                    color: Colors.red,
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 10,
              ),
              SizedBox(height: 3),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Convert'),
                  onPressed: () {
                    updateText();
                  },
                ),
              ),
              SizedBox(height: 3),
              Container(
                height: 230,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,  // red as border color
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Text(
                    '$conInput',
                    //'${test[0]}${test[1]}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
