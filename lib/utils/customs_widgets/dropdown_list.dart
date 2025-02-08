import 'package:flutter/material.dart';

class DropdownCheckboxDialog extends StatefulWidget {
  final List<String> items;
  final List<String> initialSelectedValues;
  final String title;
  final void Function(List<String> selectedValues, List<String> name) onDone;
  final void Function() onTapDone;

  DropdownCheckboxDialog(BuildContext context, {
    required this.items,
    required this.initialSelectedValues,
    required this.title,
    required this.onDone,
    required this.onTapDone,
  });

  @override
  _DropdownCheckboxDialogState createState() => _DropdownCheckboxDialogState();
}

class _DropdownCheckboxDialogState extends State<DropdownCheckboxDialog> {
  late List<String> filteredItems;
  late List<bool> selectedItems;
  late List<String> selectedToAdd;
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();

    filteredItems = List.from(widget.items);
    selectedItems = List.generate(
      widget.items.length,
          (index) => widget.initialSelectedValues.contains(widget.items[index]),
    );
    selectedToAdd = List.from(widget.initialSelectedValues);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      title: Center(
        child: Text(
          widget.title,
          style: TextStyle(color: Colors.green[800]),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      content: Container(
        height: screenHeight * 0.8,
        width: screenWidth * 1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              height: 35,
              decoration: BoxDecoration(
                color: Colors.green[800],
                borderRadius: BorderRadius.circular(17),
              ),
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: TextField(
                  controller: _searchController,
                  textAlign: TextAlign.start,
                  onChanged: (value) {
                    setState(() {
                      filteredItems = widget.items
                          .where((item) =>
                          item.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                child: SizedBox(
                  height: 30,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: selectedToAdd
                        .map(
                          (item) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Chip(
                          backgroundColor: Colors.green.shade100,
                          label: Text(
                            item,
                            style: TextStyle(fontSize: 12),
                          ),
                          onDeleted: () {
                            setState(() {
                              selectedToAdd.remove(item);
                              selectedItems[widget.items.indexOf(item)] = false;
                            });
                          },
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Text(
                            filteredItems[index],
                            style: TextStyle(
                              color: Colors.green[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          value: selectedItems[index],
                          onChanged: (bool? value) {
                            setState(() {
                              selectedItems[index] = !selectedItems[index];
                              if (selectedItems[index]) {
                                selectedToAdd.add(filteredItems[index]);
                              } else {
                                selectedToAdd.remove(filteredItems[index]);
                              }
                            });
                          },
                          activeColor: Colors.green[800],
                          checkColor: Colors.white,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  List<String> selectedItemsList = [];
                  for (int i = 0; i < widget.items.length; i++) {
                    if (selectedItems[i]) {
                      selectedItemsList.add(widget.items[i]);
                    }
                  }

                  List<String> extractedIds = [];
                  List<String> company = [];
                  for (String value in selectedItemsList) {
                    String id = value.split(' ')[0];
                    String name = value.split(' ').skip(2).join(' ');
                    extractedIds.add('"$id"');
                    company.add(name);
                  }

                  widget.onDone(extractedIds, company);
                  widget.onTapDone();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Done', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}