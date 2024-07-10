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
  final _cnpjFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    if (widget.customer == null) {
      customerProvider.resetCustomerForm();
    } else {
      customerProvider.setCustomerForEditing(widget.customer!);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _saveForm() async {
    final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.customer == null) {
        await customerProvider.addCustomer(customerProvider.customerCurrent);
      } else {
        await customerProvider.updateCustomer(customerProvider.customerCurrent);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CustomerListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (context, customerProvider, _) => Scaffold(
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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: customerProvider.cnpjController,
                          decoration: const InputDecoration(labelText: 'CNPJ'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [_cnpjFormatter],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um CNPJ.';
                            } else if (value.length != 18) {
                              return 'O CNPJ deve ter 14 dígitos.';
                            } else if (widget.customer == null && customerProvider.isCnpjDuplicate(value)) {
                              return 'Este CNPJ já está cadastrado.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            customerProvider.cnpjController.text = value!;
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          String? cnpj = customerProvider
                              .cnpjController.text
                              .replaceAll(RegExp(r'\D'), '');
                          if (cnpj.isNotEmpty) {
                            await customerProvider.getCustomerData(cnpj);
                            customerProvider.populateCustomer(customerProvider.customerCurrent);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: customerProvider.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: customerProvider.phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: customerProvider.cityController,
                    decoration: const InputDecoration(
                      labelText: 'Cidade',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: customerProvider.stateController,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
                    ),
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
      ),
    );
  }
}
