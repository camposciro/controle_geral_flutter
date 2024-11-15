import 'package:flutter/material.dart';

// Função para calcular o valor
String _calculateValue(String peso) {
  final pesoValue = double.tryParse(peso.replaceAll(RegExp('[^0-9.]'), '')) ?? 0.0;
  final valor = (pesoValue * 100 * 0.00011) - 80;
  return valor.toStringAsFixed(2);
}

class EditDataPage extends StatefulWidget {
  final Map<String, String> carga; // Dados da carga selecionada
  final Function(Map<String, String>) editDataCallback; // Função para salvar a edição

  const EditDataPage({super.key, required this.carga, required this.editDataCallback});

  @override
  _EditDataPageState createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  late TextEditingController _pesoController;
  late TextEditingController _notaController;
  late TextEditingController _ctrController;

  @override
  void initState() {
    super.initState();
    // Inicializa os controladores com os dados da carga
    _pesoController = TextEditingController(text: widget.carga['peso']);
    _notaController = TextEditingController(text: widget.carga['nota']);
    _ctrController = TextEditingController(text: widget.carga['ctr']);
  }

  void _submitEditedData() {
    final peso = _pesoController.text;
    final nota = _notaController.text;
    final ctr = _ctrController.text;

    if (peso.isEmpty || nota.isEmpty || ctr.isEmpty) {
      return;
    }

    final updatedData = {
      ...widget.carga, // Mantenha os outros dados inalterados
      'peso': peso,
      'valor': _calculateValue(peso),
      'nota': nota,
      'ctr': ctr,
    };

    // Chama o callback para salvar as mudanças
    widget.editDataCallback(updatedData);

    // Fecha a página de edição
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Dados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _pesoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Peso (KG)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _notaController,
              decoration: const InputDecoration(labelText: 'Número da Nota'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ctrController,
              decoration: const InputDecoration(labelText: 'Número da CTR'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitEditedData,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
