import 'package:flutter/material.dart';

class SelectionWidget extends StatefulWidget {
  final String title;
  final List<String>? initialSelection;
  final List<Map<String, String>> options;
  final ValueChanged<List<String>>? onChanged;

  const SelectionWidget({
    super.key,
    required this.title,
    this.initialSelection,
    required this.options,
    this.onChanged,
  });

  @override
  _SelectionWidgetState createState() => _SelectionWidgetState();
}

class _SelectionWidgetState extends State<SelectionWidget> {
  List<String> selectedValues = [];

  @override
  void initState() {
    super.initState();
    selectedValues = widget.initialSelection ?? [];
  }

  void _showSelectionSheet(BuildContext context) {
    String? tempSelectedValue =
        selectedValues.isNotEmpty ? selectedValues.first : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "Select ${widget.title}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedValues = tempSelectedValue != null
                                ? [tempSelectedValue!]
                                : [];
                          });
                          widget.onChanged?.call(selectedValues);
                          Navigator.pop(context);
                        },
                        child: Text("Done", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.options.length,
                      itemBuilder: (context, index) {
                        String label = widget.options[index]['label']!;
                        String value = widget.options[index]['value']!;
                        return ListTile(
                          title: Text(label),
                          trailing: tempSelectedValue == value
                              ? Icon(Icons.check, color: Colors.redAccent)
                              : null,
                          onTap: () {
                            setStateBottomSheet(() {
                              tempSelectedValue = value;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String selectedLabel = selectedValues.isNotEmpty
        ? widget.options.firstWhere(
            (option) => option['value'] == selectedValues.first,
            orElse: () => {"label": "Unknown"},
          )['label']!
        : "Add";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showSelectionSheet(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.title}: ",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Text(
                    selectedLabel,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color:
                            selectedValues.isEmpty ? Colors.grey : Colors.black,
                        fontSize: 16),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
