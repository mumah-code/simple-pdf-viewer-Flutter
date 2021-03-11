import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(new SearchBarDemoApp());
}

class SearchBarDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Mubin PDF VIEWER',
        theme: new ThemeData(primarySwatch: Colors.red),
        home: new SearchBarDemoHome());
  }
}

class SearchBarDemoHome extends StatefulWidget {
  @override
  _SearchBarDemoHomeState createState() => new _SearchBarDemoHomeState();
}

class _SearchBarDemoHomeState extends State<SearchBarDemoHome> {
  final translator = GoogleTranslator();
  bool _isLoading = true;
  PDFDocument document;
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Mubin PDF VIEWER'),
        actions: [searchBar.getSearchAction(context)]);
  }

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(
      "http://www.pdf995.com/samples/pdf.pdf",
    );

    setState(() => _isLoading = false);
  }

  void onSubmitted(String value) {
    translator.translate(value, from: 'en', to: 'bn').then((result) {
      setState(() => _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text('You wrote $result!'))));
    });
  }

  _SearchBarDemoHomeState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: new Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : PDFViewer(
                document: document,
                zoomSteps: 5,
              ),
      ),
    );
  }
}
