import 'package:flutter/material.dart';
import 'package:flutter_july25/dummy_db.dart';
import 'package:flutter_july25/utils/app_sections.dart';
import 'package:flutter_july25/view/note_card/note_card.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  int selectedColorIndex = 0;

  var noteBox = Hive.box(AppSections.NOTEBOX);
  List noteKeys = [];

  @override
  void initState() {
    super.initState();
    noteKeys = noteBox.keys.toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey.shade300,
          onPressed: () {
            titleController.clear();
            descController.clear();
            dateController.clear();
            selectedColorIndex = 0;
            _customBottomSheet(context);
          },
          child: Icon(Icons.add),
        ),
        body: noteKeys.isEmpty
            ? Center(child: Text("No notes available"))
            : ListView.separated(
                padding: EdgeInsets.all(15),
                itemBuilder: (context, index) {
                  var currentNote = noteBox.get(noteKeys[index]);
                  return NoteCard(
                    noteColor: DummyDb.noteColors[currentNote["colorIndex"]],
                    date: currentNote["date"],
                    desc: currentNote["desc"],
                    title: currentNote["title"],
                    onDelete: () {
                      noteBox.delete(noteKeys[index]);
                      noteKeys = noteBox.keys.toList();
                      setState(() {});
                    },
                    onEdit: () {
                      titleController.text = currentNote["title"];
                      dateController.text = currentNote["date"];
                      descController.text = currentNote["desc"];
                      selectedColorIndex = currentNote["colorIndex"];
                      _customBottomSheet(context,
                          isEdit: true, itemIndex: index);
                    },
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemCount: noteKeys.length,
              ),
      ),
    );
  }

  Future<dynamic> _customBottomSheet(BuildContext context,
      {bool isEdit = false, int? itemIndex}) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Title",
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: descController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Description",
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(
                  hintText: "Date",
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      var selectedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                      );
                      if (selectedDate != null) {
                        dateController.text =
                            DateFormat("dd MMMM, y").format(selectedDate);
                      }
                    },
                    icon: Icon(Icons.calendar_month_outlined),
                  ),
                ),
              ),
              SizedBox(height: 20),
              StatefulBuilder(
                builder: (context, setColorState) => Row(
                  children: List.generate(
                    DummyDb.noteColors.length,
                    (index) => Expanded(
                      child: InkWell(
                        onTap: () {
                          selectedColorIndex = index;
                          setColorState(() {});
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: 50,
                          decoration: BoxDecoration(
                            border: selectedColorIndex == index
                                ? Border.all(width: 3)
                                : null,
                            color: DummyDb.noteColors[index],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (isEdit) {
                          DummyDb.notesList[itemIndex!] = {
                            "title": titleController.text,
                            "desc": descController.text,
                            "colorIndex": selectedColorIndex,
                            "date": dateController.text,
                          };
                          noteBox.put(noteKeys[itemIndex],
                              DummyDb.notesList[itemIndex]);
                        } else {
                          var newNote = {
                            "title": titleController.text,
                            "desc": descController.text,
                            "date": dateController.text,
                            "colorIndex": selectedColorIndex,
                          };
                          noteBox.add(newNote);
                          noteKeys = noteBox.keys.toList();
                        }
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isEdit ? "Update" : "Save",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
