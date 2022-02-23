import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class addnote extends StatefulWidget {
  const addnote({Key? key}) : super(key: key);

  @override
  _addnoteState createState() => _addnoteState();
}

class _addnoteState extends State<addnote> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  final fb = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    final text = TextFormField(
      autofocus: false,
      controller: title,
      // keyboardType: TextInputType.emailAddress,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ("Please cannot be Empty!");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter (Min. 2 Characters)");
        }
        return null;
      },
      onSaved: (value) {
        title.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.note_add),
          contentPadding: EdgeInsets.fromLTRB(12, 15, 20, 15),
          hintText: "Enter Here",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final savebtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(12, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Save(title.text);
        },
        child: Text(
          "Save",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.red,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        "Group 06",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    text,
                    SizedBox(
                      height: 20,
                    ),
                    savebtn
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void Save(String text) async {
    final ref = fb.ref().child('todolist');
    if (_formKey.currentState!.validate()) {
      await ref.push().set(title.text).asStream();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Home()));
    }
  }
}
