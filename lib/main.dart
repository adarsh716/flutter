import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  ThemeMode _themeMode = ThemeMode.dark; 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.black,
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: _themeMode, 
      home: CalculatorHomePage(
        toggleTheme: _toggleThemeMode, 
      ),
    );
  }

  void _toggleThemeMode() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }
}

class CalculatorHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  CalculatorHomePage({required this.toggleTheme});

  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _display = '0';
  String _result = '0';
  String _operation = '';
  double _firstOperand = 0;
  double _secondOperand = 0;
  bool _shouldClearDisplay = false;

  void _onButtonClick(String value) {
    setState(() {
      if (value == 'C') {
        _clear();
      } else if (value == '+' || value == '-' || value == '×' || value == '÷') {
        _firstOperand = double.tryParse(_display) ?? 0;
        _operation = value;
        _shouldClearDisplay = true;
      } else if (value == '=') {
        _secondOperand = double.tryParse(_display) ?? 0;
        _calculateResult();
        _operation = '';
      } else {
        if (_shouldClearDisplay) {
          _display = value;
          _shouldClearDisplay = false;
        } else {
          _display = _display == '0' ? value : _display + value;
        }
      }
    });
  }

  void _calculateResult() {
    if (_operation == '+') {
      _result = (_firstOperand + _secondOperand).toString();
    } else if (_operation == '-') {
      _result = (_firstOperand - _secondOperand).toString();
    } else if (_operation == '×') {
      _result = (_firstOperand * _secondOperand).toString();
    } else if (_operation == '÷') {
      _result = (_secondOperand != 0)
          ? (_firstOperand / _secondOperand).toString()
          : 'Error';
    }
    _display = _result;
  }

  void _clear() {
    _display = '0';
    _result = '0';
    _operation = '';
    _firstOperand = 0;
    _secondOperand = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Calculator'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme, 
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Text(
                _operation.isEmpty ? _display : '$_firstOperand $_operation $_display',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          _buildButtonRow(['7', '8', '9', '÷']),
          _buildButtonRow(['4', '5', '6', '×']),
          _buildButtonRow(['1', '2', '3', '-']),
          _buildButtonRow(['C', '0', '=', '+']),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) {
        return _buildButton(button);
      }).toList(),
    );
  }

  Widget _buildButton(String label) {
    return Container(
      margin: EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () => _onButtonClick(label),
        child: Text(
          label,
          style: TextStyle(fontSize: 28, color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        ),
      ),
    );
  }
}
