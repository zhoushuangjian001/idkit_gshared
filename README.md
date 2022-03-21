## idkit_gshared

#### 1. Briefly

This package is for global data sharing of Flutter projects. The following is a detailed introduction and use of its methods.

#### 2. Use

- Preconditions
  First create a global shared data management object，As follows:
  ```dart
  final IDKitGShared gShared = IDKitGShared();
  ```
- Basic sharing

  ### Register

  ###### 1.Register int、list、map......

  ```dart
  gShared.register<int>(520);
  gShared.register<int>(1314, mark: 'love');
  ```

  ###### 2. Register object

  ```dart
  gShared.register(
      const TestInfo('Asynchronous registration'),
  );
  gShared.register(
      const TestInfo('Asynchronous registration - Mark'),
      mark: 'mark',
  );
  ```

  ###### 3. Asynchronous registration

  ```dart
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
  ```

  ### Read

  ###### 1. Read int、list、map......

  ```dart
  gShared.read<int>() -> int?
  gShared.read<int>(mark: 'love') -> int?
  ```

  ###### 2. Read object

  ```dart
  gShared.read<TestInfo>() -> TestInfo?
  gShared.read<TestInfo>(mark: 'mark') -> TestInfo?
  ```

  ###### 3. Read data asynchronously

  ```dart
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
  ```

  ### Update data

  ```dart
  gShared.update<String>((value) => 'I am a baby!');
  gShared.update<String>((value) => 'I am a baby!',mark:'mark');
  ```

  ### unRegister

  ```dart
  gShared.unRegister<String>();
  gShared.unRegister<String>(mark: 'mark');
  ```

  or

  ```dart
  gShared.unRegisterAll();
  gShared.unRegisterAll(listen: true);
  ```

- Listen sharing

  ### Register

  ```dart
  gShared.registerListen<String>();
  gShared.registerListen<String>(mark: 'mark');
  ```

  ### Watch

  ```dart
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
  ```

  ### unRegister listen

  ```dart
  gShared.unRegisterListen<String>();
  gShared.unRegisterListen<String>(mark: 'mark');
  ```

  ### Convert

  ```dart
  gShared.convertListen<int>();
  gShared.convertListen<int>(mark:'mark');
  ```

### 3. Summarize

This version of the package covers some of the above methods. If you don't understand anything or don't understand how to use it, you can leave me a message!
