import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  await Permission.photos.request();
  await Permission.microphone.request();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brasil Pos Ead',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
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
  late WebViewController controller;

  String lastUrl = "";

  void addFileSelectionListener() async {
    if (Platform.isAndroid) {
      final androidController = controller.platform as AndroidWebViewController;
      await androidController.setOnShowFileSelector(_androidFilePicker);
    }
  }

  Future<List<String>> _androidFilePicker(
      final FileSelectorParams params) async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      return [file.uri.toString()];
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    controller = WebViewController.fromPlatformCreationParams(
      const PlatformWebViewControllerCreationParams(),
      onPermissionRequest: (request) async => await request.grant(),
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..setUserAgent(
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36")
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) {},
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            lastUrl = request.url;
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse("https://www.brasilposead.com.br"));
    addFileSelectionListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => controller.goBack(),
          ),
        ),
        title: const Text(
          "BrasilPós EaD",
          style: TextStyle(
            color: Color(0xFF006400),
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFFFACC33),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Image.asset(
                "assets/BRPOS_bg.png",
              ),
            ),
            ListTile(
              onTap: () => controller
                ..loadRequest(Uri.parse("https://www.brasilposead.com.br"))
                    .then((value) {
                  Navigator.pop(context);
                  return lastUrl = "https://www.brasilposead.com.br";
                }),
              title: const Text("Plataforma EaD"),
            ),
            const Divider(),
            ListTile(
              onTap: () => controller
                ..loadRequest(Uri.parse("https://brasilpos.com.br"))
                    .then((value) {
                  Navigator.pop(context);
                  return lastUrl = "https://brasilpos.com.br";
                }),
              title: const Text("Site BrasilPós"),
            ),
            const Divider(),
            ListTile(
              onTap: () => controller
                ..loadRequest(Uri.parse("https://brasilposead.com.br/senha"))
                    .then((value) {
                  Navigator.pop(context);
                  return lastUrl = "https://www.brasilposead.com.br/senha";
                }),
              title: const Text("Recuperar Senha"),
            ),
            const Divider(),
            ListTile(
              onTap: () => controller
                ..loadRequest(Uri.parse("https://brasilposead.com.br/normas"))
                    .then((value) {
                  Navigator.pop(context);
                  return lastUrl = "https://www.brasilposead.com.br/normas";
                }),
              title: const Text("Normas e Procedimentos"),
            ),
            const Divider(),
            ListTile(
              onTap: () => controller
                ..loadRequest(Uri.parse("https://brasilposead.com.br/privacy"))
                    .then((value) {
                  Navigator.pop(context);
                  return lastUrl = "https://www.brasilposead.com.br/privacy";
                }),
              title: const Text("Política de Privacidade"),
            ),
            const Divider(),
            ListTile(
              onTap: () => controller
                ..loadRequest(Uri.parse("https://brasilposead.com.br/suporte"))
                    .then((value) {
                  Navigator.pop(context);
                  return lastUrl = "https://www.brasilposead.com.br/suporte";
                }),
              title: const Text("Suporte"),
            ),
            const Divider(),
            ListTile(
              onTap: () => controller
                ..loadRequest(Uri.parse("https://brasilposead.com.br/sobre"))
                    .then((value) {
                  Navigator.pop(context);
                  return lastUrl = "https://www.brasilposead.com.br/sobre";
                }),
              title: const Text("Sobre"),
            ),
            const Divider(),
          ],
        ),
      ),
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}
