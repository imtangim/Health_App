import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/Auth/controler/auth_controller.dart';
import 'package:health_app/model/usermodel.dart';
import 'package:lottie/lottie.dart';

class MyHomePage extends ConsumerStatefulWidget {
  final String uid;
  const MyHomePage({required this.uid, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final _database = FirebaseDatabase.instance.ref();

  late StreamSubscription _realtimeReading;
  late UserModel user;
  late Timer _timer;

  dynamic temp = 0;
  dynamic rate = 0;

  @override
  void initState() {
    super.initState();
    _activateListener(widget.uid);
    updateUserData(widget.uid, temp, rate);
    const updateInterval = Duration(seconds: 10);
    _timer = Timer.periodic(updateInterval, (Timer timer) {
      updateUserData(widget.uid, temp, rate);
    });
  }

  @override
  void dispose() {
    _timer.cancel();

    _realtimeReading.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    _timer.cancel();

    _realtimeReading.cancel();
    super.deactivate();
  }

  void updateUserData(String uid, dynamic bodyTemp, dynamic heartRate) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore
        .collection("users")
        .doc(uid)
        .update({
          'body_temp': bodyTemp,
          'hearth_rate': heartRate,
        })
        .then((_) {})
        .catchError((error) {});
  }

  Object showData = {"body_temp": 0, "heart_rate": 0};
  void _activateListener(String uid) {
    Map<String, dynamic> data = {};
    _realtimeReading = _database.child("$uid/").onValue.listen((event) {
      final dynamic snapshotValue = event.snapshot.value;
      if (snapshotValue != null && snapshotValue is Map) {
        data = Map<String, dynamic>.from(snapshotValue);
      }

      setState(() {
        temp = data["body_temp"];
        rate = data["heart_rate"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.profilePic,
                ),
                maxRadius: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome back",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      wordSpacing: 2,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      wordSpacing: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        leadingWidth: MediaQuery.of(context).size.width / 1.5,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.help_outline_outlined,
              size: 28,
              color: Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_outlined,
              size: 28,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeartCard(number: rate),
              const SizedBox(
                width: 20,
              ),
              BodyTemp(number: temp),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
              onPressed: () {
                ref.read(authControlerProvider.notifier).logout();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_sharp),
                  Text("Log Out"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BodyTemp extends StatelessWidget {
  final dynamic number;
  const BodyTemp({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Temperature",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.thermostat,
                  )
                ],
              ),
              LottieBuilder.asset(
                "assets/animassets/temp.json",
                height: 100,
              ),
              Text(
                "${number ?? 0}° F",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HeartCard extends StatelessWidget {
  final dynamic number;
  const HeartCard({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Heath Rate",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.monitor_heart_outlined,
                  )
                ],
              ),
              LottieBuilder.asset(
                "assets/animassets/hearth_rate.json",
                height: 100,
              ),
              Text(
                "${number ?? 0} BPM",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
