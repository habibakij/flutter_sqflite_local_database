
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_db/database/userdatabase.dart';
import 'package:flutter_local_db/model/user.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SqfLiteExample());
}
class SqfLiteExample extends StatefulWidget {
  const SqfLiteExample({Key? key}) : super(key: key);

  @override
  _SqfLiteExampleState createState() => _SqfLiteExampleState();
}

class _SqfLiteExampleState extends State<SqfLiteExample> {
  final idController= TextEditingController();
  final nameController= TextEditingController();
  final deptController= TextEditingController();
  final phoneController= TextEditingController();
  int? selectedID;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "SqfLite Local database",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [

              Container(
                height: 70,
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Type something",
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      fontFamily: "",
                      fontSize: 20,
                    ),
                  ),
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height - 100,
                child: FutureBuilder<List<User>>(
                    future: DatabaseHelper.instance.getUsers(),
                    builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                      if(!snapshot.hasData){
                        return const Center(child: Text("Loading"));
                      }
                      return snapshot.data!.isEmpty ? const Center(child: Text('No Data Found')) :
                      ListView(
                        children: snapshot.data!.map((user){
                          return Center(
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              color: selectedID == user.id! ? Colors.blue[300] : Colors.blue[100],
                              child: ListTile(
                                title: Text(user.name!, style: const TextStyle(fontSize: 20),),
                                onTap: (){
                                  setState(() {
                                    nameController.text= user.name!;
                                    selectedID= user.id!;
                                  });
                                },
                                onLongPress: (){
                                  setState(() {
                                    DatabaseHelper.instance.remove(user.id!);
                                  });
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
              ),
            ]

          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async{
            if(nameController.text.isNotEmpty){
              selectedID != null ? await DatabaseHelper.instance.update(User(id: selectedID, name: nameController.text))
                  : await DatabaseHelper.instance.add(User(name: nameController.text.toString()));
            }
            setState(() {
              nameController.clear();
            });
          },
        ),
      ),
    );
  }
}


