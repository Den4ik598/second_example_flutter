
  import 'package:flutter/material.dart';
import 'package:login/main_window/dto/list_item.dart';
import 'package:login/main_window/providers/list_provider.dart';
  import 'package:provider/provider.dart';



  enum ItemType { Heavy, Medium, Light }

  class AddItemForm extends StatefulWidget {
    const AddItemForm({required this.context, super.key});

    final BuildContext context;

    @override
    _AddItemFormState createState() => _AddItemFormState();
  }

  class _AddItemFormState extends State<AddItemForm> {
    late TextEditingController _nameController;
    late TextEditingController _typeController;
    late TextEditingController _pauseController;
    late TextEditingController _countPause;
    ItemType _selectedType = ItemType.Light;
    double _currentPauseValue = 0.0;
    
    @override
    void initState() {
      super.initState();
      _nameController = TextEditingController();
      _typeController = TextEditingController();
      _pauseController = TextEditingController();
      _countPause = TextEditingController();
    }

    
    @override
    void dispose() {
      _nameController.dispose();
      _typeController.dispose();
      _pauseController.dispose();
      _countPause.dispose();
      super.dispose();
    }
    
    @override
    Widget build(BuildContext context) {
      return Container(
          width: 550.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            Row(
              children: [
                Radio(
                  value: ItemType.Heavy,
                  groupValue: _selectedType,
                  onChanged: (ItemType? value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                const Text('Heavy'),

                Radio(
                  value: ItemType.Medium,
                  groupValue: _selectedType,
                  onChanged: (ItemType? value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                const Text('Medium'),

                Radio(
                  value: ItemType.Light,
                  groupValue: _selectedType,
                  onChanged: (ItemType? value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                const Text('Light'),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pause: ${_currentPauseValue.toInt()} seconds'),
              Expanded(
                child: Slider(
                  value: _currentPauseValue,
                  min: 0,
                  max: 60,
                  divisions: 60,
                  onChanged: (value) {
                    setState(() {
                      _currentPauseValue = value;
                    });
                  },
                ),
              ),
            ],
          ),
            TextField(
              controller: _countPause,
              decoration: const InputDecoration(labelText: 'Count Pause'),
              keyboardType: TextInputType.number,
            ),
          ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                String name = _nameController.text;
                String type = _typeController.text;
                String pauseStr = _pauseController.text;
                String countPauseStr = _countPause.text;
                if (name.isNotEmpty && type.isNotEmpty && pauseStr.isNotEmpty) {
                  int pause = int.parse(pauseStr);
                  int countpause = int.parse(countPauseStr);
                  ListProvider listProvider = Provider.of<ListProvider>(widget.context, listen: false);
                  listProvider.addItem(ListItem(name: name, type: type, pause: pause, count: countpause));
                  
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      );
    }
  }