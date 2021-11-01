import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }


  static Future<bool> authenticate() async {

    try {
      // ignore: deprecated_member_use
      return await _auth.authenticateWithBiometrics(

        localizedReason: 'Unlock your screen with Fingerprint',
        useErrorDialogs: true,
        stickyAuth: true,
        sensitiveTransaction: true,
      );
    } on PlatformException catch (e) {
      return false;
    }
  }
}