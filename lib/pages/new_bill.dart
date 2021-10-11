import 'package:flutter/material.dart';

class NewBillPage extends StatefulWidget {
  const NewBillPage({Key? key}) : super(key: key);

  @override
  State<NewBillPage> createState() => _NewBillPageState();
}

class _NewBillPageState extends State<NewBillPage> {
  IDType idType = IDType.ration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Bill"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _textField("Name"),
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
            _textField("ID Number"),
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 12),
              child: Text(
                "Products",
                style: Theme.of(context).textTheme.headline5,
              ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Add Product",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    _textField("Product Name"),
                                    _textField("Quantity"),
                                    _textField("Price"),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: ElevatedButton(
                                          onPressed: () {}, child: Text("Add")),
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
  }

  Widget _textField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}

enum IDType { ration, aadhar, driving }

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
