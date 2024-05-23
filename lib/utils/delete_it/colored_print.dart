
import 'package:flutter/foundation.dart';

void coloredPrint(
    String sign,
    dynamic data,
    ) {
  if (kDebugMode) {
    // ignore: unused_local_variable
    final text = '\x1B[94m  \x1B[93m$sign => \x1B[96m$data\x1B[0m';
    print(text);
  }
}
