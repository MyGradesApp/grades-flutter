import 'package:flutter/material.dart';
import 'package:grade_core/grade_core.dart';
import 'package:tuple/tuple.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum SISBookmarks {
  GraduationReqs,
  GradeSummary,
}

class SISWebview extends StatefulWidget {
  @override
  _SISWebviewState createState() => _SISWebviewState();
}

class _SISWebviewState extends State<SISWebview> {
  WebViewController controller;
  bool loggingIn = true;

  _SISWebviewState();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tuple2<String, String>>(
      future: (() async {
        var secureStorage = WrappedSecureStorage();
        var username =
            await secureStorage.read(key: AuthConst.SIS_USERNAME_KEY);
        var password =
            await secureStorage.read(key: AuthConst.SIS_PASSWORD_KEY);
        return Tuple2(username, password);
      })(),
      builder: (context, snapshot) {
        var username = snapshot.data?.item1;
        var password = snapshot.data?.item2;
        return Scaffold(
          appBar: AppBar(
            title: Text('SIS'),
            elevation: 0.0,
            actions: [
              PopupMenuButton<SISBookmarks>(
                icon: Icon(Icons.bookmark),
                onSelected: (bookmark) {
                  switch (bookmark) {
                    case SISBookmarks.GraduationReqs:
                      controller.loadUrl(
                          'https://sis.palmbeachschools.org/focus/Modules.php?'
                          'force_package=SIS&modname=GraduationRequirements/'
                          'GraduationRequirements.php');
                      break;
                    case SISBookmarks.GradeSummary:
                      controller.loadUrl(
                          'https://sis.palmbeachschools.org/focus/Modules.php?'
                          'modname=Students/Student.php#!98');
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    enabled: !loggingIn,
                    value: SISBookmarks.GraduationReqs,
                    child: Text('Graduation Requirements'),
                  ),
                  PopupMenuItem(
                    enabled: !loggingIn,
                    value: SISBookmarks.GradeSummary,
                    child: Text('Grade Summary'),
                  ),
                ],
              )
            ],
          ),
          body: Stack(
            children: [
              if (snapshot.hasData)
                WebView(
                  initialUrl:
                      'https://sis.palmbeachschools.org/focus/Modules.php',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller) {
                    this.controller = controller;
                  },
                  onPageFinished: (url) {
                    if (url.startsWith(
                        'https://connected.palmbeachschools.org/simplesaml/module.php/multiauth/selectsource.php?')) {
                      controller.evaluateJavascript(
                          'document.getElementById("button-enboardsso-sp").click()');
                    }
                    if (url.startsWith('https://www.mysdpbc.org/_authn/')) {
                      controller.evaluateJavascript(
                          'document.getElementById("Username").value="$username"');
                      controller.evaluateJavascript(
                          'document.getElementById("Password").value="$password"');
                      controller.evaluateJavascript(
                          'document.getElementById("login-button").click()');
                    }
                    if (url ==
                        'https://sis.palmbeachschools.org/focus/Modules.php?modname=misc/Portal.php') {
                      setState(() {
                        loggingIn = false;
                      });
                    }
                  },
                ),
              if (loggingIn)
                SizedBox.expand(
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Logging in...',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        SizedBox(height: 25),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
