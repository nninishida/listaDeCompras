import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras 🐱‍🏍',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras 📃'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/image/img-shopping-list.png', height: 100),
            SizedBox(height: 20),
            Text('Nicole Nishida Rodrigues 🐱‍🏍'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShoppingListScreen()),
                );
              },
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final List<Map<String, dynamic>> _items = [];

  void _addItem(String name, String category, double maxPrice) {
    setState(() {
      _items.add({'name': name, 'category': category, 'maxPrice': maxPrice});
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Item Adicionado')));
  }

  void _updateItem(int index, String name, String category, double maxPrice) {
    setState(() {
      _items[index] = {
        'name': name,
        'category': category,
        'maxPrice': maxPrice
      };
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Item Atualizado')));
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Item Excluído')));
  }

  Future<void> _showAddItemDialog() async {
    String itemName = '';
    String itemCategory = '';
    double itemPrice = 0.0;

    TextEditingController nameController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: 'Nome do Item'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(hintText: 'Categoria'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(hintText: 'Preço Máximo'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Adicionar'),
              onPressed: () {
                itemName = nameController.text;
                itemCategory = categoryController.text;
                itemPrice = double.tryParse(priceController.text) ?? 0.0;

                if (itemName.isNotEmpty &&
                    itemCategory.isNotEmpty &&
                    itemPrice > 0) {
                  _addItem(itemName, itemCategory, itemPrice);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Preencha todos os campos')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditItemDialog(int index) async {
    String itemName = _items[index]['name'];
    String itemCategory = _items[index]['category'];
    double itemPrice = _items[index]['maxPrice'];

    TextEditingController nameController =
        TextEditingController(text: itemName);
    TextEditingController categoryController =
        TextEditingController(text: itemCategory);
    TextEditingController priceController =
        TextEditingController(text: itemPrice.toString());

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: 'Nome do Item'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(hintText: 'Categoria'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(hintText: 'Preço Máximo'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                itemName = nameController.text;
                itemCategory = categoryController.text;
                itemPrice = double.tryParse(priceController.text) ?? itemPrice;

                if (itemName.isNotEmpty &&
                    itemCategory.isNotEmpty &&
                    itemPrice > 0) {
                  _updateItem(index, itemName, itemCategory, itemPrice);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Preencha todos os campos')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text(
                '${item['category']} - R\$ ${item['maxPrice'].toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditItemDialog(index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteItem(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
