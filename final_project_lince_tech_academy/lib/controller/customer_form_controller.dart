// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/customer_provider.dart';
// import '../models/customer_model.dart';

// class CustomerFormController {
//   final BuildContext context;
//   final GlobalKey<FormState> formKey;
//   String name = '';
//   String phone = '';
//   String cnpj = '';
//   String city = '';
//   String state = '';

//   CustomerFormController(this.context, this.formKey, CustomerModels? customer)
//       : cnpj = customer?.cnpj ?? '',
//         name = customer?.name ?? '',
//         phone = customer?.phone ?? '',
//         city = customer?.city ?? '',
//         state = customer?.state ?? '';

//   Future<void> saveForm() async {
//     if (formKey.currentState!.validate()) {
//       formKey.currentState!.save();
//       final cleanedCnpj = cnpj.replaceAll(RegExp(r'[^\d]'), '');

//       if (Provider.of<CustomerProvider>(context, listen: false).isCnpjDuplicate(cleanedCnpj)) {
//         _showErrorDialog('CNPJ já cadastrado.');
//         return;
//       }

//       try {
//         final fetchedCustomer =
//             await Provider.of<CustomerProvider>(context, listen: false).fetchCustomerData(cleanedCnpj);
//         final newCustomer = CustomerModels(
//           id: fetchedCustomer?.id ?? null,
//           name: fetchedCustomer?.name ?? name,
//           phone: fetchedCustomer?.phone ?? phone,
//           cnpj: fetchedCustomer?.cnpj ?? cleanedCnpj,
//           city: fetchedCustomer?.city ?? city,
//           state: fetchedCustomer?.state ?? state,
//         );

//         if (newCustomer.id == null) {
//           await Provider.of<CustomerProvider>(context, listen: false).addCustomer(newCustomer);
//         } else {
//           await Provider.of<CustomerProvider>(context, listen: false).updateCustomer(newCustomer);
//         }

//         Navigator.pop(context);
//       } catch (error) {
//         _showErrorDialog(error.toString());
//       }
//     }
//   }

//   Future<void> searchAndPopulateFields(String cnpj) async {
//     if (cnpj.isNotEmpty) {
//       try {
//         final cleanedCnpj = cnpj.replaceAll(RegExp(r'[^\d]'), '');
//         final customer = await Provider.of<CustomerProvider>(context, listen: false).fetchCustomerData(cleanedCnpj);

//         if (customer != null) {
//           // Atualiza os campos do formulário com os dados buscados
//           name = customer.name;
//           phone = customer.phone;
//           city = customer.city;
//           state = customer.state;

          
//         } else {
//           _showErrorDialog('CNPJ não encontrado na API BRASIL.');
//         }
//       } catch (error) {
//         _showErrorDialog('Erro ao buscar CNPJ: $error');
//       }
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Erro'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             child: const Text('OK'),
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
