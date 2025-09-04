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
    text:
        r"""$$s^2 = \frac{1}{40}[ (20 - 22.1)^2 \cdot 5 + \dots + (24 - 22.1) + (1 + 2 + 3 + 4 + 5)$$\\nmot hai ba $$\frac{1}{40}$$
        \\n
        Ta có:$$\displaystyle \int \limits_{0}\limits^{2}(x^2 + 2x - 3)dx =\left.(\frac{x^3}{3} + x^2 - 3x)\right|_{0}^{2} = \dfrac{2}{3}.$$\\n
        Sản lượng trung bình của 40 thửa ruộng là:\\n
$$\overline{x}=\dfrac{20\cdot 5+21\cdot 8+22 \cdot11+23\cdot 10+24\cdot 6}{40}=22{,}1.$$\\n
Phương sai của mẫu số liệu là:\\n
$$s^2=\dfrac{1}{40} \left[(20-22{,}1)^2\cdot 5+...+(24-22{,}1)^2 \cdot 6 \right ]$$\\n\\n
$$s^2=1{,}54.$$\\n
Độ lệch chuẩn của mẫu số liệu là:\\n
$$s=\sqrt{s^2}=\sqrt{1{,}54} \approx 1{,}24.$$
        """,
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
                      height: 1.2,
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
