import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/theme.dart';
import 'package:flutter/material.dart';

class CashierScreen extends StatelessWidget {
  const CashierScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Kasir",
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection("pengunjung").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var items = snapshot.data;
              final pengunjungDataNowHour = items!.docs[items.docs.length - 1]
                      .data()
                      .toString()
                      .contains("pengunjung_jam_${DateTime.now().hour}")
                  ? items.docs[items.docs.length - 1]
                          ["pengunjung_jam_${DateTime.now().hour}"]
                      .toString()
                  : "0";
              Future<String?> pengunjungDataNow({int kapan = 0}) async {
                String currentDate =
                    "${(now.day - kapan).toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year.toString()}";

                String? dataDocs;
                await FirebaseFirestore.instance
                    .collection("pengunjung")
                    .doc(currentDate)
                    .get()
                    .then((docSnapshot) {
                  if (docSnapshot.exists &&
                      docSnapshot.data()!.containsKey("value")) {
                    dataDocs = docSnapshot.data()!["value"].toString();
                  } else {
                    dataDocs = "0";
                  }
                });
                return dataDocs;
              }

              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(color: Colors.green),
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.15, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder(
                          future: pengunjungDataNow(),
                          builder: (BuildContext context,
                              AsyncSnapshot<String?> snapshot) {
                            if (snapshot.hasData) {
                              return boxRectangle("Hari ini", snapshot.data!);
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                        FutureBuilder(
                          future: pengunjungDataNow(kapan: 1),
                          builder: (BuildContext context,
                              AsyncSnapshot<String?> snapshot) {
                            if (snapshot.hasData) {
                              return boxRectangle("Kemarin", snapshot.data!);
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: boxRectangle(
                                "Pengunjung Jam ${DateTime.now().hour > 20 || DateTime.now().hour < 7 ? "" : DateTime.now().hour}",
                                pengunjungDataNowHour,
                                height: 100)),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Text(
                        "Data",
                        style: whiteTextStyle.copyWith(
                            fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.40,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      detailsContainer(),
                                      detailsContainer(),
                                      detailsContainer(),
                                      detailsContainer(),
                                      detailsContainer(),
                                      detailsContainer(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  Container detailsContainer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(13)),
      height: 65,
      padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Dewa",
                style: whiteTextStyle.copyWith(
                  fontSize: 20.0,
                ),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    "Rp134.000",
                    style: whiteTextStyle.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container boxRectangle(String title, String body, {double height = 150}) {
    return Container(
      height: height,
      width: 150,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: blackTextStyle.copyWith(
              fontSize: 24,
            ),
          ),
          Text(
            body,
            style: blackTextStyle.copyWith(
              fontSize: 40,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
