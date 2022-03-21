import 'package:flutter/material.dart';
import 'package:idkit_gshared/idkit_gshared.dart';

/// Global Shared Simple Interest
final IDKitGShared gShared = IDKitGShared();

/// Test class
class TestInfo {
  final String name;
  const TestInfo(this.name);
}

void main() {
  gShared.register<int>(520);
  gShared.register<int>(1314, mark: 'love');
  gShared.register(
    const TestInfo('Asynchronous registration'),
  );
  gShared.register(
    const TestInfo('Asynchronous registration - Mark'),
    mark: 'r_mark',
  );

  gShared.register<Future<String>>(
    Future.delayed(const Duration(seconds: 1), () {
      return '110';
    }),
  );
  gShared.register<Future<TestInfo>>(
    Future.delayed(const Duration(seconds: 1), () {
      return const TestInfo('120');
    }),
    mark: 'mark',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('idkit_gshared test'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text('${gShared.read<int>() ?? 0}'),
            Text('${gShared.read<int>(mark: 'love') ?? 0}'),
            Text('${gShared.read<TestInfo>()?.name ?? 0}'),
            Text('${gShared.read<TestInfo>()?.name ?? 0}'),
            FutureBuilder<String>(
              future: gShared.read<Future<String>>(),
              initialData: '000',
              builder: (_, AsyncSnapshot<String> snapshot) {
                return Text('${snapshot.data}');
              },
            ),
            FutureBuilder<String>(
              future: gShared.read<Future<String>>(mark: 'mark'),
              initialData: '000 - mark',
              builder: (_, AsyncSnapshot<String> snapshot) {
                return Text('${snapshot.data}');
              },
            ),
            ElevatedButton(
              child: const Text('Next Step'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return const SecondPage();
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late int count = 0;

  @override
  Widget build(BuildContext context) {
    gShared.registerListen<String>();
    gShared.registerListen<String>(mark: 'mark');
    return Scaffold(
      appBar: AppBar(
        title: const Text('idkit_gshared:Multi-layer data sharing'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(gShared.read<String>(mark: 'wz') ?? 'defaulu value: network'),
                StreamBuilder<String?>(
                  stream: gShared.watch<String>(),
                  initialData: 'listen - 0',
                  builder: (_, s) {
                    final String? a = s.data;
                    return Text(a ?? 'listen - 0');
                  },
                ),
                StreamBuilder<String?>(
                  stream: gShared.watch<String>(mark: 'mark'),
                  initialData: 'listen - 0',
                  builder: (_, s) {
                    final String? a = s.data;
                    return Text(a ?? 'listen - 0');
                  },
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    count++;
                    gShared.add<String>('listen - $count', mark: 'listen');
                  },
                  child: const Text('Add Count + 1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return const ThreePage();
                    }));
                  },
                  child: const Text('Next Step Button'),
                ),
                ElevatedButton(
                  onPressed: () {
                    gShared.unRegister<String>();
                    gShared.unRegister<String>(mark: 'mark');
                    gShared.unRegisterAll();
                    gShared.unRegisterAll(listen: true);
                    gShared.update<String>((value) => 'I am a baby!');
                  },
                  child: const Text('Update Data'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ThreePage extends StatefulWidget {
  const ThreePage({Key? key}) : super(key: key);

  @override
  State<ThreePage> createState() => _ThreePageState();
}

class _ThreePageState extends State<ThreePage> {
  late int count = 0;

  @override
  Widget build(BuildContext context) {
    gShared.convertListen<int>();
    gShared.unRegisterListen<String>();
    gShared.unRegisterListen<String>(mark: 'mark');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Three Page 3'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text(gShared.read<String>() ?? ''),
            StreamBuilder<int?>(
              stream: gShared.watch<int>(),
              initialData: 0000,
              builder: (_, s) {
                return Text('${s.data ?? 1111}');
              },
            )
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: const Text('Add Change + 1'),
        onPressed: () {
          count++;
          gShared.add<int>(count);
        },
      ),
    );
  }
}
