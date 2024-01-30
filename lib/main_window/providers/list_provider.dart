import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dto/list_item.dart';

class ListProvider extends ChangeNotifier {
  ListProvider(){
    loadItems();
  }
  List<ListItem> _items = [];
  
  List<ListItem> get items => _items;
  
  void addItem(ListItem item) {
    _items.add(item);
    saveItems();
    notifyListeners();
  }
  
  void removeItem(int index) {
    _items.removeAt(index);
    saveItems();
    notifyListeners();
  }
  
  void loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? itemList = prefs.getStringList('items');
    
    if (itemList != null) {
      _items = itemList.map((item) {
        List<String> itemData = item.split(':');
        return ListItem(name: itemData[0], type: itemData[1], pause: int.parse(itemData[2]), count: int.parse(itemData[3]));
      }).toList();
      
      notifyListeners();
    }
  }
  
  Future<void> startvibrate(ListItem item) async {
    SharedPreferences prefs =
      await SharedPreferences.getInstance();
    int vibrationDuration =
       prefs.getInt('${item.name}_count') ?? 0;
    int vibrationPause =
       prefs.getInt('${item.name}_pause') ?? 0;

    String vibretionlevel = 
       prefs.getString('${item.name}__level') ?? 'Light';

    if (vibrationPause == 0){
      changelevelvibrate(vibretionlevel);
    } else {
      final List<Duration> pauses = [];
      for (int i=0;i<vibrationDuration;i++) {
        Duration pauseDuration = Duration(seconds: vibrationPause);
        pauses.add(pauseDuration);
      }
      Vibrate.vibrateWithPauses(pauses);
    }
  }

  void changelevelvibrate(String vibretionlevel){
    switch(vibretionlevel){
      case 'Light':
        Vibrate.feedback(FeedbackType.light);
        break;
      case 'Medium':
        Vibrate.feedback(FeedbackType.medium);
        break;
      case 'Heavy':
        Vibrate.feedback(FeedbackType.heavy);
        break;
    }
  }

  void saveItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> itemList = _items.map((item) {
      return '${item.name}:${item.type}:${item.pause}:${item.count}';
    }).toList();
    
    prefs.setStringList('items', itemList);
  }
}