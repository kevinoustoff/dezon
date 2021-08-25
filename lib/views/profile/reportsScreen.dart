import 'package:dezon/constants.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  TextStyle tableTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes litiges"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                  ),
                  child: Text(
                    "Rapporter un litige",
                  ),
                ),
              ],
            ),
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
                      "Date",
                      textAlign: TextAlign.center,
                      style: tableTitle,
                    ),
                    Text(
                      "Description",
                      textAlign: TextAlign.center,
                      style: tableTitle,
                    ),
                    Text(
                      "Projet",
                      textAlign: TextAlign.center,
                      style: tableTitle,
                    ),
                    Text(
                      "Statut",
                      textAlign: TextAlign.center,
                      style: tableTitle,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      "31/07/21",
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Le client ne m'a pas payé.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Livraison d'un refrigérateur",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "En étude",
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
