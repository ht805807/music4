import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  final String url;
  const WebviewPage(this.url,{super.key});


  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(
        const PlatformWebViewControllerCreationParams());

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            //context.read<WebviewManager>().changeLoadingProgress(progress);
          },
          onPageStarted: (String url) {
            //context.read<WebviewManager>().changeLoadingStatus(true);
          },
          onPageFinished: (String url) {
            //context.read<WebviewManager>().changeLoadingStatus(false);
          },
          onWebResourceError: (WebResourceError error) {
           // context
                //.read<DialogManager>()
               // .setErrorDialog(error, DialogType.webviewError);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}