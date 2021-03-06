// Copyright (c) 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:test/test.dart';
import 'package:dashboard_box/src/utils.dart';

main() {
  group('grep', () {
    test('greps lines', () {
      expect(grep('b', from: 'ab\ncd\nba'), ['ab', 'ba']);
    });

    test('understands RegExp', () {
      expect(grep(new RegExp('^b'), from: 'ab\nba'), ['ba']);
    });
  });
}
