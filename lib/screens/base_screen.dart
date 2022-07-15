import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nalo_tech/screens/paginationScreen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  String backendIP = 'http://10.0.2.2:3030/'; //insert address of the backend ending with forwardSlash

  TextEditingController phoneNumberTEC = TextEditingController();
  TextEditingController userNameTEC = TextEditingController();
  TextEditingController phoneNumberIDTEC = TextEditingController();
  TextEditingController oldNumberTEC = TextEditingController();
  TextEditingController newNumberTEC = TextEditingController();
  bool editNumber = false, filePicked = false;
  String phoneNumber = '', fetchedNumber = '', oldNumber = '', newNumber = '', userName = '';
  String filePath = '', pickedFileName = '', pickedFileSize = '';
  String phoneNumberID = '';

  Future<String?> uploadFile(filename, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('numbers', filename));
    var res = await request.send();
    return res.reasonPhrase;
  }
  void errorPopup(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 17);

  }
  void successPopup(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 17);

  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: height,
          width: width,
          child: ListView(
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    InkWell(
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          final file = result.files.first;

                          setState(() {
                            filePicked = true;
                            filePath = file.path!;
                            pickedFileName = file.name;
                            pickedFileSize = ((file.size) / (1024 * 1024))
                                .toString()
                                .substring(0, 4);
                          });
                          // OpenFile.open(file.path!);
                          uploadFile(file.path, '${backendIP}addCSVNumbers');
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, size: 28, color: Colors.blueAccent),
                          Text(
                            'Add csv file',
                            style: TextStyle(
                                fontFamily: 'Gilroy-Medium',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const PaginationScreen()));
                        },
                        child: const Text(
                          'Fetch paginated (20)',
                          style: TextStyle(
                              fontFamily: 'Gilroy-Medium',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueAccent),
                        )),
                    const SizedBox(
                      height: 100,
                    ),
                    Container(
                      height: 50,
                      width: width / 1.1,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          color: HexColor('f2f2f2'),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextFormField(
                          controller: phoneNumberTEC,
                          cursorColor: Colors.blueAccent.withOpacity(0.5),
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          },
                          onTap: () {
                            setState(() {
                              phoneNumber = '';
                            });
                          },
                          onChanged: (number) {
                            setState(() {
                              phoneNumber = number;
                            });
                          },
                          autofocus: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Theme.of(context).textTheme.caption?.color,
                            ),
                            hintText: 'Enter phone number ...',
                            hintStyle: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Gilroy-Medium',
                                fontWeight: FontWeight.w400),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 13),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: width / 1.1,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          color: HexColor('f2f2f2'),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextFormField(
                          controller: userNameTEC,
                          cursorColor: Colors.blueAccent.withOpacity(0.5),
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          },
                          onTap: () {
                            setState(() {
                              userName = '';
                            });
                          },
                          onChanged: (name) {
                            setState(() {
                              userName = name;
                            });
                          },
                          autofocus: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Theme.of(context).textTheme.caption?.color,
                            ),
                            hintText: 'Enter user name ...',
                            hintStyle: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Gilroy-Medium',
                                fontWeight: FontWeight.w400),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 13),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (phoneNumber.isNotEmpty &&
                            phoneNumber.length == 10 &&
                            phoneNumber[0] == (0.toString()) && userName.isNotEmpty) {
                          var response = await Dio().post(
                              '${backendIP}createNewPhoneNumber',
                              data: {'phoneNumber': phoneNumber, 'userName':userName});
                          if(response.statusCode==201){
                            successPopup(response.data);
                            setState((){
                              phoneNumberTEC.clear();
                              userNameTEC.clear();
                              phoneNumber = '';
                              userName = '';
                            });

                          }else{
                            errorPopup(response.data);
                          }
                        } else {
                          errorPopup('Please make sure that the phone number is made of 10 digits starting with 0!');
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, size: 28, color: Colors.blueAccent),
                          Text(
                            'Create new number',
                            style: TextStyle(
                                fontFamily: 'Gilroy-Medium',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: width / 1.1,
                      margin: const EdgeInsets.only(bottom: 20, top: 20),
                      decoration: BoxDecoration(
                          color: HexColor('f2f2f2'),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextFormField(
                          controller: phoneNumberIDTEC,
                          cursorColor: Colors.blueAccent.withOpacity(0.5),
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          },
                          onTap: () {
                            setState(() {
                              phoneNumberTEC.clear();
                              phoneNumberID = '';
                            });
                          },
                          onChanged: (id) {
                            setState(() {
                              phoneNumberID = id;
                            });
                          },
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Theme.of(context).textTheme.caption?.color,
                            ),
                            hintText:
                                'Enter number ID to delete or fetch number...',
                            hintStyle: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Gilroy-Medium',
                                fontWeight: FontWeight.w400),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 13),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(fetchedNumber),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              if (phoneNumberID.isNotEmpty) {
                                var response = await Dio().get(
                                    '${backendIP}fetchPhoneNumber?phoneNumberID=$phoneNumberID');
                                if (response.data!='Phone number does not exist!') {
                                  setState(() {
                                    fetchedNumber = response.data;
                                    phoneNumberIDTEC.clear();
                                    phoneNumberID = '';
                                  });
                                  successPopup('Number fetched successfully');
                                } else {
                                  setState(() {
                                    fetchedNumber = '';
                                  });

                                  errorPopup(response.data.toString());
                                }
                              } else {
                                errorPopup('Please make sure that the phone number Id field is not empty!');
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.add, size: 28, color: Colors.blueAccent),
                                Text(
                                  'Get phone number',
                                  style: TextStyle(
                                      fontFamily: 'Gilroy-Medium',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueAccent),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (phoneNumberID != '') {
                                var response = await Dio().delete(
                                    '${backendIP}deletePhoneNumber',
                                    data: {'phoneNumberID': phoneNumberID});
                                if (response.data!='Phone number does not exist!') {
                                  setState(() {
                                    fetchedNumber = response.data;
                                    phoneNumberIDTEC.clear();
                                    phoneNumberID = '';
                                  });
                                  successPopup('Number fetched successfully');
                                } else {
                                  setState(() {
                                    fetchedNumber = '';
                                  });

                                  errorPopup(response.data.toString());
                                }
                              } else {
                                errorPopup('Please make sure that the phone number Id field is not empty!');
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.remove,
                                    size: 28, color: Colors.blueAccent),
                                Text(
                                  'Delete number',
                                  style: TextStyle(
                                      fontFamily: 'Gilroy-Medium',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueAccent),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        if (editNumber == true &&
                            oldNumber.isNotEmpty &&
                            newNumber.isNotEmpty) {
                          if (newNumber.length == 10 &&
                              oldNumber.length == 10 &&
                              newNumber[0] == (0.toString()) &&
                              oldNumber[0] == (0.toString())) {
                            var response = await Dio()
                                .post('${backendIP}editNumber', data: {
                              'oldNumber': oldNumber,
                              'newNumber': newNumber
                            });
                            if (response.data == 'Phone number does not exist!' ||
                                response.data ==
                                    'Error occurred, please try again!') {
                              errorPopup(response.data.toString());
                            } else {
                              setState((){
                                oldNumberTEC.clear();
                                oldNumber='';
                                newNumberTEC.clear();
                                newNumber='';
                              });
                              successPopup(response.data.toString());

                            }
                          } else {
                            errorPopup('Please make sure that the phone number is made of 10 digits starting with 0!');
                          }
                        } else {
                          setState(() {
                            editNumber = !editNumber;
                          });
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, size: 28, color: Colors.blueAccent),
                          Text(
                            'Edit number',
                            style: TextStyle(
                                fontFamily: 'Gilroy-Medium',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    ),
                    if (editNumber) ...[
                      Container(
                        height: 50,
                        width: width / 1.1,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            color: HexColor('f2f2f2'),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: TextFormField(
                            controller: oldNumberTEC,
                            cursorColor: Colors.blueAccent.withOpacity(0.5),
                            onEditingComplete: () async {
                              FocusScope.of(context).unfocus();
                            },
                            onTap: () {
                              setState(() {
                                oldNumber = '';
                              });
                            },
                            onChanged: (text) {
                              setState(() {
                                oldNumber = text;
                              });
                            },
                            autofocus: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Theme.of(context).textTheme.caption?.color,
                              ),
                              hintText: 'Enter phone number to edit ...',
                              hintStyle: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Gilroy-Medium',
                                  fontWeight: FontWeight.w400),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 13),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: width / 1.1,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            color: HexColor('f2f2f2'),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: TextFormField(
                            controller: newNumberTEC,
                            cursorColor: Colors.blueAccent.withOpacity(0.5),
                            onEditingComplete: () async {
                              FocusScope.of(context).unfocus();
                            },
                            onTap: () {
                              setState(() {
                                newNumber = '';
                              });
                            },
                            onChanged: (text) {
                              setState(() {
                                newNumber = text;
                              });
                            },
                            autofocus: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Theme.of(context).textTheme.caption?.color,
                              ),
                              hintText: 'Enter new number ...',
                              hintStyle: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Gilroy-Medium',
                                  fontWeight: FontWeight.w400),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 13),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
