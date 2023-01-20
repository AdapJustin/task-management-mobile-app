import 'package:flutter/material.dart';
import 'package:final_academic_project/constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:final_academic_project/Services/Notes_Database.dart';
import 'package:final_academic_project/Models/Note.dart';
import 'package:final_academic_project/Screens/SubPages/edit_note_page.dart';
import 'package:final_academic_project/Screens/SubPages/note_detail_page.dart';
import 'package:final_academic_project/WidgetS/note_card_widget.dart';

class Notes extends StatefulWidget {
  @override
  _Notes createState() => _Notes();
}

class _Notes extends State<Notes> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Notes',
          style: kTitleTextStyle,
        ),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator(
                color: Color.fromRGBO(0, 109, 119, 1.0),
                backgroundColor: Color.fromRGBO(0, 246, 242, 1.0),
              )
            : notes.isEmpty
                ? Text(
                    'No Notes',
                    style: TextStyle(color: Color(0xff83c5be), fontSize: 24),
                  )
                : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2.0,
        backgroundColor: kNotesAddColor,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditNotePage()),
          );
          refreshNotes();
        },
      ),
    );
  }
  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));
              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}
