//TODO: `package_info` does not yet support macos, so we wrap it here to fake the data

import 'dart:io';

import 'package:package_info/package_info.dart' as package_info;

// No idea why this is needed, dart couldn't figure out what type we were returning
class PackageInfo {
  PackageInfo({
    this.appName,
    this.packageName,
    this.version,
    this.buildNumber,
  });

  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;
}

Future<PackageInfo> getPackageInfo() async {
  if (Platform.isMacOS) {
    return PackageInfo(
      appName: 'SwiftGrade',
      packageName: 'com.goldinguy.swiftgrade',
      buildNumber: '2',
      version: '1.0.0',
    );
  } else {
    var data = await package_info.PackageInfo.fromPlatform();

    return PackageInfo(
      appName: data.appName,
      buildNumber: data.buildNumber,
      packageName: data.packageName,
      version: data.version,
    );
  }
}
