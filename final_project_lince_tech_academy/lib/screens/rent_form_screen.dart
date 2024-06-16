import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rent.dart';
import '../providers/rent_provider.dart';
import 'package:intl/intl.dart';

class RentFormScreen extends StatefulWidget {
  final Rent? rent;

  const RentFormScreen({super.key, this.rent});

  @override
  _RentFormScreenState createState() => _RentFormScreenState();
}

class _RentFormScreenState extends State<RentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _clientName;
  late String _vehicleModel;
  late DateTime _startDate;
  late DateTime _endDate;
  late int _totalDays;
  late double _totalAmount;

  @override
  void initState() {
    super.initState();
    _clientName = widget.rent?.clientName ?? '';
    _vehicleModel = widget.rent?.vehicleModel ?? '';
    _startDate = widget.rent?.startDate ?? DateTime.now();
    _endDate = widget.rent?.endDate ?? DateTime.now();
    _totalDays = widget.rent?.totalDays ?? 0;
    _totalAmount = widget.rent?.totalAmount ?? 0.0;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
        _totalDays = _endDate.difference(_startDate).inDays;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newRent = Rent(
        id: widget.rent?.id ?? DateTime.now().millisecondsSinceEpoch,
        clientName: _clientName,
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
    }
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
                TextFormField(
                  initialValue: _clientName,
                  decoration: const InputDecoration(labelText: 'Nome do Cliente'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o nome do cliente';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _clientName = value!;
                  },
                ),
                TextFormField(
                  initialValue: _vehicleModel,
                  decoration: const InputDecoration(labelText: 'Modelo do Veículo'),
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
                const SizedBox(height: 20),
                Text("Data de Início: ${DateFormat('dd/MM/yyyy').format(_startDate)}"),
                ElevatedButton(
                  onPressed: () => _selectDate(context, true),
                  child: const Text('Selecionar Data de Início'),
                ),
                const SizedBox(height: 20),
                Text("Data de Término: ${DateFormat('dd/MM/yyyy').format(_endDate)}"),
                ElevatedButton(
                  onPressed: () => _selectDate(context, false),
                  child: const Text('Selecionar Data de Término'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _totalAmount.toString(),
                  decoration: const InputDecoration(labelText: 'Valor Total'),
                  keyboardType: TextInputType.number,
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
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
