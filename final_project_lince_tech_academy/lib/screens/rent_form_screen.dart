import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/rent_provider.dart';
import '../providers/customer_provider.dart';
import '../models/rent_model.dart';
import '../models/customer_model.dart';

class RentFormScreen extends StatefulWidget {
  final RentModels? rent;

  const RentFormScreen({Key? key, this.rent}) : super(key: key);

  @override
  _RentFormScreenState createState() => _RentFormScreenState();
}

class _RentFormScreenState extends State<RentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClient;
  late String _vehicleModel;
  late DateTime _startDate;
  late DateTime _endDate;
  late int _totalDays;
  late double _totalAmount;
  List<CustomerModels> _customers = [];

  @override
  void initState() {
    super.initState();
    _selectedClient = widget.rent?.clientName;
    _vehicleModel = widget.rent?.vehicleModel ?? '';
    _startDate = widget.rent?.startDate ?? DateTime.now();
    _endDate = widget.rent?.endDate ?? DateTime.now();
    _totalDays = widget.rent?.totalDays ?? 0;
    _totalAmount = widget.rent?.totalAmount ?? 0.0;
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    await customerProvider.fetchCustomers();
    setState(() {
      _customers = customerProvider.customers;
    });
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newRent = RentModels(
        id: widget.rent?.id ?? DateTime.now().millisecondsSinceEpoch,
        clientName: _selectedClient!,
        vehicleModel: _vehicleModel,
        startDate: _startDate,
        endDate: _endDate,
        totalDays: _totalDays,
        totalAmount: _totalAmount,
      );

      if (widget.rent == null) {
        Provider.of<RentProvider>(context, listen: false).addRent(newRent);
      } else {
        Provider.of<RentProvider>(context, listen: false).updateRent(newRent);
      }
      Navigator.pop(context);
      Navigator.pushNamed(context, '/rents');
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }

  void _selectClient(String clientName) {
    setState(() {
      _selectedClient = clientName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rent == null ? 'Novo Aluguel' : 'Editar Aluguel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PopupMenuButton<String>(
                  onSelected: _selectClient,
                  itemBuilder: (BuildContext context) {
                    return _customers.map((customer) {
                      return PopupMenuItem<String>(
                        value: customer.name,
                        child: Text(customer.name),
                      );
                    }).toList();
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Nome do Cliente',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    child: Text(_selectedClient ?? 'Selecione um cliente'),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _vehicleModel,
                  decoration: const InputDecoration(
                    labelText: 'Modelo do Veículo',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o modelo do veículo';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _vehicleModel = value!;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        initialValue: DateFormat('dd/MM/yyyy').format(_startDate),
                        decoration: const InputDecoration(
                          labelText: 'Data de Início',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                        onTap: () => _selectStartDate(context),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, insira a data de início';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        initialValue: DateFormat('dd/MM/yyyy').format(_endDate),
                        decoration: const InputDecoration(
                          labelText: 'Data de Término',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                        onTap: () => _selectEndDate(context),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, insira a data de término';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _totalDays.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Total de Dias',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o total de dias';
                    }
                    final totalDays = int.tryParse(value);
                    if (totalDays == null || totalDays <= 0) {
                      return 'Por favor, insira um valor válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _totalDays = int.parse(value!);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _totalAmount.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Valor Total',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o valor total';
                    }
                    final totalAmount = double.tryParse(value);
                    if (totalAmount == null || totalAmount <= 0) {
                      return 'Por favor, insira um valor válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _totalAmount = double.parse(value!);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: Text(widget.rent == null ? 'Salvar' : 'Atualizar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
