import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';
import 'dart:io';
import 'package:edge_detection/edge_detection.dart';
// import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

const List<String> areaList = <String>[
  'Cleopatra',
  'Louran',
  'Maiamy',
  'Sporting',
  'Saba Basha',
  'Shots'
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

const _clientId =
    "292708485994-o0jmj3hpudu14rc62fdf15qchlehgpha.apps.googleusercontent.com";
const _scopes = ['https://www.googleapis.com/auth/drive.file'];

class GoogleDrive {}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool label1 = true;
  bool label2 = true;
  bool label3 = true;
  bool label4 = true;
  bool label5 = true;
  bool label6 = true;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    fullnameController.text =
        "${firstNameController.text}" + "${lastnameController.text}";
    super.initState();
  }

  // void _submitForm(BuildContext context1) {
  //   // Validate returns true if the form is valid, or false
  //   // otherwise.
  //   if (_formKey.currentState!.validate()) {
  //     // If the form is valid, proceed.
  //     BasicInfo basicInfo = BasicInfo(
  //         firstNameController.text,
  //         lastnameController.text,
  //         fullnameController.text,
  //         addressController.text,
  //         dropdownValue,
  //         mobileNumberController.text,
  //         landlineNumberController.text);

  //     FormController formController = FormController();

  //     _showSnackbar("Submitting Feedback", context1);

  //     // Submit 'feedbackForm' and save it in Google Sheets.
  //     formController.submitForm(basicInfo, (String response) {
  //       print("Response: $response");
  //       if (response == FormController.STATUS_SUCCESS) {
  //         // Feedback is saved succesfully in Google Sheets.
  //         _showSnackbar("Feedback Submitted", context1);
  //       } else {
  //         // Error Occurred while saving data in Google Sheets.
  //         _showSnackbar("Error Occurred!", context1);
  //       }
  //     });
  //   }
  // }
  bool submitinfo = true;
  void _submitInfo(BuildContext context1) async {
    if (_formKey.currentState!.validate()) {
      const String scriptURL =
          'https://script.google.com/macros/s/AKfycbwCTO8fuFVR4wnYEZgfuj9MBvcuhC53o0GUA0P-Ua4NLVhKuIFBTAeYDmGW3Y6Au_SNgg/exec';

      String queryString =
          "?f_name=${firstNameController.text}&l_name=${lastnameController.text}&full_name=${fullnameController.text}&address=${addressController.text}&area=$dropdownValue&landline=${landlineNumberController.text}&mobileNo=${mobileNumberController.text}";

      var finalURI = Uri.parse(scriptURL + queryString);
      var response = await http.get(finalURI);
      //print(finalURI);

      if (response.statusCode == 200) {
        var bodyR = convert.jsonDecode(response.body);
        final snackBar = SnackBar(
          duration: const Duration(seconds: 2),
          content: Text("data inserting is good"),
          backgroundColor: (Color.fromARGB(255, 2, 233, 25)),
        );
        ScaffoldMessenger.of(context1).showSnackBar(snackBar);
        setState(() {
          submitinfo = false;
        });
        print(bodyR);
      } else {
        final snackBar = SnackBar(
          duration: const Duration(seconds: 2),
          content: Text("data inserting is bad"),
          backgroundColor: (Color.fromARGB(255, 255, 0, 0)),
        );
        ScaffoldMessenger.of(context1).showSnackBar(snackBar);
      }
    }
  }

  // Method to show snackbar with 'message'.
  _showSnackbar(String message, BuildContext context1) {
    // final snackBar = SnackBar(content: Text(message));
    // _scaffoldKey.currentState.showSnackBar(snackBar);
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(message),
      backgroundColor: (Color.fromARGB(255, 102, 93, 93)),
    );
    ScaffoldMessenger.of(context1).showSnackBar(snackBar);
  }

  final _formKey = GlobalKey<FormState>();
  bool before_value = false;
  final validate = ValidationBuilder();
  final firstNameController = TextEditingController();
  final lastnameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  final addressController = TextEditingController();
  final landlineNumberController = TextEditingController();
  final mobileNumberController = TextEditingController();

  bool setArea = false;
  @override
  void dispose() {
    firstNameController.dispose();
    lastnameController.dispose();
    addressController.dispose();
    landlineNumberController.dispose();
    mobileNumberController.dispose();
    fullnameController.dispose();
    super.dispose();
  }

  String dropdownValue = areaList.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment(0.5, 0.8),
            colors: <Color>[
              Color.fromRGBO(0, 248, 227, 0.894),
              Color.fromRGBO(1, 171, 63, 0.678),
            ],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: SizedBox(
              child: Container(
            height: MediaQuery.of(context).size.height * 0.89,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromARGB(211, 255, 255, 255),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Text(
                      "Welcome",
                      style: const TextStyle(
                        fontSize: 30,
                        //fontFamily: ,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 1, 112, 18),
                      ),
                    ),
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 1, 57, 83),
                    endIndent: 50,
                    indent: 50,
                    height: 30,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.63,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const ScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                controller: firstNameController,
                                keyboardType: TextInputType.text,
                                onChanged: (text) {
                                  setState(() {
                                    fullnameController.text = "";
                                    fullnameController.text =
                                        fullnameController.text +
                                            firstNameController.text;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      label1 = false;
                                    });
                                    return "Enter your first Name";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  iconColor: Color.fromARGB(255, 2, 88, 20),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 5, 170, 41),
                                        width: 2),
                                  ),
                                  labelText: label1 ? "First Name" : "",
                                  hintText: "Enter your First name here...",
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                // obscureText: true,
                                controller: lastnameController,
                                onChanged: (text) {
                                  setState(() {
                                    fullnameController.text =
                                        firstNameController.text + " ";
                                    fullnameController.text =
                                        fullnameController.text +
                                            lastnameController.text;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      label2 = false;
                                    });
                                    return "Enter your last Name";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  iconColor: Color.fromARGB(255, 2, 88, 20),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 5, 170, 41),
                                        width: 2),
                                  ),
                                  labelText: label2 ? "Last Name" : "",
                                  hintText: "Enter your Last name here...",
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                // obscureText: true,
                                controller: fullnameController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  iconColor: Color.fromARGB(255, 2, 88, 20),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 5, 170, 41),
                                        width: 2),
                                  ),
                                  labelText: "Full Name",
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                // obscureText: true,
                                controller: addressController,
                                keyboardType: TextInputType.streetAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      label4 = false;
                                    });
                                    return "Enter your Address";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  iconColor: Color.fromARGB(255, 2, 88, 20),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 5, 170, 41),
                                        width: 2),
                                  ),
                                  labelText: label4 ? "Address" : "",
                                  hintText: "Enter your address here...",
                                  icon: const Icon(Icons.home),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: TextFormField(
                                    controller: landlineNumberController,
                                    keyboardType: TextInputType.number,
                                    obscureText: false,
                                    validator: (value) {
                                      if (value!.trim().length != 9) {
                                        setState(() {
                                          label5 = false;
                                        });
                                        return 'Landline must be 10 digits';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      iconColor: Color.fromARGB(255, 2, 88, 20),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        borderSide: const BorderSide(
                                            color:
                                                Color.fromARGB(255, 5, 170, 41),
                                            width: 2),
                                      ),
                                      labelText:
                                          label5 ? "Landline Number" : "",
                                      hintText:
                                          "Enter your landline number here...",
                                      icon: const Icon(Icons.phone),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width * 0.2,
                                //alignment: Alignment.topRight,
                                child: DropdownButton<String>(
                                  value: setArea ? dropdownValue : null,
                                  isExpanded: true,
                                  //underline: const SizedBox(),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  hint: Text(
                                    "Area",
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  elevation: 20,
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Color.fromARGB(255, 10, 1, 35),
                                  ),
                                  onChanged: (String? value) {
                                    setState(() {
                                      setArea = true;
                                      dropdownValue = value!;
                                    });
                                  },
                                  items: areaList.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                // obscureText: true,
                                controller: mobileNumberController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.trim().length != 11) {
                                    setState(() {
                                      label6 = false;
                                    });
                                    return 'Mobile number must be 11 digits';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  iconColor: Color.fromARGB(255, 2, 88, 20),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 5, 170, 41),
                                        width: 2),
                                  ),
                                  labelText: label6 ? "Mobile Number" : "",
                                  hintText: "Enter your mobile number here...",
                                  icon: const Icon(Icons.phone_android),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 200,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: submitinfo,
                    replacement: FloatingActionButton.extended(
                      heroTag: null,
                      backgroundColor: const Color.fromARGB(255, 1, 57, 83),
                      label: const Text("Next"),
                      icon: const Icon(Icons.login),
                      tooltip: 'Next Page',
                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyCameraPage())),
                      },
                    ),
                    child: FloatingActionButton.extended(
                      heroTag: null,
                      backgroundColor: const Color.fromARGB(255, 1, 57, 83),
                      label: const Text("Submit"),
                      icon: const Icon(Icons.download),
                      tooltip: 'Submit Info',
                      onPressed: () => {
                        if (_formKey.currentState!.validate())
                          {
                            _submitInfo(context),
                          }
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print((await getApplicationSupportDirectory()).path);
        },
        tooltip: 'Help',
        child: const Icon(Icons.question_mark),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyCameraPage extends StatefulWidget {
  const MyCameraPage({super.key});

  @override
  State<MyCameraPage> createState() => _MyCameraPageState();
}

class _MyCameraPageState extends State<MyCameraPage> {
  String? _imagePath;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getImageFromCamera() async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      return;
    }

    // Generate filepath for saving
    String imagePath = p.join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    try {
      //Make sure to await the call to detectEdge.
      bool success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: true,
        androidScanTitle: 'Scanning', // use custom localizations for android
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
      print("success: $success");
    } catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _imagePath = imagePath;
    });
    uploadFileToGoogleDrive(File(imagePath));
  }

  Future<void> getImageFromGallery() async {
    // Generate filepath for saving
    String imagePath = p.join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    try {
      //Make sure to await the call to detectEdgeFromGallery.
      bool success = await EdgeDetection.detectEdgeFromGallery(
        imagePath,
        androidCropTitle: 'Crop', // use custom localizations for android
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
      print("success: $success");
    } catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _imagePath = imagePath;
    });
  }

  final storage = SecureStorage();
  //Get Authenticated Http Client
  Future<http.Client> getHttpClient() async {
    //Get Credentials
    var credentials = await storage.getCredentials();
    if (credentials == null) {
      //Needs user authentication
      var authClient =
          await clientViaUserConsent(ClientId(_clientId), _scopes, (url) {
        //Open Url in Browser
        launchUrl(Uri.parse(url));
      });
      //Save Credentials
      await storage.saveCredentials(authClient.credentials.accessToken,
          authClient.credentials.refreshToken!);
      return authClient;
    } else {
      print(credentials["expiry"]);
      //Already authenticated
      return authenticatedClient(
          http.Client(),
          AccessCredentials(
              AccessToken(credentials["type"], credentials["data"],
                  DateTime.tryParse(credentials["expiry"])!),
              credentials["refreshToken"],
              _scopes));
    }
  }

