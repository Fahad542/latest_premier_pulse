import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvvm/res/color.dart';
import '../../model/measures.dart';
import '../../respository/measure_repository.dart';


class filters extends StatefulWidget {
  final Function( List<String> ) onSelectionDone;
  final List< String > selectedvalues;
  final List<Map<String, dynamic>> selectedVal;

  filters({
    this.selectedVal = const [],
    required this.onSelectionDone,
    this.selectedvalues = const [],
  });

  @override
  _FiltersState createState( ) => _FiltersState( );
}

class _FiltersState extends State<filters> {
  final repository = measure_repository();

  List<String> groupNames = [];
  List<String> selectedValues = [];
  List<Map<String, dynamic>> selectedVal = [];
  List<bool> checkAll = [];

  @override
  void initState() {
    super.initState();

    selectedValues = List<String>.from(widget.selectedvalues);
    fetchGroupNames();
  }

  Future<void> fetchGroupNames() async {
    final List<Measure> measures = await repository.getAllMeasuresGroupByGroupName();
    setState(() {
      groupNames = measures.map((measure) => measure.measureGroupName).toList();
    });
  }

  void updateSelectedValues(String value, bool isChecked) {
    setState(() {
      if (isChecked) {
        selectedValues.add(value);
      } else {
        selectedValues.remove(value);
      }
    });
  }

  void updateValues(String value, bool isChecked) {
    setState(() {
      if (isChecked) {
        selectedVal.add({
          "value": value,
          "check": isChecked,
        });
      } else {
        selectedVal.removeWhere((item) => item['value'] == value);
      }
    });
  }

  void clearAllCheckBoxes() {
    setState(() {

      selectedValues.clear();

    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Select any 4 Measures',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.greencolor),
      ),
      content: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: double.maxFinite,
          child: Column(
            children: [
              Container(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedValues.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.greencolor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  selectedValues[index],
                                  style: TextStyle(
                                    color: AppColors.greencolor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                SizedBox(width: 2),
                                GestureDetector(
                                  onTap: () {
                                    updateSelectedValues(selectedValues[index], false);
                                  },
                                  child: Icon(Icons.cancel),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Count: ${selectedValues.length}",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.greencolor),
                  ),
                  ElevatedButton(
                    onPressed: clearAllCheckBoxes,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                      minimumSize: MaterialStateProperty.all<Size>(Size(40, 25)),
                    ),
                    child: Text('Clear'),
                  ),
                ],
              ),
              Expanded(
                flex: 10,
                child: SingleChildScrollView(
                  child: Column(
                    children: groupNames.map((groupName) {
                      return FilterGroup(
                        groupName: groupName,
                        repository: repository,
                        onSelectionChanged: updateSelectedValues,
                        selectedValues: selectedValues,
                       // onClearAll: clearAllCheckBoxes,
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 4),
              InkWell(
                onTap: () {
                  if (selectedValues.length > 4) {
                    Fluttertoast.showToast(
                      msg: "You have reached the maximum number of selections.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    Navigator.of(context).pop();
                    widget.onSelectionDone(selectedValues);
                  }
                },
                child: Container(
                  height: 35,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.greencolor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Done", style: TextStyle(color: Colors.white)),
                    ],
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

class FilterGroup extends StatefulWidget {
  final String groupName;
  final measure_repository repository;
  final Function(String, bool) onSelectionChanged;
  final List<String> selectedValues;
  FilterGroup( {
    required this.groupName,
    required this.repository,
    required this.onSelectionChanged,
    required this.selectedValues,
  });

  @override
  _FilterGroupState createState() => _FilterGroupState();
}

class _FilterGroupState extends State<FilterGroup> {
  bool showChildren = false;
  List<String> displayFolders = [];

  @override
  void initState() {
    super.initState();
    fetchDisplayFolders();
  }

  Future<void> fetchDisplayFolders() async {
    List<String> folders = await widget.repository.getDisplayFoldersByGroupName(widget.groupName);
    setState(() {
      displayFolders = folders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                showChildren = !showChildren;
              });
            },
            child: Row(
              children: [
            Container(
            padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.greencolor
      ),
      child:Icon(
                  showChildren ? Icons.remove : Icons.add,
                  color: showChildren ? Colors.white : AppColors.whiteColor,
                  size: 14,
                ),
            ),
                SizedBox(width: 8),
                Text(
                  widget.groupName,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          if (showChildren)
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Column(
                children: displayFolders.map((folder) {
                  return FolderItem(
                    folderName: folder,
                    repository: widget.repository,
                    onSelectionChanged: widget.onSelectionChanged,
                    selectedValues: widget.selectedValues,
                    //onClearAll: widget.onClearAll,
                    groupName: widget.groupName,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class FolderItem extends StatefulWidget {
  final String folderName;
  final String groupName;
  final measure_repository repository;
  final Function(String, bool) onSelectionChanged;
  final List<String> selectedValues;

  FolderItem( {
    required this.groupName,
    required this.folderName,
    required this.repository,
    required this.onSelectionChanged,
    required this.selectedValues,

      } ) : super( );

  @override
  _FolderItemState createState() => _FolderItemState();
}

class _FolderItemState extends State<FolderItem> {
  bool showChildren = false;
  List<String> displayNames = [];
  List<bool> isCheckedList = [];

  @override
  void initState() {
    super.initState();
    fetchDisplayNames();
  }

  @override
  void didUpdateWidget(FolderItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    isCheckedList = displayNames.map((name) => widget.selectedValues.contains(name)).toList();
  }

  Future<void> fetchDisplayNames() async {
    List<String> names = await widget.repository.getDisplayFoldersByName(widget.folderName, widget.groupName);
    setState(() {
      displayNames = names;
      isCheckedList = displayNames.map((name) => widget.selectedValues.contains(name)).toList();
    });
  }

  @override
  Widget build( BuildContext context ) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, top: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                showChildren = !showChildren;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.greencolor
                    ),
                    child: Icon(
                      showChildren ? Icons.remove : Icons.add,
                      color: showChildren ? Colors.white : AppColors.whiteColor,
                      size: 14,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.folderName,
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,  // Add ellipsis if the text overflows
                      softWrap: true,  // Allow text to wrap to the next line if needed
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showChildren)
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Column(
                children: displayNames.asMap().entries.map((entry) {
                  int index = entry.key;
                  String name = entry.value;
                  return CheckboxListTile(
                    title: Text(name, style: TextStyle(fontSize: 12)),
                    value: isCheckedList[index],
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedList[index] = value!;
                        widget.onSelectionChanged(name, value);
                      });
                    },
                    activeColor: AppColors.greencolor,
                    contentPadding: EdgeInsets.symmetric(vertical: 0),  // Reduced the padding
                    dense: true,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}











