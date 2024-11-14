import 'package:flutter/material.dart';
import 'package:latext/latext.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter LaTeX Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _laTeXInputController = TextEditingController(
    text: r'Tính diện tích phần tô màu bằng cách nhân $$0,72$$ với $$1/4.$$$$',
  );
  late String _laTeX;

  @override
  void initState() {
    _renderLaTeX();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('LaTexT Flutter Home Page'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      labelText: 'Your LaTeX code here',
                      helperText:
                          'Use \$ as delimiter. Use \$\$ for display LaTeX.'),
                  controller: _laTeXInputController,
                ),
              ),
              Builder(
                builder: (context) => LaTexT(
                  delimiter: r'$$',
                  breakDelimiter: r'\n',
                  laTeXCode: Text(
                    _laTeX,
                    style: const TextStyle(
                      fontSize: 40.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _renderLaTeX,
          tooltip: 'Render again. Only working on mobile platform.',
          label: const Text('Render LaTeX'),
          icon: const Icon(Icons.crop_rotate),
        ));
  }

  void _renderLaTeX() {
    setState(() {
      _laTeX = _laTeXInputController.text;
    });
  }
}
