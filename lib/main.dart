import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo da Velha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Jogo da Velha'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> celula = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];

  String jogador = 'x';
  bool fimJogo = false;
  int vitoriasX = 0;
  int vitoriasO = 0;

  @override
  void initState() {
    super.initState();
    jogador = 'x';
    vitoriasX = 0;
    vitoriasO = 0;
    fimJogo = false;
  }

  List<Widget> mensagem = [];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double celulaSize = size.width / 3;

    final List<Widget> buttons = [
      Card(
          color: Colors.green,
          child: ListTile(
              onTap: novoJogo,
              title: const Text(
                'Novo Jogo',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))),
      Card(
          color: Colors.red,
          child: ListTile(
              onTap: reset,
              title: const Text(
                'Reset',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))),
    ];

    List<Widget> newMensagem = [
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: '',
          style:
              TextStyle(fontSize: celulaSize / 2, fontWeight: FontWeight.bold),
          children: <TextSpan>[
            const TextSpan(text: 'X', style: TextStyle(color: Colors.green)),
            TextSpan(
                text: ' $vitoriasX - $vitoriasO ',
                style:
                    TextStyle(color: Colors.black, fontSize: celulaSize / 3)),
            const TextSpan(text: 'O', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
      ...mensagem
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return newMensagem[index];
                },
                childCount: newMensagem.length,
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: celulaSize,
                mainAxisExtent: celulaSize,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  Text text = Text(
                    celula[index],
                    textAlign: TextAlign.center,
                  );
                  switch (celula[index]) {
                    case 'x':
                      text = Text(
                        'X',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: celulaSize / 2),
                        textAlign: TextAlign.center,
                      );
                      break;
                    case 'o':
                      text = Text(
                        'O',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: celulaSize / 2),
                        textAlign: TextAlign.center,
                      );
                      break;
                    default:
                  }
                  return Card(
                      child: InkWell(
                          onTap: () {
                            setJoga(index);
                          },
                          child: Align(
                              alignment: Alignment.center,
                              child: ListTile(title: text))));
                },
                childCount: celula.length,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return buttons[index];
                },
                childCount: buttons.length,
              ),
            ),
          ],
        ));
  }

  void novoJogo() {
    celula = [
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    ];
    mensagem.clear();

    setState(() {
      fimJogo = false;
    });
  }

  void reset() {
    celula = [
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    ];
    mensagem.clear();

    setState(() {
      jogador = 'x';
      vitoriasX = 0;
      vitoriasO = 0;
      fimJogo = false;
    });
  }

  void setJoga(int index) {
    if (fimJogo || celula[index].isNotEmpty) {
      return;
    }

    celula[index] = jogador;
    isFimJogo();
    if (jogador == 'x') {
      setState(() {
        jogador = 'o';
      });
    } else {
      setState(() {
        jogador = 'x';
      });
    }
  }

  void isFimJogo() {
    if (getVencedor(0, 1, 2) ||
        getVencedor(3, 4, 5) ||
        getVencedor(6, 7, 8) ||
        getVencedor(0, 3, 6) ||
        getVencedor(1, 4, 7) ||
        getVencedor(2, 5, 8) ||
        getVencedor(0, 4, 8) ||
        getVencedor(6, 4, 2)) {
      mensagem.add(ListTile(
          title: Text(
        'Jogador $jogador venceu!',
        textAlign: TextAlign.center,
      )));
      int x = vitoriasX;
      int o = vitoriasO;
      if (jogador == 'x') {
        x++;
      } else {
        o++;
      }
      setState(() {
        vitoriasX = x;
        vitoriasO = o;
        fimJogo = true;
      });
    }

    if (!celula.contains('')) {
      mensagem.add(const ListTile(
          title: Text(
        'Deu velha',
        textAlign: TextAlign.center,
      )));
      setState(() {
        fimJogo = true;
      });
    }
  }

  bool getVencedor(int c1, int c2, int c3) {
    return [celula[c1], celula[c2], celula[c3]]
            .where((c) => c == jogador)
            .length ==
        3;
  }
}
