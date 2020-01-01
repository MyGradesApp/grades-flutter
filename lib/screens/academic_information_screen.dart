import 'package:flutter/material.dart';
import 'package:grades/models/current_session.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/sis_loader.dart';

class AcademicInfoScreen extends StatefulWidget {
  @override
  _AcademicInfoScreenState createState() => _AcademicInfoScreenState();
}

class _AcademicInfoScreenState extends State<AcademicInfoScreen> {
  Future<Profile> _info;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchInfo();
  }

  _fetchInfo() {
    _info = Provider.of<CurrentSession>(context, listen: false)
        .sisLoader
        .getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Academic Information"),
        leading: IconButton(
          tooltip: "Back",
          icon: Icon(
            // TODO: Find a better icon for "logout"
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: FutureBuilder<Profile>(
          future: _info,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var info = snapshot.data;
              // TODO: Fix issue with bottom clipping
              return RefreshIndicator(
                onRefresh: () {
                  _fetchInfo();
                  return _info;
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            _buildCard("Cumulative GPA",
                                info.cumulative_gpa.toString()),
                            _buildCard("Cumulative Weighted GPA",
                                info.cumulative_weighted_gpa.toString()),
                            if (info.class_rank_numerator != null &&
                                info.class_rank_denominator != null)
                              _buildCard("Class Rank",
                                  '${info.class_rank_numerator} / ${info.class_rank_denominator}'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                      "An error occured fetching information:\n${snapshot.error}"));
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget _buildCard(String title, String body) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: const Color(0xff216bac),
      margin: const EdgeInsets.all(10),
      child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              body,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          )),
    );
  }
}
