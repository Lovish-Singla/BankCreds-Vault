import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/organisation.dart';
import '../utils/database_helper.dart';

class OrganizationForm extends StatefulWidget {
  final Organization? organization;

  OrganizationForm({this.organization});

  @override
  _OrganizationFormState createState() => _OrganizationFormState();
}

class _OrganizationFormState extends State<OrganizationForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  DBHelper dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();

    // Initialize form fields with organization data if editing
    if (widget.organization != null) {
      nameController.text = widget.organization!.name;
      accountNumberController.text = widget.organization!.accountNumber;
      ifscCodeController.text = widget.organization!.ifscCode;
      cityController.text = widget.organization!.city;
      stateController.text = widget.organization!.state;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.organization == null
            ? 'Add Organization'
            : 'Edit Organization'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Organization Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // Add validation if needed
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: accountNumberController,
                  decoration: InputDecoration(
                    labelText: 'Account Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // Add validation if needed
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ifscCodeController,
                  decoration: InputDecoration(
                    labelText: 'IFSC Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // Add validation if needed
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(11), // Limit to 11 characters
                    FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')), // Allow only alphabets and digits
                    UppercaseTextInputFormatter(), // Automatically convert to uppercase
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // Add validation if needed
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  controller: stateController,
                  decoration: InputDecoration(
                    labelText: 'State',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // Add validation if needed
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () async {
                    // Create or update organization based on whether it's a new or existing organization
                    if (widget.organization == null) {
                      Organization newOrganization = Organization(
                        name: nameController.text,
                        accountNumber: accountNumberController.text,
                        ifscCode: ifscCodeController.text,
                        city: cityController.text,
                        state: stateController.text,
                      );
                      await dbHelper.insertOrganisation(newOrganization);
                    } else {
                      Organization updatedOrganization = widget.organization!.copyWith(
                        name: nameController.text,
                        accountNumber: accountNumberController.text,
                        ifscCode: ifscCodeController.text,
                        city: cityController.text,
                        state: stateController.text,
                      );
                      await dbHelper.updateOrganisation(updatedOrganization);
                    }

                    Navigator.pop(context); // Go back to the previous screen after saving
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Save', style: TextStyle(color: Colors.white),),
                ),
                const SizedBox(height: 25),
                if (widget.organization != null)
                  ElevatedButton(
                    onPressed: () async {
                      // Show confirmation dialog before deleting
                      bool confirmDelete = await _showDeleteConfirmationDialog(context);

                      if (confirmDelete) {
                        // Delete the organization if confirmed
                        await dbHelper.deleteOrganisation(widget.organization!.name);
                        Navigator.pop(context); // Go back to the previous screen after deleting
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
  bool? result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this organization?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // User canceled
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // User confirmed
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );

  return result ?? false; // Return false if result is null
}

class UppercaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}



