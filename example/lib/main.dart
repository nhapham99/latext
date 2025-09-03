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
    text: r"""$$-4{,}9 < 0; \ \dfrac{11}{3}> 0$$ nên$$ -4{,}9 <\dfrac{11}{3}.$$
\\n\\n $$0 <\dfrac{11}{3}.$$
\\n\\n $$2{,}58 < 3 <\dfrac{9}{3}<\dfrac{11}{3}.$$
\\n\\n$$4\dfrac{1}{5}> 4;\dfrac{11}{3}<\dfrac{12}{3}= 4$$ nên$$4\dfrac{1}{5}>\dfrac{11}{3}.$$
\\n\\nVậy trong các số đã cho, có các số $$-4{,}9; 0; 2{,}58$$ là nhỏ hơn$$\dfrac{11}{3}.$$""",
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
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 100.0),
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
                  breakDelimiter: r'\\n',
                  equationStyle: const TextStyle(
                    fontSize: 16,
                    height: 1.7,
                  ),
                  laTeXCode: Text(
                    _laTeX,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.7,
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
