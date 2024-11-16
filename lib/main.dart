import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Étudiants',
      home: StudentListScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class Student {
  String nom;
  String prenom;
  String email;
  String universite;

  Student(this.nom, this.prenom, this.email, this.universite);
}

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> students = [];

  void addStudent(Student student) {
    setState(() {
      students.add(student);
    });
  }

  void deleteStudent(Student student) {
    setState(() {
      students.remove(student);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Liste des Étudiants'),
            SizedBox(width: 20),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                final newStudent = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddStudentScreen(),
                  ),
                );
                if (newStudent != null) {
                  addStudent(newStudent);
                }
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              title: Text('${student.nom} ${student.prenom}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text(student.universite, style: TextStyle(color: Colors.grey[700])),
              trailing: Icon(Icons.chevron_right, color: Colors.blue),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentDetailScreen(
                      student: student,
                      onDelete: () {
                        deleteStudent(student);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class AddStudentScreen extends StatefulWidget {
  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _universiteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nouvel Étudiant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _prenomController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _universiteController,
                decoration: InputDecoration(
                  labelText: 'Université',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: Icon(Icons.school),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newStudent = Student(
                      _nomController.text,
                      _prenomController.text,
                      _emailController.text,
                      _universiteController.text,
                    );
                    Navigator.pop(context, newStudent);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('AJOUTER', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentDetailScreen extends StatelessWidget {
  final Student student;
  final VoidCallback onDelete;

  StudentDetailScreen({required this.student, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Détails de l\'Étudiant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nom:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(student.nom, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text('Prénom:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(student.prenom, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text('Email:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(student.email, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text('Université:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(student.universite, style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onDelete,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Supprimer', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
