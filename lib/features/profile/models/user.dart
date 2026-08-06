class User {
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.address,
    required this.city,
    required this.country,
    required this.postalCode,
    required this.memberSince,
    required this.loyaltyLevel,
    required this.totalOrders,
    required this.totalSpent,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String avatarUrl;
  final String address;
  final String city;
  final String country;
  final String postalCode;
  final DateTime memberSince;
  final String loyaltyLevel;
  final int totalOrders;
  final double totalSpent;

  String get fullName => '$firstName $lastName';

  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last';
  }
}
