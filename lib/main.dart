import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Deeplink Universal Link from Flutter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Open Deeplink Universal Link from Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String inappbrowserLink = 'https://codepen.io/zfir/full/emppwJb';
  static const String universalLink =
      'https://app.sharinpix.com/native_app/form?token=eyJhbGciOiJIUzI1NiJ9.eyJhbGJ1bV9pZCI6ImEyNkhwMDAwMDBSdDRES0lBWiIsInRlbXBsYXRlX3VybCI6Imh0dHBzOi8vYXBwLnNoYXJpbnBpeC5jb20vby9jYzdlL2Zvcm0vdGVtcGxhdGVzL2YxYzljYTJhLTYzMmItNGYzZS1hYThlLTdlOTI2ZGE0ZGIwMCIsInRlbXBsYXRlX2lkIjoiYTI2SHAwMDAwMFJ0NERLSUFaIiwiaXNzIjoiMmIyYjZjYzUtNmMxZS00MWY3LWIxYjktOGI1N2M2MjFmZDgxIn0.EESE6y3GBBag4vwJ1CCvtene3DMvTgPoZc8JSxE70KE&form=https%3A%2F%2Fapp.sharinpix.com%2Fo%2Fcc7e%2Fform%2Ftemplates%2Ff1c9ca2a-632b-4f3e-aa8e-7e926da4db00.json&form_online_mode=true';
  static const String deepLink =
      'sharinpix://form?token=eyJhbGciOiJIUzI1NiJ9.eyJhbGJ1bV9pZCI6ImEyNkhwMDAwMDBSdDRES0lBWiIsInRlbXBsYXRlX3VybCI6Imh0dHBzOi8vYXBwLnNoYXJpbnBpeC5jb20vby9jYzdlL2Zvcm0vdGVtcGxhdGVzL2YxYzljYTJhLTYzMmItNGYzZS1hYThlLTdlOTI2ZGE0ZGIwMCIsInRlbXBsYXRlX2lkIjoiYTI2SHAwMDAwMFJ0NERLSUFaIiwiaXNzIjoiMmIyYjZjYzUtNmMxZS00MWY3LWIxYjktOGI1N2M2MjFmZDgxIn0.EESE6y3GBBag4vwJ1CCvtene3DMvTgPoZc8JSxE70KE&form=https%3A%2F%2Fapp.sharinpix.com%2Fo%2Fcc7e%2Fform%2Ftemplates%2Ff1c9ca2a-632b-4f3e-aa8e-7e926da4db00.json';

  String? currentUrl;

  void _openInappbrowserLink() {
    setState(() {
      currentUrl = inappbrowserLink;
    });
  }

  void _openUniversalLink() {
    setState(() {
      currentUrl = universalLink;
    });
  }

  void _openDeepLink() async {
    try {
      print('Launching deep link directly: $deepLink');
      await launchUrl(Uri.parse(deepLink), mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error launching deep link: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open SharinPix app: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          if (currentUrl != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  currentUrl = null;
                });
              },
            ),
        ],
      ),
      body: currentUrl == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _openInappbrowserLink,
                    child: const Text('Open Inappbrowser Link'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _openUniversalLink,
                    child: const Text('Open Universal Link'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _openDeepLink,
                    child: const Text('Open Deep Link'),
                  ),
                ],
              ),
            )
          : InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(currentUrl!)),
              /// Deep Link Handling in InAppWebView
              /// 
              /// This method intercepts all navigation requests within the WebView and handles
              /// deep link redirections to external applications.
              /// 
              /// How it works:
              /// 1. Intercepts every URL navigation attempt in the WebView
              /// 2. Checks if the target URL is a deep link (custom scheme like 'sharinpix://')
              /// 3. If it's a deep link, launches the external app and cancels the WebView navigation
              /// 4. If it's a regular URL, allows normal WebView navigation
              /// 
              /// Parameters:
              /// - controller: The WebView controller instance
              /// - navigationAction: Contains the navigation request details
              /// 
              /// Returns:
              /// - NavigationActionPolicy.CANCEL: Stops WebView navigation (for deep links)
              /// - NavigationActionPolicy.ALLOW: Allows normal WebView navigation
              /// 
              /// Example deep link format: 'sharinpix://form?token=...&form=...&host=...'
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final url = await controller.getUrl();
                final deeplink = navigationAction.request.url;

                if (deeplink != null && url != navigationAction.request.url) {
                  if (deeplink.scheme == 'https' && deeplink.host == 'app.sharinpix.com' && Platform.isAndroid) {
                    launchUrl(deeplink, mode: LaunchMode.externalApplication);
                    return NavigationActionPolicy.CANCEL;
                  }

                  if (deeplink.scheme == 'sharinpix') {
                    launchUrl(deeplink, mode: LaunchMode.externalApplication);
                    return NavigationActionPolicy.CANCEL;
                  }
                }

                return NavigationActionPolicy.ALLOW;
              },
              onLoadError: (controller, url, code, message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error loading: $message'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              onCreateWindow: (controller, createWindowRequest) async {
                final url = createWindowRequest.request.url;
                if (url != null) {
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                }
                return true;
              },
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                useShouldOverrideUrlLoading: true,
                javaScriptCanOpenWindowsAutomatically: true,
                supportMultipleWindows: true,
              ),
            ),
    );
  }
}


