import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/core/utils/colorful_tag.dart';
import 'package:smart_admin_dashboard/models/recent_user_model.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/utils/firebase_service.dart';

class RecentUsers extends StatelessWidget {
  const RecentUsers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Candidates",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SingleChildScrollView(
            //scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: double.infinity,
              child: FutureBuilder(
                future: firebaseService.getAllRecentUsers(),
                builder: (context, AsyncSnapshot<List<RecentUser>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return DataTable(
                      horizontalMargin: 0,
                      columnSpacing: defaultPadding,
                      columns: [
                        DataColumn(
                          label: Text("Name Surname"),
                        ),
                        DataColumn(
                          label: Text("E-mail"),
                        ),
                        DataColumn(
                          label: Text("Registration Date"),
                        ),
                        DataColumn(
                          label: Text("Status"),
                        ),
                        DataColumn(
                          label: Text("Operation"),
                        ),
                      ],
                      rows: snapshot.data!.map((user) {
                        return recentUserDataRow(user, context);
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow recentUserDataRow(RecentUser userInfo, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              TextAvatar(
                size: 35,
                backgroundColor: Colors.white,
                textColor: Colors.white,
                fontSize: 14,
                upperCase: true,
                numberLetters: 1,
                shape: Shape.Rectangle,
                text: userInfo.name!,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  userInfo.name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(userInfo.email!)),
        DataCell(Text(userInfo.date!)),
        DataCell(Text(userInfo.posts!)),
        DataCell(
          Row(
            children: [
              TextButton(
                child: Text('View', style: TextStyle(color: greenColor)),
                onPressed: () {},
              ),
              SizedBox(
                width: 6,
              ),
              TextButton(
                child:
                    Text("Delete", style: TextStyle(color: Colors.redAccent)),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                            title: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.warning_outlined,
                                      size: 36, color: Colors.red),
                                  SizedBox(height: 20),
                                  Text("Confirm Deletion"),
                                ],
                              ),
                            ),
                            content: Container(
                              color: secondaryColor,
                              height: 70,
                              child: Column(
                                children: [
                                  Text(
                                      "Are you sure want to delete '${userInfo.name}'?"),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                          icon: Icon(
                                            Icons.close,
                                            size: 14,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          label: Text("Cancel")),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      ElevatedButton.icon(
                                          icon: Icon(
                                            Icons.delete,
                                            size: 14,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          onPressed: () {},
                                          label: Text("Delete"))
                                    ],
                                  )
                                ],
                              ),
                            ));
                      });
                },
                // Delete
              ),
            ],
          ),
        ),
      ],
    );
  }
}
