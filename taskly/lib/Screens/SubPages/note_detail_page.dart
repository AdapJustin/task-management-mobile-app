import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_academic_project/Services/Notes_Database.dart';
import 'package:final_academic_project/Models/Note.dart';
import 'package:final_academic_project/Screens/SubPages/edit_note_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              FontAwesomeIcons.angleLeft,
              color: Color.fromRGBO(78, 77, 77, 0.7019607843137254),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit_outlined),
              color: Color(0xff191D21),
              onPressed: () async {
                if (isLoading) return;

                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddEditNotePage(note: note),
                ));
                refreshNote();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Color(0xff191D21),
              onPressed: () async {
                await NotesDatabase.instance.delete(widget.noteId);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: isLoading
            ? Center(
                child:CircularProgressIndicator(
                  color: Color.fromRGBO(0, 109, 119, 1.0),
                  backgroundColor: Color.fromRGBO(0, 246, 242, 1.0),
                ),
              )
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(
                        color: Color(0xff191D21),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMd().format(note.createdTime),
                      style: TextStyle(color: Color(0xff191D21)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      note.description,
                      style: TextStyle(color: Color(0xff191D21), fontSize: 18),
                    ),
                  ],
                ),
              ),
      );
}
