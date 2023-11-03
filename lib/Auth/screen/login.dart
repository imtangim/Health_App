import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/Auth/controler/auth_controller.dart';

import 'package:health_app/extra/loader.dart';
import 'package:health_app/extra/signinbutton.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControlerProvider);

    return Scaffold(
      body: isLoading
          ? const Loader()
          : const Center(
              child: SizedBox(
                height: 200,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome User",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SignButton()
                  ],
                ),
              ),
            ),
    );
  }
}
