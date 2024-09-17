import 'package:flutter/material.dart';
import 'city_db_helper.dart';

class CitySelectionPage extends StatefulWidget {
  @override
  _CitySelectionPageState createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  List<Map<String, dynamic>> _filteredCities = [];
  TextEditingController _searchController = TextEditingController();

  // Variable to store the selected city
  Map<String, dynamic>? _selectedCity;

  @override
  void initState() {
    super.initState();
    _fetchAllCities();
    _searchController.addListener(_onSearchChanged);
    _selectedCity = null; // Initialize with no selected city (optional)
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fetch all cities initially
  void _fetchAllCities() async {
    List<Map<String, dynamic>> cities = await CityHelper().getAllCities();
    setState(() {
      _filteredCities = cities;
    });
  }

  // Handle search input changes
  void _onSearchChanged() async {
    String query = _searchController.text;

    if (query.isNotEmpty) {
      List<Map<String, dynamic>> cities =
          await CityHelper().searchCities(query);
      setState(() {
        _filteredCities = cities;
      });
    } else {
      _fetchAllCities(); // If search input is cleared, show all cities
    }
  }

  // Handle city selection using radio buttons
  void _onCitySelected(Map<String, dynamic> city) {
    setState(() {
      _selectedCity = city;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a City'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search City',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filteredCities.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredCities.length,
                    itemBuilder: (context, index) {
                      final city = _filteredCities[index];
                      return ListTile(
                        title: Text(city['name']), // Display the city name
                        trailing: Radio<Map<String, dynamic>>(
                          value:
                              city, // The city that this radio button represents
                          groupValue:
                              _selectedCity, // The currently selected city
                          onChanged: (Map<String, dynamic>? value) {
                            setState(() {
                              _selectedCity =
                                  value; // Update the selected city in the state
                            });
                          },
                          activeColor:
                              Colors.blue, // Change the color when selected
                        ),
                      );
                    },
                  ),
          ),
          if (_selectedCity != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Selected City: ${_selectedCity!['name']}', // Show selected city
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
