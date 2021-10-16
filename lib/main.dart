import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: MyApp(),
));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Limits the orientation to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

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
  // Controller used for collecting user's message input
  final inputCont = TextEditingController();

  @override
  void dispose() {
    inputCont.dispose();
    super.dispose();
  }

  // String that is returned to the user after they hit the convert button
  String conInput = '';

  // Displays CST as the default option for the dropdown button
  String dropdownValue = 'Central Standard Time (CST)';

  updateText() {
    setState(() {
      if (inputCont.text.contains(':')) {
        for (int i = 0; i < inputCont.text.length; i++) {
          // Get the index of the colon
          if (inputCont.text[i] == ':') {

            // Check if the character before the colon is a number
            if (inputCont.text[i - 1].contains(new RegExp(r'[0-9]'))) {
              // Store the hour value of the time in the user's message
              int? storeHour = int.parse(inputCont.text[i - 1]);
              print(storeHour);

              // Depending on which timezone the user chose, set
              // set conversionOffset to the UTC time offset for that timezone
              Duration conversionOffset = Duration(hours: -5);
              switch(dropdownValue) {
                case 'Central Standard Time (CST)': {
                  // If it is currently daylight savings time, convert to CDT
                  if (DateTime(2021, 3, 14).isBefore(DateTime.now()) && DateTime(2021, 11, 7).isAfter(DateTime.now())) {
                    conversionOffset = Duration(hours: -5);
                  } else {
                    conversionOffset = Duration(hours: -6);
                  }
                }
                break;

                case 'Eastern Standard Time (EST)': {
                  // If it is currently daylight savings time, convert to EDT
                  if (DateTime(2021, 3, 14).isBefore(DateTime.now()) && DateTime(2021, 11, 7).isAfter(DateTime.now())) {
                    conversionOffset = Duration(hours: -4);
                  } else {
                    conversionOffset = Duration(hours: -5);
                  }
                }
                break;

                case 'Hawaii Standard Time (HST)': {
                  conversionOffset = Duration(hours: -10);
                }
                break;

                case 'Mountain Standard Time (MST)': {
                  // If it is currently daylight savings time, convert to MDT
                  if (DateTime(2021, 3, 14).isBefore(DateTime.now()) && DateTime(2021, 11, 7).isAfter(DateTime.now())) {
                    conversionOffset = Duration(hours: -6);
                  } else {
                    conversionOffset = Duration(hours: -7);
                  }
                }
                break;

                case 'Pacific Standard Time (PST)': {
                  // If it is currently daylight savings time, convert to PDT
                  if (DateTime(2021, 3, 14).isBefore(DateTime.now()) && DateTime(2021, 11, 7).isAfter(DateTime.now())) {
                    conversionOffset = Duration(hours: -7);
                  } else {
                    conversionOffset = Duration(hours: -8);
                  }
                }
                break;
              }

              // Get the user's timezone offset and subtract it from the
              // conversionOffset. This gives us the difference between the
              // user's current timezone and the timezone that we're converting
              // from. This difference is of type Duration but convert it to a
              // String first so that it can be parsed into an int later.
              String offsetString = (conversionOffset - DateTime.now().timeZoneOffset).toString();
              print(offsetString);

              // Split the String based on the colons so that we can easily
              // parse the numbers.
              List<String> offsetDifference = offsetString.split(':');

              storeHour = storeHour + int.parse(offsetDifference[0]);
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            // Starts laying out widgets in a column from the top of the screen
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

              // Dropdown for selecting timezone
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
                    'Hawaii Standard Time (HST)',
                    'Mountain Standard Time (MST)',
                    'Pacific Standard Time (PST)',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              ),
              SizedBox(height: 10),

              // Textfield for user to enter message
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

                // Convert button
                child: ElevatedButton(
                  child: Text(
                    'Convert',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
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
                    // Fill in bottom box with either the converted message or
                    // an error message
                    '$conInput',
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
