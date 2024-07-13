import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/customer_model.dart';
import '../models/rent_model.dart';
import '../models/vehicle_model.dart';
import '../providers/customer_provider.dart';
import '../providers/rent_provider.dart';
import '../providers/vehicle_provider.dart';

/// Tela de formulário para adicionar ou editar um contrato de aluguel.
class RentFormScreen extends StatefulWidget {
  /// O contrato de aluguel a ser editado, opcional se for para adicionar um novo contrato.
  final RentModels? rent;

  /// Construtor da tela `RentFormScreen`.
  const RentFormScreen({Key? key, this.rent}) : super(key: key);

  @override
  _RentFormScreenState createState() => _RentFormScreenState();
}

class _RentFormScreenState extends State<RentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClient;
  String? _selectedVehicle;
  late DateTime _startDate;
  late DateTime _endDate;
  int? _totalDays;
  double? _totalAmount;
  late double _dailyRate;
  List<CustomerModels> _customers = [];
  List<VehicleModels> _vehicles = [];

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedClient = widget.rent?.clientName;
    _selectedVehicle = widget.rent?.vehicleModel;
    _startDate = widget.rent?.startDate ?? DateTime.now();
    _endDate = widget.rent?.endDate ?? DateTime.now();
    _totalDays = widget.rent?.totalDays ?? 0;
    _totalAmount = widget.rent?.totalAmount ?? 0.0;
    _dailyRate = 0.0;
    _startDateController.text = DateFormat('dd/MM/yyyy').format(_startDate);
    _endDateController.text = DateFormat('dd/MM/yyyy').format(_endDate);
    _loadCustomers();
    _loadVehicles();
  }

  /// Carrega a lista de clientes do provedor de clientes.
  Future<void> _loadCustomers() async {
    final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    await customerProvider.fetchCustomers();
    setState(() {
      _customers = customerProvider.customers;
    });
  }

  /// Carrega a lista de veículos do provedor de veículos.
  Future<void> _loadVehicles() async {
    final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
    await vehicleProvider.fetchVehicles();
    setState(() {
      _vehicles = vehicleProvider.vehicles;
    });
  }

  /// Salva o formulário após validação e executa a adição ou atualização do contrato de aluguel.
  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newRent = RentModels(
        id: widget.rent?.id ?? DateTime.now().millisecondsSinceEpoch,
        clientName: _selectedClient!,
        vehicleModel: _selectedVehicle!,
        startDate: _startDate,
        endDate: _endDate,
        totalDays: _totalDays!,
        totalAmount: _totalAmount!,
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

  /// Atualiza o número total de dias com base nas datas de início e término selecionadas.
  void _updateTotalDays() {
    setState(() {
      _totalDays = _endDate.difference(_startDate).inDays + 1;
    });
  }

  /// Atualiza o valor da diária do veículo selecionado.
  void _updateDailyRate() {
    final selectedVehicle = _vehicles.firstWhere((vehicle) => vehicle.model == _selectedVehicle);
    _dailyRate = selectedVehicle.dailyRate;
  }

  /// Calcula o valor total do contrato de aluguel com base nos dias totais e na taxa diária.
  void _calculateTotalAmount() {
    setState(() {
      _totalAmount = _totalDays! * _dailyRate;
    });
  }

  /// Calcula tanto o número total de dias quanto o valor total do contrato de aluguel.
  void _calculateDaysAndAmount() {
    _updateTotalDays();
    _calculateTotalAmount();
  }

  /// Seleciona um cliente para o contrato de aluguel.
  void _selectClient(String clientName) {
    setState(() {
      _selectedClient = clientName;
    });
  }

  /// Seleciona um veículo para o contrato de aluguel e atualiza a taxa diária e o valor total.
  void _selectVehicle(String vehicleModel) {
    setState(() {
      _selectedVehicle = vehicleModel;
      _updateDailyRate();
      _calculateTotalAmount();
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
                PopupMenuButton<String>(
                  onSelected: _selectVehicle,
                  itemBuilder: (BuildContext context) {
                    return _vehicles.map((vehicle) {
                      return PopupMenuItem<String>(
                        value: vehicle.model,
                        child: Text(vehicle.model),
                      );
                    }).toList();
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Modelo do Veículo',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    child: Text(_selectedVehicle ?? 'Selecione um veículo'),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _startDateController,
                        decoration: const InputDecoration(
                          labelText: 'Data de Início (dd/mm/yyyy)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, insira a data de início';
                          }
                          return null;
                        },
                        onTap: () async {
                          var pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _startDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _startDate = pickedDate;
                              _startDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                              _updateTotalDays();
                              _calculateTotalAmount();
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _endDateController,
                        decoration: const InputDecoration(
                          labelText: 'Data de Término (dd/mm/yyyy)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, insira a data de término';
                          }
                          return null;
                        },
                        onTap: () async {
                          var pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _endDate,
                            firstDate: _startDate,
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _endDate = pickedDate;
                              _endDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                              _updateTotalDays();
                              _calculateTotalAmount();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _calculateDaysAndAmount,
                        child: Text('Calcular Dias e Valor Total'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Total de Dias',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                        controller: TextEditingController(text: _totalDays?.toString()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Valor Total (R\$)',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                        controller: TextEditingController(text: _totalAmount?.toStringAsFixed(2)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveForm,
                        child: Text(widget.rent == null ? 'Salvar' : 'Atualizar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
