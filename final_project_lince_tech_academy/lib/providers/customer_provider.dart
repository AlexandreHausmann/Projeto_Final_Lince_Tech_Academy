import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../models/customer_model.dart';
import '../repositories/customer_repository.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerRepository customerRepository;

  CustomerProvider({required this.customerRepository}) {
    fetchCustomers();
  }

  List<CustomerModels> _customers = [];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  var _customerCurrent = CustomerModels(
    name: '',
    phone: '',
    cnpj: '',
    city: '',
    state: '',
  );

  final _cnpjFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  List<CustomerModels> get customers => _customers;

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get nameController => _nameController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get cnpjController => _cnpjController;
  TextEditingController get cityController => _cityController;
  TextEditingController get stateController => _stateController;
  CustomerModels get customerCurrent => _customerCurrent;

  Future<void> fetchCustomers() async {
    _customers = await customerRepository.getAllCustomers();
    notifyListeners();
  }

  Future<void> addCustomer(CustomerModels customer) async {
    await customerRepository.addCustomer(customer);
    resetCustomerForm();
    await fetchCustomers();
  }

  Future<void> updateCustomer(CustomerModels customer) async {
    await customerRepository.updateCustomer(customer);
    resetCustomerForm();
    await fetchCustomers();
  }

  Future<void> deleteCustomer(int id) async {
    await customerRepository.deleteCustomer(id);
    await fetchCustomers();
  }

  Future<CustomerModels?> fetchCustomerData(String cnpj) async {
    return await customerRepository.fetchCustomerData(cnpj);
  }

  bool isCnpjDuplicate(String cnpj) {
    return _customers.any((customer) => customer.cnpj == cnpj);
  }

  Future<void> getCustomerData(String cnpj) async {
    try {
      _cleanWithoutRemovingCNPJ();
      final customer = await customerRepository.fetchCustomerData(cnpj);
      _customerCurrent = customer!;
    } catch (error) {}
  }

  void populateCustomer(CustomerModels customer) {
    _nameController.text = customer.name ?? '';
    _phoneController.text = customer.phone ?? '';
    _cnpjController.text = _cnpjFormatter.maskText(customer.cnpj ?? '');
    _cityController.text = customer.city ?? '';
    _stateController.text = customer.state ?? '';
    notifyListeners();
  }

  void resetCustomerForm() {
    _customerCurrent = CustomerModels(
      name: '',
      phone: '',
      cnpj: '',
      city: '',
      state: '',
    );
    _nameController.clear();
    _phoneController.clear();
    _cnpjController.clear();
    _cityController.clear();
    _stateController.clear();
    notifyListeners();
  }

  void resetCustomerFormExceptCNPJ() {
    _customerCurrent = CustomerModels(
      name: '',
      phone: '',
      cnpj: _customerCurrent.cnpj,
      city: '',
      state: '',
    );
    _nameController.clear();
    _phoneController.clear();
    _cityController.clear();
    _stateController.clear();
    notifyListeners();
  }

  void _cleanWithoutRemovingCNPJ() {
    _customerCurrent = CustomerModels(
      name: '',
      phone: '',
      cnpj: _customerCurrent.cnpj,
      city: '',
      state: '',
    );
    _nameController.clear();
    _phoneController.clear();
    _cityController.clear();
    _stateController.clear();
    notifyListeners();
  }

  void setCustomerForEditing(CustomerModels customer) {
    _customerCurrent = customer;
    populateCustomer(customer);
    notifyListeners();
  }
}
