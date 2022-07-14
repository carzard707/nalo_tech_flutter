import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PaginationScreen extends StatefulWidget {
  const PaginationScreen({Key? key}) : super(key: key);

  @override
  State<PaginationScreen> createState() => _PaginationScreenState();
}

class _PaginationScreenState extends State<PaginationScreen> {
  int currentPage = 1, totalNumOfpages = 0;
  Future<List> getPosts() async {
    try {
      var response = await Dio()
          .get("http://10.0.2.2:3030/getAllPhoneNumbers?page=$currentPage");
      setState(() {
        totalNumOfpages = response.data['totalNumberOfPages'];
      });

      return response.data['result'];
    } catch (socketException) {
      // fetching error
      // may be timeout, no internet or dns not resolved
      return Future.error("Error Fetching Data !");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: const Icon(
                  Icons.arrow_back,
                  size: 30,
                )),
          ),
          SingleChildScrollView(
            child: FutureBuilder<List>(
              future: getPosts(),
              builder: (context, snapshot) {
                // print(snapshot.data);
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Column(
                        children: snapshot.data!
                            .map((e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Text(
                                    '${snapshot.data!.indexOf(e) + 1}.  User name: ${e['UserName']}, Phone Number: ${e['PhoneNumber']}',
                                    style: const TextStyle(
                                        fontFamily: 'Gilroy-Medium',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(79, 79, 79, 1)),
                                    textAlign: TextAlign.center,
                                  ),
                                ))
                            .toList(),
                      ),
                      //
                      //
                      //
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (currentPage < totalNumOfpages)
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  currentPage++;
                                });
                              },
                              child: const Text(
                                "Next",
                              ),
                            ),
                          if (currentPage > 1)
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  currentPage--;
                                });
                              },
                              child: const Text(
                                "Previous",
                              ),
                            ),
                        ],
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    ));
  }
}
