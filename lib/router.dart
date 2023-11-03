import 'package:flutter/material.dart';
import 'package:health_app/Auth/screen/login.dart';
import 'package:routemaster/routemaster.dart';

final loggedoutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LoginScreen()),
  },
);


