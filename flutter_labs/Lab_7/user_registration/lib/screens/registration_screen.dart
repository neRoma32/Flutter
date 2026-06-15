import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/validators.dart';
import '../widgets/password_section.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedCountry;
  final List<String> _countries = ['Ukraine', 'Poland', 'Germany', 'USA', 'UK'];
  String? _selectedGender;
  DateTime? _birthDate;
  
  bool _agreeToTerms = false;
  bool _subscribeToNewsletter = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  //дата народження
  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000), 
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _birthDate = date);
    }
  }

  void _register() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

//перевірка
    if (_birthDate == null) {
      _showError('Виберіть дату народження');
      return;
    }
    if (_selectedCountry == null) {
      _showError('Виберіть країну');
      return;
    }
    if (_selectedGender == null) {
      _showError('Виберіть стать');
      return;
    }
    if (!_agreeToTerms) {
      _showError('Погодьтесь з умовами');
      return;
    }

    final user = User(
      fullName: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      birthDate: _birthDate!,
      country: _selectedCountry!,
      gender: _selectedGender!,
      subscribeToNewsletter: _subscribeToNewsletter,
    );

    if (user.age < 18) {
      _showError('Вам повинно бути 18 або більше років (Вам ${user.age})');
      return;
    }

    _showSuccessDialog(user);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Expanded(child: Text('Registration Successful', style: TextStyle(fontSize: 18))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, ${user.fullName}!', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Email: ${user.email}'),
            Text('Phone: ${user.phone}'),
            Text('Country: ${user.country}'),
            Text('Gender: ${user.gender}'),
            Text('Age: ${user.age} years (${user.formattedBirthDate})'),
            const SizedBox(height: 16),
            Text('Verification email sent to ${user.email}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Personal Information', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name', 
                  prefixIcon: Icon(Icons.person), 
                  border: OutlineInputBorder()
                ),
                validator: (value) => Validators.required(value, fieldName: 'Name'),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email', 
                  prefixIcon: Icon(Icons.email), 
                  border: OutlineInputBorder()
                ),
                validator: Validators.combine([
                  (value) => Validators.required(value, fieldName: 'Email'), 
                  Validators.email
                ]),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone (+380...)', 
                  prefixIcon: Icon(Icons.phone), 
                  border: OutlineInputBorder()
                ),
                validator: Validators.combine([
                  (value) => Validators.required(value, fieldName: 'Phone'), 
                  Validators.phoneUA
                ]),
              ),
              const SizedBox(height: 24),

              //вибір дати
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(_birthDate != null
                    ? 'Birth Date: ${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'
                    : 'Select Birth Date'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _selectDate,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),

              //країна
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Country',
                  prefixIcon: Icon(Icons.flag),
                  border: OutlineInputBorder(),
                ),
                initialValue: _selectedCountry,
                items: _countries.map((country) {
                  return DropdownMenuItem(value: country, child: Text(country));
                }).toList(),
                onChanged: (value) => setState(() => _selectedCountry = value),
              ),
              const SizedBox(height: 24),

              //стать
              const Text('Gender', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Male'),
                      value: 'Male',
                      groupValue: _selectedGender,
                      onChanged: (value) => setState(() => _selectedGender = value),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Female'),
                      value: 'Female',
                      groupValue: _selectedGender,
                      onChanged: (value) => setState(() => _selectedGender = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              //віджет з паролями
              PasswordSection(
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
              ),

              const SizedBox(height: 24),

              CheckboxListTile(
                title: const Text('I agree to Terms and Conditions'),
                value: _agreeToTerms,
                onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: const Text('Subscribe to newsletter'),
                value: _subscribeToNewsletter,
                onChanged: (value) => setState(() => _subscribeToNewsletter = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('REGISTER', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}