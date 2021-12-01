//TODO: `package_info` does not yet support windows, so we wrap it here to fake the data

import 'dart:io';

import 'package:package_info/package_info.dart' as package_info;

Future<package_info.PackageInfo> getPackageInfo() async {
  if (Platform.isWindows) {
    return package_info.PackageInfo(
      appName: 'MyGrades',
      packageName: 'com.goldinguy.mygrades',
      buildNumber: '2',
      version: '1.2.3',
    );
  } else {
    var data = await package_info.PackageInfo.fromPlatform();

    return package_info.PackageInfo(
      appName: data.appName,
      buildNumber: data.buildNumber,
      packageName: data.packageName,
      version: data.version,
    );
  }
}
