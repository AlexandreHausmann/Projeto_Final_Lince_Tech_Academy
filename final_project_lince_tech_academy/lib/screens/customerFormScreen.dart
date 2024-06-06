import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/customer.dart';
import '../providers/customerProvider.dart';

class CustomerFormScreen extends StatefulWidget {
  final Customer? customer;

  CustomerFormScreen({this.customer});

  @override
  _CustomerFormScreenState createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _phone;
  late String _cnpj;
  late String _city;
  late String _state;

  @override
  void initState() {
    super.initState();
    _name = widget.customer?.name ?? '';
    _phone = widget.customer?.phone ?? '';
    _cnpj = widget.customer?.cnpj ?? '';
    _city = widget.customer?.city ?? '';
    _state = widget.customer?.state ?? '';
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newCustomer = Customer(
        id: widget.customer?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: _name,
        phone: _phone,
        cnpj: _cnpj,
        city: _city,
        state: _state,
      );
      if (widget.customer == null) {
        Provider.of<CustomerProvider>(context, listen: false).addCustomer(newCustomer);
      } else {
        Provider.of<CustomerProvider>(context, listen: false).updateCustomer(newCustomer);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer == null ? 'Novo Cliente' : 'Editar Cliente'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _phone,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phone = value!;
                },
              ),
              TextFormField(
                initialValue: _cnpj,
                decoration: InputDecoration(labelText: 'CNPJ'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o CNPJ';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cnpj = value!;
                },
              ),
              TextFormField(
                initialValue: _city,
                decoration: InputDecoration(labelText: 'Cidade'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a cidade';
                  }
                  return null;
                },
                onSaved: (value) {
                  _city = value!;
                },
              ),
              TextFormField(
                initialValue: _state,
                decoration: InputDecoration(labelText: 'Estado'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o estado';
                  }
                  return null;
                },
                onSaved: (value) {
                  _state = value!;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveForm,
                  child: Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}