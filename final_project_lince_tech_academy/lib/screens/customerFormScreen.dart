import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/customer.dart';
import '../providers/customerProvider.dart';

class CustomerFormScreen extends StatefulWidget {
  @override
  _CustomerFormScreenState createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newCustomer = Customer(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        phone: _phoneController.text,
        cnpj: _cnpjController.text,
        city: _cityController.text,
        state: _stateController.text,
      );
      Provider.of<CustomerProvider>(context, listen: false).addCustomer(newCustomer);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Cliente'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cnpjController,
                decoration: InputDecoration(labelText: 'CNPJ'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o CNPJ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'Cidade'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a cidade';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stateController,
                decoration: InputDecoration(labelText: 'Estado'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o estado';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
