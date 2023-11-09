import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadName();
  }

  void _loadName() async {
    _prefs = await SharedPreferences.getInstance();
    String? name = _prefs.getString('name');
    if (name != null) {
      _controller.text = name;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('App lifecycle state: $state');
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _saveName();
    }
  }

  void _saveName() {
    String name = _controller.text;
    _prefs.setString('name', name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Process Death Simulation Example'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                    hintText: 'Enter your name',
                    contentPadding: EdgeInsets.all(5),
                    border: OutlineInputBorder()),
                controller: _controller,
              ),
              ElevatedButton(
                onPressed: () {
                  String name = _controller.text;
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Hello $name!'),
                      content: const Text('Nice to meet you!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Greet me'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
