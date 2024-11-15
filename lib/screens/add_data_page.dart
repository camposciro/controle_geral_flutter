import 'package:flutter/material.dart';

// Função para calcular o valor
String _calculateValue(String peso) {
  final pesoValue = double.tryParse(peso.replaceAll(RegExp('[^0-9.]'), '')) ?? 0.0;

  // Fórmula: (Peso * 100 * 11%) - 80
  final valor = (pesoValue * 100 * 0.00011) - 80;

  // Retorna o valor formatado com duas casas decimais
  return valor.toStringAsFixed(2);
}

class AddDataPage extends StatefulWidget {
  final Function(Map<String, String>) addDataCallback; // Função de callback para adicionar os dados
  final Map<String, String>? existingData; // Dados existentes para edição
  final bool isEdit; // Flag para verificar se é edição ou adição

  const AddDataPage({
    super.key,
    required this.addDataCallback,
    this.existingData,
    this.isEdit = false, // Default é false, indicando que não é edição
  });

  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _notaController = TextEditingController();
  final TextEditingController _ctrController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Preenche os controladores com os dados existentes (para edição)
    if (widget.isEdit && widget.existingData != null) {
      _pesoController.text = widget.existingData!['peso'] ?? '';
      _notaController.text = widget.existingData!['nota'] ?? '';
      _ctrController.text = widget.existingData!['ctr'] ?? '';
    }
  }

  // Função para processar o envio dos dados
  void _submitData() {
    final peso = _pesoController.text;
    final nota = _notaController.text;
    final ctr = _ctrController.text;

    if (peso.isEmpty || nota.isEmpty || ctr.isEmpty) {
      return;
    }

    // Gera a data e hora atuais se os dados existentes não forem fornecidos
    final now = DateTime.now();
    final dataHora = "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}";

    final newData = {
      'data': widget.isEdit ? widget.existingData!['data'] ?? dataHora.split(" ")[0] : dataHora.split(" ")[0],  // Mantém a data se for edição
      'hora': widget.isEdit ? widget.existingData!['hora'] ?? dataHora.split(" ")[1] : dataHora.split(" ")[1],  // Mantém a hora se for edição
      'peso': peso,
      'valor': _calculateValue(peso), // Calcula o valor baseado no peso
      'nota': nota,
      'ctr': ctr,
      'status': widget.isEdit ? widget.existingData!['status'] ?? 'Aguardando Descarga' : 'Aguardando Descarga', // Mantém status em edição
    };

    // Passa os dados de volta para a página principal
    widget.addDataCallback(newData);

    // Fecha a página de adição
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Editar Dados' : 'Adicionar Dados'), // Altera o título com base no modo
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
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green), // Cor verde para o botão "Salvar"
              child: Text(widget.isEdit ? 'Salvar Edição' : 'Adicionar Carga'), // Muda o texto do botão conforme o modo
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha a página de adição
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey), // Cor cinza para o botão "Cancelar"
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pesoController.dispose();
    _notaController.dispose();
    _ctrController.dispose();
    super.dispose();
  }
}
