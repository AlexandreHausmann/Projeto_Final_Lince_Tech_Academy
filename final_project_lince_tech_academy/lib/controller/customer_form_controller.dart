// customer_form_controller.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/customer_provider.dart';
import '../models/customer_model.dart';

class CustomerFormController {
  final BuildContext context;
  final GlobalKey<FormState> formKey;
  String name;
  String phone;
  String cnpj;
  String city;
  String state;

  CustomerFormController(this.context, this.formKey, CustomerModels? customer)
      : cnpj = customer?.cnpj ?? '',
        name = customer?.name ?? '',
        phone = customer?.phone ?? '',
        city = customer?.city ?? '',
        state = customer?.state ?? '';

  Future<void> saveForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final cleanedCnpj = cnpj.replaceAll(RegExp(r'[^\d]'), '');

      if (Provider.of<CustomerProvider>(context, listen: false)
              .isCnpjDuplicate(cleanedCnpj)) {
        _showErrorDialog('CNPJ já cadastrado.');
        return;
      }

      try {
        final fetchedCustomer =
            await Provider.of<CustomerProvider>(context, listen: false)
                .fetchCustomerData(cleanedCnpj);
        final newCustomer = CustomerModels(
          id: null, // assuming id will be generated on insertion
          name: fetchedCustomer?.name ?? name,
          phone: fetchedCustomer?.phone ?? phone,
          cnpj: fetchedCustomer?.cnpj ?? cleanedCnpj,
          city: fetchedCustomer?.city ?? city,
          state: fetchedCustomer?.state ?? state,
        );

        Provider.of<CustomerProvider>(context, listen: false)
            .addCustomer(newCustomer);

        Navigator.pop(context); // Assuming going back after saving

      } catch (error) {
        _showErrorDialog(error.toString());
      }
    }
  }

  Future<CustomerModels?> fetchCustomerData() async {
    if (cnpj.isNotEmpty) {
      try {
        final cleanedCnpj = cnpj.replaceAll(RegExp(r'[^\d]'), '');

        final customer =
            await Provider.of<CustomerProvider>(context, listen: false)
                .fetchCustomerData(cleanedCnpj);

        return customer;
      } catch (error) {
        _showErrorDialog(error.toString());
      }
    }
    return null;
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
}
