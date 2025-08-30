import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MY CARE',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFF5F5DC),
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


// ---------------- Login Screen ----------------

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged in successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MedicationInputScreen()),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!value.contains('@') || !value.contains('.')) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFF8B7355).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.medical_services,
                        size: 60,
                        color: Color(0xFF8B7355),
                      ),
                    ),
                    const SizedBox(height: 30),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'MY',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5D4037),
                            ),
                          ),
                          TextSpan(
                            text: ' CARE',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B7355),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'We are here to take care your health',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8B7355),
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'EMAIL',
                        prefixIcon: Icon(Icons.email, color: Color(0xFF8B7355)),
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Color(0xFF8B7355)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'PASSWORD',
                        labelStyle: const TextStyle(color: Color(0xFF8B7355)),
                        prefixIcon: const Icon(Icons.lock, color: Color(0xFF8B7355)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: const Color(0xFF8B7355),
                          ),
                          onPressed: () {
                            setState(() => _isPasswordVisible = !_isPasswordVisible);
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot your password?',
                          style: TextStyle(color: Color(0xFF8B7355)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B7355),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: _isLoading ? null : _login,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'LOG IN',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "DO NOT HAVE AN ACCOUNT",
                          style: TextStyle(color: Color(0xFF8B7355)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()),
                            );
                          },
                          child: const Text(
                            'SIGN UP',
                            style: TextStyle(
                              color: Color(0xFF5D4037),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- SignUp Screen ----------------

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MedicationInputScreen()),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!value.contains('@') || !value.contains('.')) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color(0xFF8B7355),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Color(0xFF8B7355),
                    ),
                    onPressed: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
                  ),
                ),
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B7355),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'CREATE ACCOUNT',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Medication Input Screen ----------------

class MedicationInputScreen extends StatefulWidget {
  const MedicationInputScreen({super.key});

  @override
  State<MedicationInputScreen> createState() => _MedicationInputScreenState();
}

class _MedicationInputScreenState extends State<MedicationInputScreen> {
  final TextEditingController _medicationController = TextEditingController();
  final List<String> _medications = [];

  @override
  void dispose() {
    _medicationController.dispose();
    super.dispose();
  }

  Future<void> sendMedicineToAPI(String medicineName) async {
    final url = Uri.parse('http://192.168.1.12:8000/add_medicine');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": medicineName,
        "category": "Painkiller",
        "description": "Used to relieve pain",
        "usage": "Take 1 every 8 hours",
        "manufacture_date": "2024-01-01",
        "expiration_date": "2026-01-01",
        "dose": "500mg"
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("✅ Added successfully! ID = \${data['medicine_id']}");
    } else {
      print("❌ Error: \${response.statusCode}");
    }
  }

  void _saveMedication() {
    String enteredText = _medicationController.text.trim();
    if (enteredText.isNotEmpty) {
      setState(() {
        _medications.add(enteredText);
        _medicationController.clear();
      });
      sendMedicineToAPI(enteredText); // ← send to API here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Medicine entered: \$enteredText'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _doneEntering() {
    if (_medications.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (context) => MedicationTableScreen(medications: _medications),
          builder: (context) => const MedicationTableScreen(),

        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Medicine Name'),
        backgroundColor: const Color(0xFF8B7355),
      ),
      backgroundColor: const Color(0xFFF5F5DC),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextField(
              controller: _medicationController,
              decoration: InputDecoration(
                labelText: 'Medicine Name',
                labelStyle: const TextStyle(color: Color(0xFF8B7355)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF8B7355)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      const BorderSide(color: Color(0xFF5D4037), width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveMedication,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B7355),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'SAVE',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _doneEntering,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D4037),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'DONE',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ---------------- Medication Table Screen ----------------



class MedicationTableScreen extends StatefulWidget {
  const MedicationTableScreen({super.key});

  @override
  State<MedicationTableScreen> createState() => _MedicationTableScreenState();
}

class _MedicationTableScreenState extends State<MedicationTableScreen> {
  List<dynamic> _medications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMedications();
  }

  Future<void> fetchMedications() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.12:8000/all_medicines'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _medications = data;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load medications');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: const Text('Medication List'),
        backgroundColor: const Color(0xFF8B7355),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Camera feature coming soon'),
                  backgroundColor: Colors.brown,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MedicationNotificationScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _medications.isEmpty
                ? const Center(
                    child: Text(
                      'No medications found.',
                      style: TextStyle(fontSize: 18, color: Color(0xFF5D4037)),
                    ),
                  )
                : ListView.builder(
                    itemCount: _medications.length,
                    itemBuilder: (context, index) {
                      final med = _medications[index];
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: const Icon(Icons.medication, color: Color(0xFF8B7355)),
                          title: Text(
                            med['name'] ?? 'Unknown',
                            style: const TextStyle(
                                color: Color(0xFF5D4037), fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Dose: ${med['dose'] ?? 'N/A'}\nCategory: ${med['category'] ?? 'N/A'}\nUsage: ${med['usage'] ?? 'N/A'}',
                            style: const TextStyle(color: Color(0xFF8B7355), fontSize: 12),
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

// ملاحظة: تأكد أنك عرّفت MedicationNotificationScreen سابقًا.


// ---------------- Camera Screen ----------------

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image captured. (Future: analyze and extract drug info)'),
          backgroundColor: Colors.brown,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Medicine'),
        backgroundColor: const Color(0xFF8B7355),
      ),
      backgroundColor: const Color(0xFFF5F5DC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!, height: 250)
                : const Icon(Icons.camera_alt, size: 100, color: Color(0xFF8B7355)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Capture Medicine Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B7355),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

                
//---------notification interface------------
class MedicationNotificationScreen extends StatelessWidget {
  const MedicationNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {'medicine': 'Paracetamol', 'time': '8:00 AM'},
      {'medicine': 'Ibuprofen', 'time': '12:00 PM'},
      {'medicine': 'Vitamin C', 'time': '6:00 PM'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Reminders'),
        backgroundColor: const Color(0xFF8B7355),
      ),
      backgroundColor: const Color(0xFFF5F5DC),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 3,
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.access_alarm, color: Color(0xFF8B7355)),
              title: Text(item['medicine']!, style: const TextStyle(color: Color(0xFF5D4037))),
              subtitle: Text('Take at ${item['time']}', style: const TextStyle(color: Color(0xFF8B7355))),
            ),
          );
        },
      ),
    );
  }
}
