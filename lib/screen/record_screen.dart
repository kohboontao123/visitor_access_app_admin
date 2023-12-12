import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:visitor_access_app_admin/screen/record_result_list.dart';

import '../class/class.dart';


class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen>with TickerProviderStateMixin  {

  late TabController tabController;
  @override
  void initState() {
    tabController = new TabController(length: 5, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entry record"),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height:  MediaQuery.of(context).size.height* 0.05,
              width: double.maxFinite,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TabBar(
                controller: tabController,
                labelColor: Colors.black,
                isScrollable: true,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).scaffoldBackgroundColor,

                ),
                padding: EdgeInsets.all(0),
                unselectedLabelColor: Colors.grey.shade400,
                tabs: [
                  Tab(
                    text: "All",
                  ),
                  Tab(
                    text: "Accepted",
                  ),
                  Tab(
                    text: "Rejected",
                  ),
                  Tab(
                    text: "Pendings",
                  ),
                  Tab(
                    text: "Cancel",
                  )
                ],
              ),
            ),
            Container(
              height:  MediaQuery.of(context).size.height* 0.80,
              width: double.maxFinite,
              child: TabBarView(
                controller: tabController,
                children: [
                  RecordResultList("All"),
                  RecordResultList("Accepted"),
                  RecordResultList("Rejected"),
                  RecordResultList("Pendings"),
                  RecordResultList("Cancel"),
                ],
              ),
            )

          ],
        ),
      )
    );
  }

}


