class User {
  final int id;
  final String name;
  final String job;
  final String email;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.job,
    required this.email,
    required this.phone,
  });

  User copyWith({
    int? id,
    String? name,
    String? job,
    String? email,
    String? phone,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      job: job ?? this.job,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}

final List<User> sampleUsers = [
  User(
    id: 1,
    name: 'John Doe',
    job: 'Flutter Developer',
    email: 'john@example.com',
    phone: '+380 50 123 45 67',
  ),
  User(
    id: 2,
    name: 'Jane Smith',
    job: 'UI/UX Designer',
    email: 'jane@example.com',
    phone: '+380 67 111 22 33',
  ),
  User(
    id: 3,
    name: 'Bob Johnson',
    job: 'Project Manager',
    email: 'bob@example.com',
    phone: '+380 93 444 55 66',
  ),
];