// check if the directory forlder is already available in drive , if available return its id
// if not available create a folder in drive and return id
//   if not able to create id then it means user authetication has failed
  Future<String?> _getFolderId(ga.DriveApi driveApi) async {
    final mimeType = "application/vnd.google-apps.folder";
    String folderName = "Scanned IDs";

    try {
      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$folderName'",
        $fields: "files(id, name)",
      );
      final files = found.files;
      if (files == null) {
        print("Sign-in first Error");
        return null;
      }

      // The folder already exists
      if (files.isNotEmpty) {
        return files.first.id;
      }

      // Create a folder
      ga.File folder = ga.File();
      folder.name = folderName;
      folder.mimeType = mimeType;
      final folderCreation = await driveApi.files.create(folder);
      print("Folder ID: ${folderCreation.id}");

      return folderCreation.id;
    } catch (e) {
      print(e);
      return null;
    }
  }

  uploadFileToGoogleDrive(File file) async {
    var client = await getHttpClient();
    var drive = ga.DriveApi(client);
    String? folderId = await _getFolderId(drive);
    if (folderId == null) {
      print("Sign-in first Error");
    } else {
      ga.File fileToUpload = ga.File();
      fileToUpload.parents = [folderId];
      fileToUpload.name = p.basename(file.absolute.path);
      var response = await drive.files.create(
        fileToUpload,
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
      );
      print(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                'Scan your ID',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 1.5,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Please click on camera button to scan your ID",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: _imagePath != null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Great',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 0, right: 0, bottom: 10),
                            child: Text(
                              _imagePath.toString(),
                              //"Now Scan the other side",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Image.file(
                            File(_imagePath ?? ''),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              getImageFromCamera();
              //getImageFromGallery();
            },
            tooltip: 'Scan ID',
            child: const Icon(Icons.camera_alt),
          ),
          bottomNavigationBar: BottomAppBar(
            color: const Color.fromARGB(255, 101, 215, 250),
            shape: const CircularNotchedRectangle(), //shape of notch
            notchMargin: 5,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.photo,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    getImageFromGallery();
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.upload,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    getImageFromGallery();
                  },
                ),
              ],
            ),
          )),
    );
  }
}

class SecureStorage {
  final storage = FlutterSecureStorage();
  //Save Credentials
  Future saveCredentials(AccessToken token, String refreshToken) async {
    print(token.expiry.toIso8601String());
    await storage.write(key: "type", value: token.type);
    await storage.write(key: "data", value: token.data);
    await storage.write(key: "expiry", value: token.expiry.toString());
    await storage.write(key: "refreshToken", value: refreshToken);
  }

  //Get Saved Credentials
  Future<Map<String, dynamic>?> getCredentials() async {
    var result = await storage.readAll();
    if (result.isEmpty) return null;
    return result;
  }

  //Clear Saved Credentials
  Future clear() {
    return storage.deleteAll();
  }
}
