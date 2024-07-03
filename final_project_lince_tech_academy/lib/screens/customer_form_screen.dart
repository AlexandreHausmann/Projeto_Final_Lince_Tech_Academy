import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import '../providers/customer_provider.dart';
import '../models/customer_model.dart';
import 'customer_list_screen.dart';

class CustomerFormScreen extends StatefulWidget {
  final CustomerModels? customer;

  const CustomerFormScreen({Key? key, this.customer}) : super(key: key);

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

  final _cnpjFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _cnpj = widget.customer?.cnpj ?? '';
    _name = widget.customer?.name ?? '';
    _phone = widget.customer?.phone ?? '';
    _city = widget.customer?.city ?? '';
    _state = widget.customer?.state ?? '';
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final cleanedCnpj = _cnpj.replaceAll(RegExp(r'[^\d]'), '');

      if (Provider.of<CustomerProvider>(context, listen: false)
              .isCnpjDuplicate(cleanedCnpj) &&
          widget.customer == null) {
        _showErrorDialog('CNPJ já cadastrado.');
        return;
      }

      try {
        final fetchedCustomer =
            await Provider.of<CustomerProvider>(context, listen: false)
                .fetchCustomerData(cleanedCnpj);
        final newCustomer = CustomerModels(
          id: widget.customer?.id ?? DateTime.now().millisecondsSinceEpoch,
          name: fetchedCustomer?.name ?? _name,
          phone: fetchedCustomer?.phone ?? _phone,
          cnpj: fetchedCustomer?.cnpj ?? cleanedCnpj,
          city: fetchedCustomer?.city ?? _city,
          state: fetchedCustomer?.state ?? _state,
        );

        if (widget.customer == null) {
          await Provider.of<CustomerProvider>(context, listen: false)
              .addCustomer(newCustomer);
        } else {
          await Provider.of<CustomerProvider>(context, listen: false)
              .updateCustomer(newCustomer);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CustomerListScreen()),
        );
      } catch (error) {
        _showErrorDialog(error.toString());
      }
    }
  }

  void _fetchCustomerData() async {
    if (_cnpj.isNotEmpty) {
      try {
        final cleanedCnpj = _cnpj.replaceAll(RegExp(r'[^\d]'), '');

        final customer =
            await Provider.of<CustomerProvider>(context, listen: false)
                .fetchCustomerData(cleanedCnpj);

        if (customer != null) {
          setState(() {
            _name = customer.name;
            _phone = customer.phone;
            _city = customer.city;
            _state = customer.state;
          });
        } else {
          _showErrorDialog('CNPJ não encontrado na API BRASIL.');
        }
      } catch (error) {
        _showErrorDialog('Erro ao buscar CNPJ: $error');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer == null ? 'Novo Cliente' : 'Editar Cliente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _fetchCustomerData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _cnpj,
                decoration: const InputDecoration(labelText: 'CNPJ'),
                keyboardType: TextInputType.number,
                inputFormatters: [_cnpjFormatter],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um CNPJ.';
                  } else if (value.length != 18) {
                    return 'O CNPJ deve ter 14 dígitos.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cnpj = value!;
                },
              ),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _phone,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um telefone.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phone = value!;
                },
              ),
              TextFormField(
                initialValue: _city,
                decoration: const InputDecoration(labelText: 'Cidade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma cidade.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _city = value!;
                },
              ),
              TextFormField(
                initialValue: _state,
                decoration: const InputDecoration(labelText: 'Estado'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um estado.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _state = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(widget.customer == null ? 'Salvar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
