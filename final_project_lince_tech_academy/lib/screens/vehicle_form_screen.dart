import 'dart:io';
import 'package:final_project_lince_tech_academy/models/vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';

class VehicleFormScreen extends StatefulWidget {
  final VehicleModels? vehicle;

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
  late String _imagePath;

  File? _image;
  List<String> _brands = [];

  @override
  void initState() {
    super.initState();
    _brand = widget.vehicle?.brand ?? '';
    _model = widget.vehicle?.model ?? '';
    _plate = widget.vehicle?.plate ?? '';
    _year = widget.vehicle?.year ?? DateTime.now().year;
    _dailyRate = widget.vehicle?.dailyRate ?? 0.0;
    _imagePath = widget.vehicle?.imagePath ?? '';

    _loadBrands();
  }

  Future<void> _loadBrands() async {
    try {
      final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
      await vehicleProvider.fetchVehicleBrands();
      setState(() {
        _brands = vehicleProvider.brands;
        if (_brand.isEmpty && _brands.isNotEmpty) {
          _brand = _brands[0];
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar dados do veículo: $error')),
      );
    }
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
      final newVehicle = VehicleModels(
        id: widget.vehicle?.id,
        brand: _brand,
        model: _model,
        plate: _plate,
        year: _year,
        dailyRate: _dailyRate,
        imagePath: _imagePath,
      );

      final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
      if (widget.vehicle == null) {
        vehicleProvider.addVehicle(newVehicle);
      } else {
        vehicleProvider.updateVehicle(newVehicle);
      }

      Navigator.pop(context);
      Navigator.pushNamed(context, '/vehicles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle == null ? 'Novo Veículo' : 'Editar Veículo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _brands.isNotEmpty
                    ? DropdownButtonFormField<String>(
                        value: _brand.isEmpty ? null : _brand,
                        decoration: const InputDecoration(labelText: 'Marca'),
                        items: _brands.map((brand) {
                          return DropdownMenuItem<String>(
                            value: brand,
                            child: Text(brand),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _brand = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, selecione a marca';
                          }
                          return null;
                        },
                      )
                    : const SizedBox.shrink(),
                TextFormField(
                  initialValue: _model,
                  decoration: const InputDecoration(labelText: 'Modelo'),
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
                  decoration: const InputDecoration(labelText: 'Placa'),
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
                  decoration: const InputDecoration(labelText: 'Ano de Fabricação'),
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
                  decoration: const InputDecoration(labelText: 'Custo da Diária de Aluguel'),
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
                        : const SizedBox.shrink(),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Selecionar Imagem'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: Text(widget.vehicle == null ? 'Salvar' : 'Atualizar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
