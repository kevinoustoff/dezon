import 'package:dezon/constants.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController;
  int _value = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    //MusicState mState = Provider.of<MusicState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: TextFormField(
          //controller: _searchController,
          autofocus: true,
          onChanged: (typed) {
            if (![null, ''].contains(_searchController.text)) {
              //mState.search(query: _searchController.text);
            } else {
              //mState.searchResultSongs = null;
              //mState.searchResultSongsError = null;
            }
          },
          decoration: new InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            suffix: GestureDetector(
              child: Icon(
                Icons.close,
              ),
              onTap: () => _searchController.clear(),
            ),
            hintText: "Entrez votre besoin...",
            /* hintStyle: new TextStyle(
              color: Colors.white,
            ), */
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 8,
                //alignment: WrapAlignment.center,
                //runAlignment: WrapAlignment.center,
                //crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ChoiceChip(
                    label: Text('Services'),
                    selected: _value == 0,
                    onSelected: (bool selected) {
                      setState(() {
                        _value = selected ? 0 : null;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: Text('Projets'),
                    selected: _value == 1,
                    onSelected: (bool selected) {
                      setState(() {
                        _value = selected ? 1 : null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
