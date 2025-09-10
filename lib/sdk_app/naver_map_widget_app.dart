part of 'naver_maps_sdk_flutter_app.dart';

class NaverMapWidget extends StatelessWidget {
  final MapOptions? mapOptions;
  final NaverMapManager naverMapManager;
  final bool showLoading;

  const NaverMapWidget({
    super.key,
    required this.naverMapManager,
    this.mapOptions,
    this.showLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    naverMapManager.onTapLink = (url) {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(url));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SafeArea(
            child: Scaffold(
              body: WebViewWidget(controller: controller),
            ),
          ),
        ),
      );
    };

    return FutureBuilder<void>(
      future: naverMapManager.onPageFinished,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return showLoading
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        naverMapManager._initializeNaverMap(mapOptions);

        return WebViewWidget(controller: naverMapManager._controller);
      },
    );
  }
}
