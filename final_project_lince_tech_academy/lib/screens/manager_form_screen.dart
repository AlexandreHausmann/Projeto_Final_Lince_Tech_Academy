import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/manager_provider.dart';
import '../models/manager.dart';

class ManagerFormScreen extends StatefulWidget {
  final Manager? manager;

  const ManagerFormScreen({Key? key, this.manager}) : super(key: key);

  @override
  _ManagerFormScreenState createState() => _ManagerFormScreenState();
}

class _ManagerFormScreenState extends State<ManagerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _cpfController;
  late TextEditingController _stateController;
  late TextEditingController _phoneController;
  late TextEditingController _commissionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.manager?.name ?? '');
    _cpfController = TextEditingController(text: widget.manager?.cpf ?? '');
    _stateController = TextEditingController(text: widget.manager?.state ?? '');
    _phoneController = TextEditingController(text: widget.manager?.phone ?? '');
    _commissionController = TextEditingController(text: widget.manager?.commissionPercentage?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _stateController.dispose();
    _phoneController.dispose();
    _commissionController.dispose();
    super.dispose();
  }

  void _saveForm(BuildContext context) {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    
    final newManager = Manager(
      id: widget.manager?.id,
      name: _nameController.text.trim(),
      cpf: _cpfController.text.trim(),
      state: _stateController.text.trim(),
      phone: _phoneController.text.trim(),
      commissionPercentage: double.tryParse(_commissionController.text.trim()) ?? 0.0,
    );

    if (widget.manager == null) {
      Provider.of<ManagerProvider>(context, listen: false).addManager(newManager);
    } else {
      Provider.of<ManagerProvider>(context, listen: false).updateManager(newManager);
    }

    Navigator.of(context).pop();
  }

  void _deleteManager(BuildContext context) {
    if (widget.manager != null) {
      Provider.of<ManagerProvider>(context, listen: false).deleteManager(widget.manager!.id!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.manager == null ? 'Adicionar Gerente' : 'Editar Gerente'),
        actions: [
          if (widget.manager != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Confirmar exclusão'),
                    content: Text('Deseja realmente excluir ${widget.manager!.name}?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Excluir'),
                        onPressed: () => _deleteManager(context),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, entre com um nome.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, entre com um CPF.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
              ),
              TextFormField(
                controller: _commissionController,
                decoration: const InputDecoration(labelText: 'Percentual de Comissão'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _saveForm(context),
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}