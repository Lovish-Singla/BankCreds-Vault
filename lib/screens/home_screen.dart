import 'package:flutter/material.dart';
import 'package:bank_credentials/models/organisation.dart';
import 'package:bank_credentials/screens/organisation_form.dart';
import 'package:bank_credentials/utils/database_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper dbHelper = DBHelper();
  late Future<List<Map<String, dynamic>>> organizationsFuture;

  @override
  void initState() {
    super.initState();
    organizationsFuture = dbHelper.getOrganisationMapList();
  }

  Future<void> _refreshData() async {
    setState(() {
      organizationsFuture = dbHelper.getOrganisationMapList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization List'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder(
          future: organizationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Map<String, dynamic>> organizations =
              snapshot.data as List<Map<String, dynamic>>;

              return organizations.isEmpty
                  ? const Center(child: Text('No organizations available.'))
                  : ListView.builder(
                itemCount: organizations.length,
                itemBuilder: (context, index) {
                  Organization organization =
                  Organization.fromMap(organizations[index]);
                  return ListTile(
                    title: Text(organization.name),
                    leading: CircleAvatar(child: Text(organization.name[0]),),
                    subtitle: Text(
                        'Account Number: ${organization.accountNumber}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrganizationForm(organization: organization),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrganizationForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
