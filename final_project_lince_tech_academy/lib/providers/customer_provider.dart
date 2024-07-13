import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../models/customer_model.dart';
import '../repositories/customer_repository.dart';

/// Provider responsável por gerenciar o estado e lógica de negócios relacionados aos clientes.
class CustomerProvider extends ChangeNotifier {
  /// Repositório para operações relacionadas aos clientes.
  final CustomerRepository customerRepository;

  /// Construtor para inicializar o `CustomerProvider` com uma instância de `CustomerRepository`.
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
    filter: {'#': RegExp(r'[0-9]')},
  );

  /// Lista de clientes armazenados no controlador.
  List<CustomerModels> get customers => _customers;
  /// Chave global do formulário utilizado para validação.
  GlobalKey<FormState> get formKey => _formKey;
  /// Controlador de texto para o campo de nome do cliente.
  TextEditingController get nameController => _nameController;
  /// Controlador de texto para o campo de telefone do cliente.
  TextEditingController get phoneController => _phoneController;
  /// Controlador de texto para o campo de CNPJ do cliente.
  TextEditingController get cnpjController => _cnpjController;
  /// Controlador de texto para o campo de cidade do cliente.
  TextEditingController get cityController => _cityController;
  /// Controlador de texto para o campo de estado do cliente.
  TextEditingController get stateController => _stateController;
  /// Retorna o cliente atualmente selecionado.
  CustomerModels get customerCurrent => _customerCurrent;
  /// Define o cliente atualmente selecionado e notifica os ouvintes.
  /// 
  set customerCurrent(CustomerModels customer) {
    _customerCurrent = customer;
    notifyListeners();
  }

  /// Busca a lista de clientes do repositório e notifica os ouvintes sobre as alterações.
  Future<void> fetchCustomers() async {
    _customers = await customerRepository.getAllCustomers();
    notifyListeners();
  }

  /// Adiciona um novo cliente utilizando o repositório e atualiza a lista de clientes.
  Future<void> addCustomer(CustomerModels customer) async {
    await customerRepository.addCustomer(customer);
    resetCustomerForm();
    await fetchCustomers();
  }

  /// Atualiza um cliente existente utilizando o repositório e atualiza a lista de clientes.
  Future<void> updateCustomer(CustomerModels customer) async {
    await customerRepository.updateCustomer(customer);
    resetCustomerForm();
    await fetchCustomers();
  }

  /// Deleta um cliente pelo seu ID utilizando o repositório e atualiza a lista de clientes.
  Future<void> deleteCustomer(int id) async {
    await customerRepository.deleteCustomer(id);
    await fetchCustomers();
  }

  /// Busca dados de um cliente pelo CNPJ utilizando o repositório.
  Future<CustomerModels?> fetchCustomerData(String cnpj) async {
    return await customerRepository.fetchCustomerData(cnpj);
  }

  /// Verifica se um CNPJ já existe na lista de clientes.
  bool isCnpjDuplicate(String cnpj) {
    return _customers.any((customer) => customer.cnpj == cnpj);
  }

  /// Obtém dados de um cliente pelo CNPJ e popula os controladores de texto do formulário.
  Future<void> getCustomerData(String cnpj) async {
    try {
      _cleanWithoutRemovingCNPJ();
      final customer = await customerRepository.fetchCustomerData(cnpj);
      _customerCurrent = customer!;
    } catch (error) {
      ///tratar erro
    }
  }

  /// Preenche os controladores de texto com os dados de um cliente existente.
  void populateCustomer(CustomerModels customer) {
    _nameController.text = customer.name;
    _phoneController.text = customer.phone;
    _cnpjController.text = _cnpjFormatter.maskText(customer.cnpj);
    _cityController.text = customer.city;
    _stateController.text = customer.state;
    notifyListeners();
  }

  /// Reseta o formulário do cliente, limpando todos os controladores de texto.
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

  /// Reseta o formulário do cliente, exceto o campo CNPJ, mantendo seus dados.
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

  /// Limpa o formulário do cliente sem remover o CNPJ, mantendo seus dados.
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

  /// Define um cliente específico para edição, atualizando o estado atual e preenchendo o formulário.
  void setCustomerForEditing(CustomerModels customer) {
    _customerCurrent = customer;
    populateCustomer(customer);
    notifyListeners();
  }
}
