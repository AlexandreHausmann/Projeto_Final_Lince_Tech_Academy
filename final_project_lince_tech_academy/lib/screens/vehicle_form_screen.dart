import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/vehicle.dart';
import '../providers/vehicle_provider.dart';

class VehicleFormScreen extends StatefulWidget {
  final Vehicle? vehicle;

  const VehicleFormScreen({Key? key, this.vehicle}) : super(key: key);

  @override
  _VehicleFormScreenState createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends State<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _brand;
  late String _model;
  late String _plate;
  late int _year;
  late double _dailyRate;
  late String _imagePath = '';

  File? _image;

  @override
  void initState() {
    super.initState();
    _brand = widget.vehicle?.brand ?? '';
    _model = widget.vehicle?.model ?? '';
    _plate = widget.vehicle?.plate ?? '';
    _year = widget.vehicle?.year ?? DateTime.now().year;
    _dailyRate = widget.vehicle?.dailyRate ?? 0.0;
    _imagePath = widget.vehicle?.imagePath ?? '';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imagePath = pickedFile.path;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newVehicle = Vehicle(
        id: widget.vehicle?.id ?? DateTime.now().millisecondsSinceEpoch,
        brand: _brand,
        model: _model,
        plate: _plate,
        year: _year,
        dailyRate: _dailyRate,
        imagePath: _imagePath,
      );

      if (widget.vehicle == null) {
        Provider.of<VehicleProvider>(context, listen: false).addVehicle(newVehicle);
      } else {
        Provider.of<VehicleProvider>(context, listen: false).updateVehicle(newVehicle);
      }
      Navigator.pop(context);
    }
  }

  void _deleteVehicle(BuildContext context) {
    if (widget.vehicle != null) {
      Provider.of<VehicleProvider>(context, listen: false).deleteVehicle(widget.vehicle!.id!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle == null ? 'Novo Veículo' : 'Editar Veículo'),
        actions: [
          if (widget.vehicle != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title:const Text('Confirmar exclusão'),
                    content:const Text('Deseja realmente excluir este veículo?'),
                    actions: [
                      TextButton(
                        child:const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      ),
                      TextButton(
                        child:const Text('Excluir'),
                        onPressed: () => _deleteVehicle(context),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
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
                  initialValue: _brand,
                  decoration:const InputDecoration(labelText: 'Marca'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira a marca';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _brand = value!;
                  },
                ),
                TextFormField(
                  initialValue: _model,
                  decoration:const InputDecoration(labelText: 'Modelo'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o modelo';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _model = value!;
                  },
                ),
                TextFormField(
                  initialValue: _plate,
                  decoration:const InputDecoration(labelText: 'Placa'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira a placa';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _plate = value!;
                  },
                ),
                TextFormField(
                  initialValue: _year.toString(),
                  decoration:const InputDecoration(labelText: 'Ano de Fabricação'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o ano de fabricação';
                    }
                    final year = int.tryParse(value);
                    if (year == null || year < 1900 || year > DateTime.now().year) {
                      return 'Por favor, insira um ano válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _year = int.parse(value!);
                  },
                ),
                TextFormField(
                  initialValue: _dailyRate.toString(),
                  decoration:const InputDecoration(labelText: 'Custo da Diária de Aluguel'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o custo da diária';
                    }
                    final dailyRate = double.tryParse(value);
                    if (dailyRate == null || dailyRate <= 0) {
                      return 'Por favor, insira um valor válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _dailyRate = double.parse(value!);
                  },
                ),
                const SizedBox(height: 20),
                _image != null
                    ? Image.file(
                        _image!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : _imagePath.isNotEmpty
                        ? Image.file(
                            File(_imagePath),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        :const SizedBox.shrink(),
                ElevatedButton(
                  onPressed: _pickImage,
                  child:const Text('Selecionar Imagem'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveForm,
                  child:const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}