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
  late String _name;
  late String _cpf;
  late String _state;
  late String _phone;
  late double _commissionPercentage;

  @override
  void initState() {
    super.initState();
    _name = widget.manager?.name ?? '';
    _cpf = widget.manager?.cpf ?? '';
    _state = widget.manager?.state ?? '';
    _phone = widget.manager?.phone ?? '';
    _commissionPercentage = widget.manager?.commissionPercentage ?? 0.0;
  }

  void _saveForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newManager = Manager(
        id: widget.manager?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: _name,
        cpf: _cpf,
        state: _state,
        phone: _phone,
        commissionPercentage: _commissionPercentage,
      );

      if (widget.manager == null) {
        Provider.of<ManagerProvider>(context, listen: false).addManager(newManager);
      } else {
        Provider.of<ManagerProvider>(context, listen: false).updateManager(newManager);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.manager == null ? 'Novo Gerente' : 'Editar Gerente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                  initialValue: _cpf,
                  decoration: InputDecoration(labelText: 'CPF'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o CPF';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _cpf = value!;
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
                  initialValue: _commissionPercentage.toString(),
                  decoration: InputDecoration(labelText: 'Porcentagem de Comissão'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira a porcentagem de comissão';
                    }
                    final commission = double.tryParse(value);
                    if (commission == null || commission < 0 || commission > 100) {
                      return 'Por favor, insira um valor válido entre 0 e 100';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _commissionPercentage = double.parse(value!);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _saveForm(context),
                  child: Text(widget.manager == null ? 'Salvar' : 'Atualizar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
