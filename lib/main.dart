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

  String dropdownValue = 'CST';

  updateText() {
    setState(() {
      conInput = inputCont.text;
      if (conInput.contains(':')) {
        conInput = conInput;
      } else {
        conInput = 'Your message did not contain a time in the format of HH:MM';
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    //Duration est = Duration(hours: -5);
    //Duration test = DateTime.now().timeZoneOffset - est;
    //print(test);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              Text(
                'Choose a timezone to convert from: ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                  value: dropdownValue,
                  //icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  underline: SizedBox(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['CST', 'EST', 'PST']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              ),
              SizedBox(height: 10),
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
