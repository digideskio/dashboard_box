// Copyright (c) 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_rest/firebase_rest.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:convert' show JSON;

const firebaseBaseUrl = 'https://purple-butterfly-3000.firebaseio.com';

main(List<String> args) async {
  if (args.length != 1) {
    print("Usage: dart uploader.dart <path_to_measurement_json>");
    exit(1);
  }

  var measurementJsonPath = args[0];

  if (!measurementJsonPath.endsWith('.json')) {
    print("Error: path must be to a JSON file ending in .json");
    exit(1);
  }

  var measurementJson = new File(measurementJsonPath);

  if (!measurementJson.existsSync()) {
    print("Error: $measurementJsonPath not found");
    exit(1);
  }

  var measurementKey = path.basenameWithoutExtension(measurementJsonPath);

  print('Uploading $measurementJson to key $measurementKey');

  var firebaseToken = Platform.environment['FIREBASE_FLUTTER_DASHBOARD_TOKEN'];
  if (firebaseToken == null) {
    print('FIREBASE_FLUTTER_DASHBOARD_TOKEN not found in environment.');
    exit(1);
  }

  var ref = new Firebase(Uri.parse("$firebaseBaseUrl/measurements"),
      auth: firebaseToken);

  await ref
      .child(measurementKey)
      .child('current')
      .set(JSON.decode(measurementJson.readAsStringSync()));

  await ref
      .child(measurementKey)
      .child('history')
      .push(JSON.decode(measurementJson.readAsStringSync()));
}
