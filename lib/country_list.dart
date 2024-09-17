import 'package:flutter/material.dart';
import 'package:search_list_project/city_list.dart';
import 'package:search_list_project/country_db_helper.dart';

class CountryListScreen extends StatefulWidget {
  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  List<Map<String, dynamic>> _filteredCountries = [];
  TextEditingController _searchController = TextEditingController();
// List to store the selected countries
  List<Map<String, dynamic>> _selectedCountries = [];
  @override
  void initState() {
    super.initState();
    _fetchAllCountries(); // Initially load all countries
    _searchController
        .addListener(_onSearchChanged); // Listen for search input changes
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }

  // Fetch all countries initially
  void _fetchAllCountries() async {
    List<Map<String, dynamic>> countries = await CountryDBHelper()
        .getRecords('list_of_countries'); // Replace with your table name
    setState(() {
      _filteredCountries = countries;
    });
  }

  // Handle search input changes
  void _onSearchChanged() async {
    String query = _searchController.text;

    if (query.isNotEmpty) {
      List<Map<String, dynamic>> countries =
          await CountryDBHelper().searchCountries(query);
      setState(() {
        _filteredCountries = countries;
      });
    } else {
      _fetchAllCountries(); // If search input is cleared, show all countries
    }
  }

  // Check if a country is selected
  bool _isCountrySelected(Map<String, dynamic> country) {
    return _selectedCountries
        .any((selected) => selected['id'] == country['id']);
  }

  // Toggle the selection of a country
  void _toggleCountrySelection(Map<String, dynamic> country) {
    setState(() {
      if (_isCountrySelected(country)) {
        _selectedCountries
            .removeWhere((selected) => selected['id'] == country['id']);
      } else {
        _selectedCountries.add(country);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country List'),
      ),
      body: Scaffold(
        appBar: AppBar(
          title: Text('Search Countries'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CitySelectionPage()),
                  );
                },
                icon: Icon(Icons.location_city)),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Country',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: _filteredCountries.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = _filteredCountries[index];
                        return ListTile(
                          title: Text(country[
                              'name']), // Replace 'name' with the correct column name
                          trailing: Checkbox(
                            value: _isCountrySelected(country),
                            onChanged: (bool? value) {
                              _toggleCountrySelection(country);
                            },
                          ),
                        );
                      },
                    ),
            ),

            // Display the selected countries
            if (_selectedCountries.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Selected Countries: ${_selectedCountries.map((country) => country['name']).join(', ')}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
