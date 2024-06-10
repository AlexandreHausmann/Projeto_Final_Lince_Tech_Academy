import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rent.dart';
import '../providers/rentProvider.dart';

class RentFormScreen extends StatefulWidget {
  @override
  _RentFormScreenState createState() => _RentFormScreenState();
}

class _RentFormScreenState extends State<RentFormScreen> {
  // Variáveis ​​para armazenar os dados do aluguel
  int _clientId = 0;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  int _numberOfDays = 0;
  double _totalAmount = 0.0;

  // Chave global para validar o formulário
  final _formKey = GlobalKey<FormState>();

  // Método para salvar o formulário
  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newRent = Rent(
        id: 0, // Você pode definir isso para um valor adequado ou gerar um ID
        clientId: _clientId,
        startDate: _startDate,
        endDate: _endDate,
        numberOfDays: _numberOfDays,
        totalAmount: _totalAmount,
      );
      Provider.of<RentProvider>(context, listen: false).addRent(newRent);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Aluguel'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
               
                        ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveForm,
        child: Icon(Icons.save),
      ),
    );
  }
}