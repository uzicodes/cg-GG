import 'package:flutter/material.dart';

void main() {
  runApp(const CGPACalculatorApp());
}

class CGPACalculatorApp extends StatelessWidget {
  const CGPACalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CGPA Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UniversitySelectionScreen(),
    );
  }
}

class UniversitySelectionScreen extends StatefulWidget {
  const UniversitySelectionScreen({super.key});

  @override
  State<UniversitySelectionScreen> createState() =>
      _UniversitySelectionScreenState();
}

class _UniversitySelectionScreenState extends State<UniversitySelectionScreen> {
  final List<String> universities = [
    'BRAC University',
    'North South University',
    'AIUB',
    'IUB',
    'East West University',
    'UIU',
    'ULAB',
    'Daffodil University',
  ];
  String? selectedUniversity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select University'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose your University',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'University',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    filled: true,
                  ),
                  value: selectedUniversity,
                  items: universities
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedUniversity = value;
                    });
                  },
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: selectedUniversity == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseEntryScreen(
                                university: selectedUniversity!,
                              ),
                            ),
                          );
                        },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text('Next', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CourseEntryScreen extends StatefulWidget {
  final String university;
  const CourseEntryScreen({super.key, required this.university});

  @override
  State<CourseEntryScreen> createState() => _CourseEntryScreenState();
}

class _CourseEntryScreenState extends State<CourseEntryScreen> {
  final List<Map<String, dynamic>> courses = [];
  final _formKey = GlobalKey<FormState>();
  final _courseNameController = TextEditingController();
  final _gradeController = TextEditingController();
  final _creditController = TextEditingController();

  @override
  void dispose() {
    _courseNameController.dispose();
    _gradeController.dispose();
    _creditController.dispose();
    super.dispose();
  }

  void _addCourse() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        courses.add({
          'name': _courseNameController.text,
          'grade': _gradeController.text,
          'credit': double.tryParse(_creditController.text) ?? 0.0,
        });
        _courseNameController.clear();
        _gradeController.clear();
        _creditController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses -  {widget.university}'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _courseNameController,
                          decoration: const InputDecoration(
                            labelText: 'Course Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            filled: true,
                          ),
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _gradeController,
                          decoration: const InputDecoration(
                            labelText: 'Grade',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            filled: true,
                          ),
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _creditController,
                          decoration: const InputDecoration(
                            labelText: 'Credit',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            filled: true,
                          ),
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.tonal(
                        onPressed: _addCourse,
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: courses.isEmpty
                  ? const Center(child: Text('No courses added yet.'))
                  : ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 1,
                          child: ListTile(
                            title: Text(
                              '${course['name']} (${course['credit']} credits)',
                            ),
                            subtitle: Text('Grade: ${course['grade']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                setState(() {
                                  courses.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: courses.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(
                            courses: courses,
                            university: widget.university,
                          ),
                        ),
                      );
                    },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text('Calculate CGPA', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  final String university;

  const ResultScreen({
    super.key,
    required this.courses,
    required this.university,
  });

  @override
  Widget build(BuildContext context) {
    // Placeholder CGPA calculation
    double cgpa = 0.0;
    if (courses.isNotEmpty) {
      cgpa = 3.5; // Replace with real logic later
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CGPA Result'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'University: $university',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                const Text('Your CGPA is:', style: TextStyle(fontSize: 18)),
                Text(
                  cgpa.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.tonal(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text('Start Over'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
