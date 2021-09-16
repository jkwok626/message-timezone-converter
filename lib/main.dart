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

  String dropdownValue = 'Central Standard Time (CST)';

  updateText() {
    setState(() {
      //conInput = inputCont.text;
      if (inputCont.text.contains(':')) {
        for (int i = 0; i < inputCont.text.length; i++) {
          // Get the index of the colon
          if (inputCont.text[i] == ':') {

            // Check if the character before the colon is a number
            if (inputCont.text[i - 1].contains(new RegExp(r'[0-9]'))) {
              int? storeHour = int.parse(inputCont.text[i - 1]);
              print(storeHour);

              Duration conversionOffset = Duration(hours: -5);

              switch(dropdownValue) {
                case 'Central Standard Time (CST)': {
                  conversionOffset = Duration(hours: -5);
                }
                break;

                case 'Eastern Standard Time (EST)': {
                  conversionOffset = Duration(hours: -4);
                }
                break;

                case 'Pacific Standard Time (PST)': {
                  conversionOffset = Duration(hours: -7);
                }
                break;
              }

              String newHour = (conversionOffset - DateTime.now().timeZoneOffset).toString();
              print(newHour);

              storeHour = storeHour + int.parse(newHour[0]);
              conInput = inputCont.text.replaceFirst(RegExp(inputCont.text[i - 1] + ':'), storeHour.toString() + ':');

              // If the user enters a time after 12:00, restart the count
              // (e.g. 1, 2, 3)
              if (conInput.contains('13:')) {
                conInput = conInput.replaceFirst(RegExp('13:'), '1:');
              } else if (conInput.contains('14:')) {
                conInput = conInput.replaceFirst(RegExp('14:'), '2:');
              } else if (conInput.contains('15:')) {
                conInput = conInput.replaceFirst(RegExp('15:'), '3:');
              }
            }
          }
        }
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
                  items: <String>[
                    'Central Standard Time (CST)',
                    'Eastern Standard Time (EST)',
                    'Pacific Standard Time (PST)',
                  ].map<DropdownMenuItem<String>>((String value) {
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
                  child: Text(
                    'Convert',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurpleAccent,
                  ),
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
