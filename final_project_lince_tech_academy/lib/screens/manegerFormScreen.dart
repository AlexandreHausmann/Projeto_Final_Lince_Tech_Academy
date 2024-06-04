import 'package:flutter/material.dart';

class ManagerFormScreen extends StatefulWidget {
  @override
  _ManagerFormScreenState createState() => _ManagerFormScreenState();
}

class _ManagerFormScreenState extends State<ManagerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _stateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _commissionPercentageController = TextEditingController();

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Criar novo gerente e salvar no banco de dados
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Gerente'),
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
                controller: _cpfController,
                decoration: InputDecoration(labelText: 'CPF'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o CPF';
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
                controller: _commissionPercentageController,
                decoration: InputDecoration(labelText: 'Porcentagem de Comissão'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a porcentagem de comissão';
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
