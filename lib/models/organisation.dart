class Organization {
  // String id;
  String name;
  String accountNumber;
  String ifscCode;
  String city;
  String state;
  String? phoneNumber;
  String? description;

  // Constructor
  Organization({
    // required this.id,
    required this.name,
    required this.accountNumber,
    required this.ifscCode,
    required this.city,
    required this.state,
    this.phoneNumber,
    this.description,
  });

  Organization copyWith({
    // String? id,
    String? name,
    String? accountNumber,
    String? ifscCode,
    String? city,
    String? state,
    String? phoneNumber,
    String? description,
  }) {
    return Organization(
      // id: id ?? this.id,
      name: name ?? this.name,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      city: city ?? this.city,
      state: state ?? this.state,
      phoneNumber: state ?? this.phoneNumber,
      description: state ?? this.description,
    );
  }

  // Factory constructor for creating an Organization from a map (e.g., when retrieving from a database)
  factory Organization.fromMap(Map<String, dynamic> map) {
    return Organization(
      // id: map['id'],
      name: map['name'],
      accountNumber: map['accountNumber'],
      ifscCode: map['ifscCode'],
      city: map['city'],
      state: map['state'],
      phoneNumber: map['phoneNumber'],
      description: map['description'],
    );
  }

  // Method to convert Organization to a map (e.g., for storing in a database)
  Map<String, dynamic> toMap() {
    return {
      // 'id' : id,
      'name': name,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'city': city,
      'state': state,
      'phoneNumber': phoneNumber,
      'description': description,
    };
  }
}
