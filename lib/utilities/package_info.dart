//TODO: `package_info` does not yet support macos, so we wrap it here to fake the data

import 'dart:io';

import 'package:package_info/package_info.dart';

Future<PackageInfo> getPackageInfo() async {
  if (Platform.isMacOS) {
    return PackageInfo(
      appName: 'SwiftGrade',
      packageName: 'com.goldinguy.swiftgrade',
      buildNumber: '2',
      version: '1.0.0',
    );
  } else {
    return await PackageInfo.fromPlatform();
  }
}
