import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ITP107 Lab 3 - Sign Up',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Dropdown - Course
  final List<String> _courses = [
    'BS Information Technology',
    'BS Computer Science',
    'BS Information Systems',
    'BS Computer Engineering',
  ];
  String? _selectedCourse;

  // Radio - Gender
  String? _selectedGender;

  // Checkbox - Terms and Conditions
  bool _agreedToTerms = false;

  // Slider - Age
  double _age = 18;

  // DatePicker - Birthdate
  DateTime? _selectedBirthdate;

  // Gesture Detector state (Sign-Up button box)
  Color _boxColor = Colors.grey.shade300;
  String _gestureMessage = 'Tap, double tap, or long-press Sign Up';

  // ----- Validators -----
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name cannot be empty';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address (e.g., name@example.com)';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // ----- DatePicker -----
  Future<void> _pickBirthdate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedBirthdate = picked;
      });
    }
  }

  String get _formattedBirthdate {
    if (_selectedBirthdate == null) return 'No date selected';
    return '${_selectedBirthdate!.month.toString().padLeft(2, '0')}/'
        '${_selectedBirthdate!.day.toString().padLeft(2, '0')}/'
        '${_selectedBirthdate!.year}';
  }

  // ----- Gesture handlers -----
  void _onSingleTap() {
    if (!_validateFormBeforeGesture()) return;
    setState(() {
      _boxColor = Colors.green;
      _gestureMessage = '👆 Single Tap Detected!';
    });
  }

  void _onDoubleTap() {
    if (!_validateFormBeforeGesture()) return;
    setState(() {
      _boxColor = Colors.orange;
      _gestureMessage = '👏 Double Tap Detected!';
    });
  }

  void _onLongPress() {
    if (!_validateFormBeforeGesture()) return;
    setState(() {
      _boxColor = Colors.red;
      _gestureMessage = '✋ Long Press Detected!';
    });
  }

  // Runs full form validation + checks terms checkbox.
  // Returns true if valid, shows a SnackBar and returns false otherwise.
  bool _validateFormBeforeGesture() {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must agree to the Terms and Conditions.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fill out the form below to get started',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),

                // Full Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 16),

                // Dropdown - Course
                DropdownButtonFormField<String>(
                  value: _selectedCourse,
                  decoration: const InputDecoration(
                    labelText: 'Course',
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                  items: _courses
                      .map((course) => DropdownMenuItem(
                            value: course,
                            child: Text(course),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCourse = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a course' : null,
                ),
                const SizedBox(height: 16),

                // Radio - Gender
                const Text(
                  'Gender',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Male'),
                        value: 'Male',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() => _selectedGender = value);
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Female'),
                        value: 'Female',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() => _selectedGender = value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Slider - Age
                Text(
                  'Age: ${_age.round()} years old',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Slider(
                  value: _age,
                  min: 13,
                  max: 100,
                  divisions: 87,
                  label: '${_age.round()}',
                  onChanged: (value) {
                    setState(() {
                      _age = value;
                    });
                  },
                ),
                const SizedBox(height: 8),

                // DatePicker - Birthdate
                const Text(
                  'Birthdate',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _pickBirthdate,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 20),
                        const SizedBox(width: 10),
                        Text(_formattedBirthdate),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Checkbox - Terms and Conditions
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _agreedToTerms,
                  title: const Text('I agree to the Terms and Conditions'),
                  onChanged: (value) {
                    setState(() {
                      _agreedToTerms = value ?? false;
                    });
                  },
                ),
                if (!_agreedToTerms)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      'You must agree before continuing',
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // ----- Gesture-detected Sign-Up button -----
                Center(
                  child: GestureDetector(
                    onTap: _onSingleTap,
                    onDoubleTap: _onDoubleTap,
                    onLongPress: _onLongPress,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: _boxColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _gestureMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Single tap = green, double tap = orange, long press = red',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}