// manager_form_screen.dart

import 'package:final_project_lince_tech_academy/controller/manager_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/manager_model.dart';
import '../providers/manager_provider.dart';

const List<Map<String, String>> estadosBrasileiros = [
  {'name': 'Acre', 'uf': 'AC'},
  {'name': 'Alagoas', 'uf': 'AL'},
  {'name': 'Amapá', 'uf': 'AP'},
  {'name': 'Amazonas', 'uf': 'AM'},
  {'name': 'Bahia', 'uf': 'BA'},
  {'name': 'Ceará', 'uf': 'CE'},
  {'name': 'Distrito Federal', 'uf': 'DF'},
  {'name': 'Espírito Santo', 'uf': 'ES'},
  {'name': 'Goiás', 'uf': 'GO'},
  {'name': 'Maranhão', 'uf': 'MA'},
  {'name': 'Mato Grosso', 'uf': 'MT'},
  {'name': 'Mato Grosso do Sul', 'uf': 'MS'},
  {'name': 'Minas Gerais', 'uf': 'MG'},
  {'name': 'Pará', 'uf': 'PA'},
  {'name': 'Paraíba', 'uf': 'PB'},
  {'name': 'Paraná', 'uf': 'PR'},
  {'name': 'Pernambuco', 'uf': 'PE'},
  {'name': 'Piauí', 'uf': 'PI'},
  {'name': 'Rio de Janeiro', 'uf': 'RJ'},
  {'name': 'Rio Grande do Norte', 'uf': 'RN'},
  {'name': 'Rio Grande do Sul', 'uf': 'RS'},
  {'name': 'Rondônia', 'uf': 'RO'},
  {'name': 'Roraima', 'uf': 'RR'},
  {'name': 'Santa Catarina', 'uf': 'SC'},
  {'name': 'São Paulo', 'uf': 'SP'},
  {'name': 'Sergipe', 'uf': 'SE'},
  {'name': 'Tocantins', 'uf': 'TO'},
];

class ManagerFormScreen extends StatefulWidget {
  final ManagerModels? manager;

  const ManagerFormScreen({Key? key, this.manager}) : super(key: key);

  @override
  _ManagerFormScreenState createState() => _ManagerFormScreenState();
}

class _ManagerFormScreenState extends State<ManagerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  String? _cpf;
  late String _state;
  String? _phone;
  late double _commissionPercentage;
  late ManagerController _controller;

  @override
  void initState() {
    super.initState();
    _name = widget.manager?.name ?? '';
    _cpf = widget.manager?.cpf;
    _state = widget.manager?.state ?? '';
    _phone = widget.manager?.phone;
    _commissionPercentage = widget.manager?.commissionPercentage ?? 0.0;
    _controller = ManagerController(Provider.of<ManagerProvider>(context, listen: false));
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newManager = ManagerModels(
        id: widget.manager?.id,
        name: capitalize(_name),
        cpf: _cpf ?? '',
        state: _state,
        phone: _phone ?? '',
        commissionPercentage: _commissionPercentage,
      );

      try {
        if (widget.manager == null) {
          await _controller.addManager(newManager);
        } else {
          await _controller.updateManager(newManager);
        }

        await _controller.fetchManagers();

        Navigator.pushReplacementNamed(context, '/managers');
      } catch (e) {
        print('Error saving manager: $e');
      }
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
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o nome';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = capitalize(value!);
                  },
                ),
                TextFormField(
                  initialValue: _cpf,
                  decoration: const InputDecoration(labelText: 'CPF'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                    _CpfInputFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o CPF';
                    }
                    if (value.length != 14) {
                      return 'Verifique o CPF, ele deve conter 11 numeros';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _cpf = value;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _state.isNotEmpty ? _state : null,
                  decoration: const InputDecoration(labelText: 'Estado'),
                  items: estadosBrasileiros.map((estado) {
                    return DropdownMenuItem<String>(
                      value: estado['uf'],
                      child: Text('${estado['name']} (${estado['uf']})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _state = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione um estado';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _state = value!;
                  },
                ),
                TextFormField(
                  initialValue: _phone,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(14),
                    _PhoneInputFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o telefone';
                    }
                    if (value.length != 14) {
                      return 'Telefone deve conter 14 caracteres';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _phone = value;
                  },
                ),
                TextFormField(
                  initialValue: _commissionPercentage > 0 ? '$_commissionPercentage%' : '',
                  decoration: const InputDecoration(labelText: 'Porcentagem de Comissão'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
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
                    _commissionPercentage = double.parse(value ?? '0.0');
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveForm,
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

class _CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.length <= 3) {
      return newValue;
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 3 || i == 6) {
        buffer.write('.');
      }
      if (i == 9) {
        buffer.write('-');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.length <= 2) {
      return newValue;
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) {
        buffer.write(') ');
      } else if (i == 7) {
        buffer.write('-');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
