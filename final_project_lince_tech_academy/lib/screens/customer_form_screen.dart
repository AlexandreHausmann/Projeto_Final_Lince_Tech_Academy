import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import '../providers/customer_provider.dart';
import '../models/customer.dart';

class CustomerFormScreen extends StatefulWidget {
  final Customer? customer;

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
    filter: { "#": RegExp(r'[0-9]') },
  );

  @override
  void initState() {
    super.initState();
    _name = widget.customer?.name ?? '';
    _phone = widget.customer?.phone ?? '';
    _cnpj = widget.customer?.cnpj ?? '';
    _city = widget.customer?.city ?? '';
    _state = widget.customer?.state ?? '';
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (Provider.of<CustomerProvider>(context, listen: false).isCnpjDuplicate(_cnpj) && widget.customer == null) {
        _showErrorDialog('CNPJ já cadastrado.');
        return;
      }

     

      try {
        final fetchedCustomer = await Provider.of<CustomerProvider>(context, listen: false).fetchCustomerData(_cnpj);
        if (fetchedCustomer != null) {
          final newCustomer = Customer(
            id: widget.customer?.id ?? DateTime.now().millisecondsSinceEpoch,
            name: fetchedCustomer.name,
            phone: fetchedCustomer.phone,
            cnpj: fetchedCustomer.cnpj,
            city: fetchedCustomer.city,
            state: fetchedCustomer.state,
          );

          if (widget.customer == null) {
            Provider.of<CustomerProvider>(context, listen: false).addCustomer(newCustomer);
          } else {
            Provider.of<CustomerProvider>(context, listen: false).updateCustomer(newCustomer);
          } 
          Navigator.pop(context);
        } else {
          throw Exception('CNPJ não encontrado.');
        }
      } catch (error) {
        _showErrorDialog(error.toString());
      }
    }
  }

  void _fetchCustomerData() async {
    if (_cnpj.isNotEmpty) {
      try {
        final customer = await Provider.of<CustomerProvider>(context, listen: false).fetchCustomerData(_cnpj);
        if (customer != null) {
          setState(() {
            _name = customer.name;
            _phone = customer.phone;
            _city = customer.city;
            _state = customer.state;
            _cnpj = customer.cnpj;
          });
        }
      } catch (error) {
        _showErrorDialog(error.toString());
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
                  initialValue: _cnpj,
                  decoration: InputDecoration(
                    labelText: 'CNPJ',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _fetchCustomerData,
                    ),
                  ),
                  inputFormatters: [_cnpjFormatter],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o CNPJ';
                    }
                    if (value.length != 18) {
                      return 'CNPJ inválido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _cnpj = value!;
                  },
                  keyboardType: TextInputType.number,
                ),
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
                    _name = value!;
                  },
                ),
                TextFormField(
                  initialValue: _phone,
                  decoration: const InputDecoration(labelText: 'Telefone'),
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
                  initialValue: _city,
                  decoration: const InputDecoration(labelText: 'Cidade'),
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
                  decoration: const InputDecoration(labelText: 'Estado'),
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: Text(widget.customer == null ? 'Salvar' : 'Atualizar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  } 
}