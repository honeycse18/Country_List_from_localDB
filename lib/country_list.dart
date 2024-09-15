import 'package:flutter/material.dart';
import 'package:search_list_project/db_helper.dart';

class CountryListScreen extends StatefulWidget {
  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  List<Map<String, dynamic>> _countryList = [];

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  void _fetchCountries() async {
    List<Map<String, dynamic>> countries =
        await DatabaseHelper().getCountries();
    setState(() {
      _countryList = countries;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country List'),
      ),
      body: _countryList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _countryList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_countryList[index]['name']),
                );
              },
            ),
    );
  }
}
