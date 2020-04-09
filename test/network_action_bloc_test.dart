import 'package:flutter_test/flutter_test.dart';
import 'package:grade_core/grade_core.dart';

void main() {
  test('state toString smoke test', () {
    NetworkLoading().toString();
    NetworkLoaded(null).toString();
    NetworkLoaded(null, format: (Null v) => '${v == null}').toString();
    NetworkLoaded([1], format: (List<int> v) => '${v == null}').toString();
  });

  test('state toString smoke test', () {
    FetchNetworkData().toString();
    RefreshNetworkData().toString();
  });
}
