import 'package:flutter/material.dart';

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  static const Color _darkGray = Color(0xFF4A4A4A);
  static const Color _lightGray = Color(0xFFA5A5A5);
  static const Color _yellow = Color(0xFFFFB000);

  String _display = '0';
  double? _firstOperand;
  String? _operation;
  bool _shouldResetDisplay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Text(
                  _display,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 55,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            _buildRow(<_ButtonData>[
              _ButtonData(
                label: 'AC',
                color: _lightGray,
                textColor: Colors.black,
                onTap: _allClear,
              ),
              _ButtonData(
                label: '±',
                color: _lightGray,
                textColor: Colors.black,
                onTap: _toggleSign,
              ),
              _ButtonData(
                label: '%',
                color: _lightGray,
                textColor: Colors.black,
                onTap: _percentage,
              ),
              _ButtonData(
                label: '÷',
                color: _yellow,
                textColor: Colors.white,
                onTap: () => _setOperation('/'),
              ),
            ]),
            _buildRow(<_ButtonData>[
              _ButtonData(
                label: '7',
                color: _darkGray,
                textColor: Colors.white,
                onTap: () => _inputDigit('7'),
              ),
              _ButtonData(
                label: '8',
                color: _darkGray,
                textColor: Colors.white,
                onTap: () => _inputDigit('8'),
              ),
              _ButtonData(
                label: '9',
                color: _darkGray,
                textColor: Colors.white,
                onTap: () => _inputDigit('9'),
              ),
              _ButtonData(
                label: '×',
                color: _yellow,
                textColor: Colors.white,
                onTap: () => _setOperation('*'),
              ),
            ]),
            _buildRow(<_ButtonData>[
              _ButtonData(
                label: '4',
                color: _darkGray,
                textColor: Colors.white,
                onTap: () => _inputDigit('4'),
              ),
              _ButtonData(
                label: '5',
                color: _darkGray,
                textColor: Colors.white,
                onTap: () => _inputDigit('5'),
              ),
              _ButtonData(
                label: '6',
                color: _darkGray,
                textColor: Colors.white,
                onTap: () => _inputDigit('6'),
              ),
              _ButtonData(
                label: '-',
                color: _yellow,
                textColor: Colors.white,
                onTap: () => _setOperation('-'),
              ),
            ]),
            _buildRow(<_ButtonData>[
              _ButtonData(
                label: '1',
                color: _darkGray,
                textColor: Colors.white,
                onTap: () => _inputDigit('1'),
              ),
              _ButtonData(
                label: '2',
                color: _darkGray,
                textColor: Colors.white,
                onTap: () => _inputDigit('2'),
              ),
              _ButtonData(
                label: '3',
                color: _darkGray,
                textColor: Colors.white,
                onTap: () => _inputDigit('3'),
              ),
              _ButtonData(
                label: '+',
                color: _yellow,
                textColor: Colors.white,
                onTap: () => _setOperation('+'),
              ),
            ]),
            _buildRow(<_ButtonData>[
              _ButtonData(
                label: '0',
                color: _darkGray,
                textColor: Colors.white,
                flex: 2,
                onTap: () => _inputDigit('0'),
              ),
              _ButtonData(
                label: ',',
                color: _darkGray,
                textColor: Colors.white,
                onTap: _inputComma,
              ),
              _ButtonData(
                label: '=',
                color: _yellow,
                textColor: Colors.white,
                onTap: _calculate,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<_ButtonData> buttons) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: buttons
            .map(
              (button) => Expanded(
                flex: button.flex,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _buildButton(button),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildButton(_ButtonData data) {
    return SizedBox(
      height: 78,
      child: ElevatedButton(
        onPressed: data.onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: data.color,
          foregroundColor: data.textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
        child: Text(data.label),
      ),
    );
  }

  void _inputDigit(String value) {
    setState(() {
      if (_display == 'Erro' || _shouldResetDisplay) {
        _display = value;
        _shouldResetDisplay = false;
        return;
      }

      if (_display == '0') {
        _display = value;
      } else {
        _display += value;
      }
    });
  }

  void _inputComma() {
    setState(() {
      if (_display == 'Erro' || _shouldResetDisplay) {
        _display = '0,';
        _shouldResetDisplay = false;
        return;
      }

      if (!_display.contains(',')) {
        _display += ',';
      }
    });
  }

  void _allClear() {
    setState(() {
      _display = '0';
      _firstOperand = null;
      _operation = null;
      _shouldResetDisplay = false;
    });
  }

  void _toggleSign() {
    final double? value = _parseDisplay();
    if (value == null || value == 0) {
      return;
    }

    setState(() {
      _display = _formatNumber(-value);
    });
  }

  void _percentage() {
    final double? value = _parseDisplay();
    if (value == null) {
      return;
    }

    setState(() {
      _display = _formatNumber(value / 100);
      _shouldResetDisplay = false;
    });
  }

  void _setOperation(String nextOperation) {
    final double? value = _parseDisplay();
    if (value == null) {
      return;
    }

    setState(() {
      if (_firstOperand != null && _operation != null && !_shouldResetDisplay) {
        _performCalculation(value);
      } else {
        _firstOperand = value;
      }

      _operation = nextOperation;
      _shouldResetDisplay = true;
    });
  }

  void _calculate() {
    final double? value = _parseDisplay();
    if (_firstOperand == null || _operation == null || value == null) {
      return;
    }

    setState(() {
      _performCalculation(value);
      _operation = null;
      _shouldResetDisplay = true;
    });
  }

  void _performCalculation(double secondOperand) {
    if (_firstOperand == null || _operation == null) {
      return;
    }

    double result;
    switch (_operation) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '-':
        result = _firstOperand! - secondOperand;
        break;
      case '*':
        result = _firstOperand! * secondOperand;
        break;
      case '/':
        if (secondOperand == 0) {
          _display = 'Erro';
          _firstOperand = null;
          _operation = null;
          _shouldResetDisplay = true;
          return;
        }
        result = _firstOperand! / secondOperand;
        break;
      default:
        return;
    }

    _display = _formatNumber(result);
    _firstOperand = result;
  }

  double? _parseDisplay() {
    return double.tryParse(_display.replaceAll(',', '.'));
  }

  String _formatNumber(double value) {
    if (value == 0) {
      return '0';
    }

    String text = value.toStringAsFixed(10);
    text = text.replaceFirst(RegExp(r'0+$'), '');
    text = text.replaceFirst(RegExp(r'\.$'), '');
    return text.replaceAll('.', ',');
  }
}

class _ButtonData {
  const _ButtonData({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
    this.flex = 1,
  });

  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  final int flex;
}