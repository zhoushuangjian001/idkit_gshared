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
  gShared.register<Future<int>>(
    Future<int>.delayed(const Duration(seconds: 3), () {
      return 11;
    }),
  );
  gShared.register<int>(520);
  gShared.register<int>(1314, mark: 'love');
  gShared.register(
    Future.delayed(
      const Duration(seconds: 10),
      () {
        return const TestInfo('Asynchronous registration');
      },
    ),
  );
  gShared.register(
    Future.delayed(
      const Duration(seconds: 1),
      () {
        return const TestInfo('Asynchronous registration -- Mark');
      },
    ),
    mark: 'r_mark',
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
            FutureBuilder<int>(
              future: gShared.read<Future<int>>(),
              initialData: 1010,
              builder: (_, AsyncSnapshot<int> snapshot) {
                return Text('${snapshot.data}');
              },
            ),
            Text('${gShared.read<int>() ?? 0}'),
            Text('${gShared.read<int>(mark: 'love') ?? 0}'),
            FutureBuilder<TestInfo>(
              future: gShared.read(),
              initialData: const TestInfo('TestInfo - Default - 111'),
              builder: (_, AsyncSnapshot<TestInfo> snapshot) {
                final TestInfo? count = snapshot.data;
                return Text(count?.name ?? 'TestInfo - Default - 222');
              },
            ),
            FutureBuilder<TestInfo>(
              future: gShared.read(mark: 'r_mark'),
              initialData: const TestInfo('TestInfo - Default - 333'),
              builder: (_, AsyncSnapshot<TestInfo> snapshot) {
                final TestInfo? count = snapshot.data;
                return Text(count?.name ?? 'TestInfo - Default - 444');
              },
            ),
            ElevatedButton(
              child: const Text('Next Step'),
              onPressed: () {
                gShared.register<String>('who are you?', mark: 'wz');
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
    gShared.registerListen<String>(mark: 'listen');
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
                  stream: gShared.watch<String>(mark: 'listen'),
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
