import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class NewBillPage extends StatefulWidget {
  const NewBillPage({Key? key}) : super(key: key);

  @override
  State<NewBillPage> createState() => _NewBillPageState();
}

class _NewBillPageState extends State<NewBillPage> {
  IDType idType = IDType.ration;

  final productNameController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  final doneeNameController = TextEditingController();
  final idNumberController = TextEditingController();

  get totalQuantity => products.fold<int>(
      0, (previousValue, element) => previousValue + element.quantity);
  get totalPrice => products.fold<double>(
      0, (previousValue, element) => previousValue + element.price);

  List<Product> products = [];

  alert(String c) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Text(c),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text("New Bill"),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextButton(
                  onPressed: () async {
                    final name = doneeNameController.text;
                    if (name.isEmpty) {
                      alert('Error: Name cannot be empty');
                    }
                    final idNum = idNumberController.text;
                    if (idNum.isEmpty) {
                      alert('Error: ID Number cannot be empty');
                    }
                    final bill = Bill(
                      name: name,
                      idType: idType,
                      idNumber: idNum,
                      products: products,
                    );
                    alert('Saving...');
                    await state.saveBill(bill);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textField("Name", doneeNameController),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text("Type of ID"),
                    ),
                    Expanded(
                      child: DropdownButton<IDType>(
                        items: IDType.values
                            .map((e) => DropdownMenuItem<IDType>(
                                  child: Text(e.string()),
                                  value: e,
                                ))
                            .toList(),
                        value: idType,
                        onChanged: (type) {
                          setState(() {
                            idType = type ?? IDType.ration;
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
              ),
              _textField("ID Number", idNumberController),
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 12),
                child: Text(
                  "Products",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              ...products
                  .map((p) => ListTile(
                        title: Text(p.name),
                        subtitle: Text('${p.quantity.toString()} Pcs'),
                        trailing: Text('RS ${p.price.toString()}'),
                      ))
                  .toList(),
              Row(
                children: [
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Total Quantity $totalQuantity',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                      Text(
                        'Total $totalPrice',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => BottomSheet(
                            onClosing: () {},
                            elevation: 24,
                            builder: (_) => Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Add Product",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      _textField("Product Name",
                                          productNameController),
                                      _textField(
                                          "Quantity", quantityController),
                                      _textField("Price", priceController),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              final product = Product(
                                                productNameController.text,
                                                int.parse(
                                                    quantityController.text),
                                                double.parse(
                                                    priceController.text),
                                              );
                                              setState(() {
                                                products.add(product);
                                              });
                                              productNameController.clear();
                                              quantityController.clear();
                                              priceController.clear();
                                            },
                                            child: Text("Add")),
                                      )
                                    ],
                                  ),
                                )));
                  },
                  child: Text("Add Product")),
            ],
          ),
        ),
      );
    });
  }

  Widget _textField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}

extension on IDType {
  string() {
    switch (this) {
      case IDType.ration:
        return "Ration Card";
      case IDType.aadhar:
        return "Aadhar Card";
      case IDType.driving:
        return "Driving License";
    }
  }
}
