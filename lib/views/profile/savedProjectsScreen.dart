import 'package:flutter/material.dart';

class SavedProjectsScreen extends StatefulWidget {
  @override
  _SavedProjectsScreenState createState() => _SavedProjectsScreenState();
}

class _SavedProjectsScreenState extends State<SavedProjectsScreen> {
  TextStyle tableTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Projets Enregistrés"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const <int, TableColumnWidth>{
                0: FixedColumnWidth(64),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
                3: FixedColumnWidth(64),
              },
              border: TableBorder(
                horizontalInside: BorderSide(width: 0.5),
                verticalInside: BorderSide(width: 0.3),
              ),
              children: [
                TableRow(
                  children: [
                    Text(
                      "",
                      textAlign: TextAlign.center,
                      style: tableTitle,
                    ),
                    Text(
                      "Catégorie",
                      textAlign: TextAlign.center,
                      style: tableTitle,
                    ),
                    Text(
                      "Type/Coût",
                      textAlign: TextAlign.center,
                      style: tableTitle,
                    ),
                    Text(
                      "Action",
                      textAlign: TextAlign.center,
                      style: tableTitle,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      "",
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
