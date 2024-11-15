import 'package:flutter/material.dart';
import 'screens/add_data_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle Geral de Cargas',
      theme: ThemeData(
        primaryColor: Color(0xFF00796B), // Cor primária do app (verde escuro)
        scaffoldBackgroundColor: Colors.white, // Cor de fundo do Scaffold

        // Configuração do tema de texto
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black),
          bodySmall: TextStyle(fontSize: 12, color: Colors.black),
          labelSmall: TextStyle(fontSize: 12, color: Colors.grey),
        ),

        // Estilo do ElevatedButton
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF00796B), // Cor do fundo dos botões (verde escuro)
            foregroundColor: Colors.white, // Cor do texto dos botões
          ),
        ),

        // Estilo da AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF00796B), // Cor de fundo da AppBar (verde escuro)
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Configuração de DataTable
        dataTableTheme: DataTableThemeData(
          headingTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          dataTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ),
      home: const MainPage(title: 'Controle Geral de Cargas'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Map<String, String>> _data = [];
  int? _selectedIndex;

  void _addNewData(Map<String, String> newData) {
    setState(() {
      _data.add({
        'data': newData['data']!,
        'hora': newData['hora']!,
        'peso': newData['peso']!,
        'valor': newData['valor']!,
        'nota': newData['nota']!,
        'ctr': newData['ctr']!,
        'status': 'Aguardando Pagamento',
      });
    });
  }

  void _editData(Map<String, String> updatedData) {
    if (_selectedIndex != null) {
      setState(() {
        _data[_selectedIndex!] = {
          'data': updatedData['data']!,
          'hora': updatedData['hora']!,
          'peso': updatedData['peso']!,
          'valor': updatedData['valor']!,
          'nota': updatedData['nota']!,
          'ctr': updatedData['ctr']!,
          'status': _data[_selectedIndex!]['status']!,
        };
      });
    }
  }

  void _markAsPaid() {
    if (_selectedIndex != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar Pagamento'),
            content: const Text('Tem certeza de que deseja marcar esta carga como "Paga"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _data[_selectedIndex!]['status'] = 'Paga';
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Confirmar'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showDetails() {
    if (_selectedIndex != null) {
      final selectedItem = _data[_selectedIndex!];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Detalhes da Carga'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data: ${selectedItem['data']}'),
                Text('Hora: ${selectedItem['hora']}'),
                Text('Peso: ${selectedItem['peso']} kg'),
                Text('Valor: ${selectedItem['valor']}'),
                Text('Status: ${selectedItem['status']}'),
                Text('Número da Nota: ${selectedItem['nota']}'),
                Text('Número da CTR: ${selectedItem['ctr']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'),
              ),
            ],
          );
        },
      );
    }
  }

  void _deleteData() {
    if (_selectedIndex != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar Exclusão'),
            content: const Text('Tem certeza de que deseja excluir esta carga?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _data.removeAt(_selectedIndex!);
                    _selectedIndex = null;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Excluir'),
              ),
            ],
          );
        },
      );
    }
  }

  double _calculateTotal() {
    return _data.fold(0.0, (sum, item) {
      final valor = double.tryParse(item['valor']!.replaceAll('R\$', '').replaceAll(',', '.')) ?? 0.0;
      return item['status'] == 'Aguardando Pagamento' ? sum + valor : sum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: ListView(
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Data')),
                      DataColumn(label: Text('Hora')),
                      DataColumn(label: Text('Peso (KG)')),
                      DataColumn(label: Text('Valor (R\$)')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Total (R\$)')),
                    ],
                    rows: [
                      ..._data.asMap().map(
                            (index, item) => MapEntry(
                          index,
                          DataRow(
                            selected: _selectedIndex == index,
                            onSelectChanged: (selected) {
                              setState(() {
                                _selectedIndex = selected == true ? index : null;
                              });
                            },
                            cells: [
                              DataCell(Text(item['data']!)),
                              DataCell(Text(item['hora']!)),
                              DataCell(Text(item['peso']!)),
                              DataCell(Text(item['valor']!)),
                              DataCell(Text(item['status']!)),
                              DataCell(
                                Text(item['status'] == 'Aguardando Pagamento' ? item['valor']! : ''),
                              ),
                            ],
                          ),
                        ),
                      ).values.toList(),
                      DataRow(
                        cells: [
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('Total:')),
                          DataCell(Text('R\$ ${_calculateTotal().toStringAsFixed(2)}')),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddDataPage(
                          addDataCallback: _addNewData,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Cor personalizada para 'Adicionar'
                  ),
                  child: const Text('Adicionar'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _selectedIndex == null ? null : () {
                    final selectedItem = _data[_selectedIndex!];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddDataPage(
                          addDataCallback: _editData,
                          isEdit: true,
                          existingData: selectedItem,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Cor personalizada para 'Editar'
                  ),
                  child: const Text('Editar'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _selectedIndex == null ? null : _deleteData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Cor personalizada para 'Excluir'
                  ),
                  child: const Text('Excluir'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _selectedIndex == null ? null : _showDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Cor personalizada para 'Ver Detalhes'
                  ),
                  child: const Text('Ver Detalhes'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _selectedIndex == null ? null : _markAsPaid,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Cor personalizada para 'Pagar'
                  ),
                  child: const Text('Pagar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
