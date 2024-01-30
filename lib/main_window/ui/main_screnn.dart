
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:login/add_item/add_item_form.dart';
import 'package:login/main_window/dto/list_item.dart';
import 'package:login/main_window/providers/list_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ListProvider(),
        child: Consumer<ListProvider>(
           builder: (context, listProvider, child) => Scaffold(
          appBar: AppBar(title: const Text('VIBRATORRRRRR'),actions: [IconButton(onPressed: () async{ await FirebaseAuth.instance.signOut();}, icon: const Icon(Icons.login))],),
          body: GridView.builder(
              itemCount: listProvider.items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                ListItem item = listProvider.items[index];
                return GestureDetector(
                  onTap: () async {
                    //отдельная функция
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    int vibrationDuration =
                        prefs.getInt('${item.name}_duration') ?? 1000;
                    int vibrationPause =
                        prefs.getInt('${item.name}_pause') ?? 0;
          
                    if (vibrationPause == 0){
                      Vibrate.vibrate();
                    }

                    final Iterable<Duration> pauses = [
                      Duration(milliseconds: vibrationDuration),
                      Duration(milliseconds: vibrationPause),
                    ];
          
                    Vibrate.vibrateWithPauses(pauses);
                  },
                  child: GridTile(
                    footer: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        listProvider.removeItem(index);
                      },
                    ),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('name: ${item.name}'),
                        Text('Vibration Level: ${item.type}'),
                        Text('Pauses: ${item.pause}'),
                        Text('Pause Duration: ${item.count} ms'),
                      ],
                    ),
                  ),
                );
              },
            ),
             floatingActionButton: FloatingActionButton(
               child: const Icon(Icons.add),
               onPressed: () {
                 showDialog(
                   context: context,
                   builder: (_) => AlertDialog(
                     title: const Text('Add Item'),
                     content: AddItemForm(context: context),
                   ),
                 );
               },
             ),
        )
        )
        
        
         ,
      );
  }
}
