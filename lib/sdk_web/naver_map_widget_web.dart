part of 'naver_maps_sdk_flutter_web.dart';

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
    bool isViewFactoryRegistered = false;
    return FutureBuilder<web.HTMLDivElement>(
      future: naverMapManager._prepareMapFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return showLoading
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink();
        }
        if (snapshot.hasError) {
          return Center(child: Text('map load error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          final web.HTMLDivElement? mapDiv = snapshot.data;

          if (mapDiv != null) {
            if (!isViewFactoryRegistered) {
              ui.platformViewRegistry.registerViewFactory(mapDiv.id, (
                int viewId,
              ) {
                return mapDiv;
              });
              isViewFactoryRegistered = true;

              final observer = web.MutationObserver(
                (JSArray mutations, web.MutationObserver observer) {
                  if (web.document.body!.contains(mapDiv)) {
                    naverMapManager._initializeNaverMap(mapOptions);
                    observer.disconnect();
                  }
                }.toJS,
              );

              observer.observe(
                web.document.body!,
                web.MutationObserverInit(childList: true, subtree: true),
              );
            }
            return HtmlElementView(viewType: mapDiv.id);
          }
        }
        return const Center(child: Text('unknown error'));
      },
    );
  }
}
