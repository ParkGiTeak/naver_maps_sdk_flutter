import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:naver_maps_sdk_flutter/enum/naver_map_map_type_id.dart';
import 'package:naver_maps_sdk_flutter/enum/naver_map_position_type.dart';
import 'package:naver_maps_sdk_flutter/model/bounds.dart';
import 'package:naver_maps_sdk_flutter/model/coord.dart';
import 'package:naver_maps_sdk_flutter/model/logo_control_options.dart';
import 'package:naver_maps_sdk_flutter/model/map_data_control_options.dart';
import 'package:naver_maps_sdk_flutter/model/map_type_control_options.dart';
import 'package:naver_maps_sdk_flutter/model/n_padding.dart';
import 'package:naver_maps_sdk_flutter/model/n_size.dart';
import 'package:naver_maps_sdk_flutter/util/map_options_utils.dart';

import 'scale_control_options.dart';
import 'zoom_control_options.dart';

class MapOptions {
  /// 지도 요소의 배경으로 사용할 이미지 URL 또는 CSS 색상값
  final String? background;

  /// 지도 기본 타일의 불투명도 (0~1)
  final double? baseTileOpacity;

  /// 지도의 초기 좌표 경계 (Bounds|BoundsLiteral)
  final Bounds? bounds;

  /// 지도의 초기 중심 좌표 (Coord|CoordLiteral) - 기본값: 서울 시청
  final Coord? center;

  /// 더블 클릭 줌 비활성화 여부
  final bool? disableDoubleClickZoom;

  /// 더블 탭 줌 비활성화 여부
  final bool? disableDoubleTapZoom;

  /// 관성 패닝 비활성화 여부
  final bool? disableKineticPan;

  /// 두 손가락 탭 줌 비활성화 여부
  final bool? disableTwoFingerTapZoom;

  /// 드래깅 허용 여부
  final bool? draggable;

  /// 키보드 단축키 허용 여부
  final bool? keyboardShortcuts;

  /// 네이버 로고 컨트롤 표시 여부
  final bool? logoControl;

  /// 네이버 로고 컨트롤 옵션
  final LogoControlOptions? logoControlOptions;

  /// 지도 데이터 저작권 컨트롤 표시 여부
  final bool? mapDataControl;

  /// 지도 데이터 저작권 컨트롤 옵션
  final MapDataControlOptions? mapDataControlOptions;

  /// 지도 유형 컨트롤 표시 여부
  final bool? mapTypeControl;

  /// 지도 유형 컨트롤 옵션
  final MapTypeControlOptions? mapTypeControlOptions;

  /// 지도의 초기 지도 유형 ID
  final NaverMapMapTypeId? mapTypeId;

  /// 지도에서 보이는 최대 좌표 경계 (Bounds|BoundsLiteral)
  final Bounds? maxBounds;

  /// 지도의 최대 줌 레벨
  final int? maxZoom;

  /// 지도의 최소 줌 레벨
  final int? minZoom;

  /// 지도 뷰포트의 안쪽 여백 (padding)
  final NPadding? padding;

  /// 핀치 줌 허용 여부
  final bool? pinchZoom;

  /// 지도 크기 조정 시 고정할 원점
  final NaverMapPositionType? resizeOrigin;

  /// 축척 컨트롤 표시 여부
  final bool? scaleControl;

  /// 축척 컨트롤 옵션
  final ScaleControlOptions? scaleControlOptions;

  /// 스크롤 휠 줌 허용 여부
  final bool? scrollWheel;

  /// 지도의 초기 크기 (Size|SizeLiteral)
  final NSize? size;

  /// 오버레이 줌 효과 적용 대상
  final String? overlayZoomEffect;

  /// 여유있게 로딩할 타일 수
  final int? tileSpare;

  /// 타일 전환 효과 사용 여부
  final bool? tileTransition;

  /// 타일 전환 효과 지속 시간 (밀리초)
  final int? tileDuration;

  /// 지도의 초기 줌 레벨
  final int? zoom;

  /// 줌 컨트롤 표시 여부
  final bool? zoomControl;

  /// 줌 컨트롤 옵션
  final ZoomControlOptions? zoomControlOptions;

  /// 줌 효과 시 고정할 기준 좌표 (Coord|CoordLiteral)
  final Coord? zoomOrigin;

  /// 빈 타일 이미지 URL
  final String? blankTileImage;

  /// GL 서브모듈 벡터맵 활성화 여부
  final bool? gl;

  /// Style Editor에서 발행한 커스텀 스타일 Metadata ID
  final String? customStyleId;

  const MapOptions({
    this.background,
    this.baseTileOpacity,
    this.bounds,
    this.center,
    this.disableDoubleClickZoom,
    this.disableDoubleTapZoom,
    this.disableKineticPan,
    this.disableTwoFingerTapZoom,
    this.draggable,
    this.keyboardShortcuts,
    this.logoControl,
    this.logoControlOptions,
    this.mapDataControl,
    this.mapDataControlOptions,
    this.mapTypeControl,
    this.mapTypeControlOptions,
    this.mapTypeId,
    this.maxBounds,
    this.maxZoom,
    this.minZoom,
    this.padding,
    this.pinchZoom,
    this.resizeOrigin,
    this.scaleControl,
    this.scaleControlOptions,
    this.scrollWheel,
    this.size,
    this.overlayZoomEffect,
    this.tileSpare,
    this.tileTransition,
    this.tileDuration,
    this.zoom,
    this.zoomControl,
    this.zoomControlOptions,
    this.zoomOrigin,
    this.blankTileImage,
    this.gl,
    this.customStyleId,
  });

  factory MapOptions.fromJson(Map<String, dynamic> json) {
    return MapOptions(
      background: json['background'],
      baseTileOpacity: json['baseTileOpacity']?.toDouble(),
      bounds: MapOptionsUtils.parseBounds(json['bounds']),
      center: MapOptionsUtils.parseCoord(json['center']),
      disableDoubleClickZoom: json['disableDoubleClickZoom'],
      disableDoubleTapZoom: json['disableDoubleTapZoom'],
      disableKineticPan: json['disableKineticPan'],
      disableTwoFingerTapZoom: json['disableTwoFingerTapZoom'],
      draggable: json['draggable'],
      keyboardShortcuts: json['keyboardShortcuts'],
      logoControl: json['logoControl'],
      logoControlOptions: json['logoControlOptions'] != null
          ? LogoControlOptions()
          : null,
      mapDataControl: json['mapDataControl'],
      mapDataControlOptions: json['mapDataControlOptions'] != null
          ? MapDataControlOptions()
          : null,
      mapTypeControl: json['mapTypeControl'],
      mapTypeControlOptions: json['mapTypeControlOptions'] != null
          ? MapTypeControlOptions()
          : null,
      mapTypeId: json['mapTypeId'] != null
          ? NaverMapMapTypeId.fromString(json['mapTypeId'])
          : null,
      maxBounds: MapOptionsUtils.parseBounds(json['maxBounds']),
      maxZoom: json['maxZoom'],
      minZoom: json['minZoom'],
      padding: MapOptionsUtils.parsePadding(json['padding']),
      pinchZoom: json['pinchZoom'],
      resizeOrigin: json['resizeOrigin'] != null
          ? NaverMapPositionType.values.firstWhere(
              (e) => e.value == json['resizeOrigin'],
              orElse: () => NaverMapPositionType.center,
            )
          : null,
      scaleControl: json['scaleControl'],
      scaleControlOptions: json['scaleControlOptions'] != null
          ? ScaleControlOptions()
          : null,
      scrollWheel: json['scrollWheel'],
      size: MapOptionsUtils.parseSize(json['size']),
      overlayZoomEffect: json['overlayZoomEffect'],
      tileSpare: json['tileSpare'],
      tileTransition: json['tileTransition'],
      tileDuration: json['tileDuration'],
      zoom: json['zoom'],
      zoomControl: json['zoomControl'],
      zoomControlOptions: json['zoomControlOptions'] != null
          ? ZoomControlOptions()
          : null,
      zoomOrigin: MapOptionsUtils.parseCoord(json['zoomOrigin']),
      blankTileImage: json['blankTileImage'],
      gl: json['gl'],
      customStyleId: json['customStyleId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (background != null)
        'background': kIsWeb ? background : jsonEncode(background),
      if (baseTileOpacity != null)
        'baseTileOpacity': kIsWeb
            ? baseTileOpacity
            : jsonEncode(baseTileOpacity),
      if (bounds != null) 'bounds': bounds!.toJson(),
      if (center != null) 'center': center!.toJson(),
      if (disableDoubleClickZoom != null)
        'disableDoubleClickZoom': kIsWeb
            ? disableDoubleClickZoom
            : jsonEncode(disableDoubleClickZoom),
      if (disableDoubleTapZoom != null)
        'disableDoubleTapZoom': kIsWeb
            ? disableDoubleTapZoom
            : jsonEncode(disableDoubleTapZoom),
      if (disableKineticPan != null)
        'disableKineticPan': kIsWeb
            ? disableKineticPan
            : jsonEncode(disableKineticPan),
      if (disableTwoFingerTapZoom != null)
        'disableTwoFingerTapZoom': kIsWeb
            ? disableTwoFingerTapZoom
            : jsonEncode(disableTwoFingerTapZoom),
      if (draggable != null)
        'draggable': kIsWeb ? draggable : jsonEncode(draggable),
      if (keyboardShortcuts != null)
        'keyboardShortcuts': kIsWeb
            ? keyboardShortcuts
            : jsonEncode(keyboardShortcuts),
      if (logoControl != null)
        'logoControl': kIsWeb ? logoControl : jsonEncode(logoControl),
      if (logoControlOptions != null)
        'logoControlOptions': logoControlOptions!.toJson(),
      if (mapDataControl != null)
        'mapDataControl': kIsWeb ? mapDataControl : jsonEncode(mapDataControl),
      if (mapDataControlOptions != null)
        'mapDataControlOptions': mapDataControlOptions!.toJson(),
      if (mapTypeControl != null)
        'mapTypeControl': kIsWeb ? mapTypeControl : jsonEncode(mapTypeControl),
      if (mapTypeControlOptions != null)
        'mapTypeControlOptions': mapTypeControlOptions!.toJson(),
      if (mapTypeId != null)
        'mapTypeId': kIsWeb ? mapTypeId!.value : jsonEncode(mapTypeId!.value),
      if (maxBounds != null) 'maxBounds': maxBounds!.toJson(),
      if (maxZoom != null) 'maxZoom': kIsWeb ? maxZoom : jsonEncode(maxZoom),
      if (minZoom != null) 'minZoom': kIsWeb ? minZoom : jsonEncode(minZoom),
      if (padding != null) 'padding': padding!.toJson(),
      if (pinchZoom != null)
        'pinchZoom': kIsWeb ? pinchZoom : jsonEncode(pinchZoom),
      if (resizeOrigin != null)
        'resizeOrigin': kIsWeb
            ? resizeOrigin!.value
            : jsonEncode(resizeOrigin!.value),
      if (scaleControl != null)
        'scaleControl': kIsWeb ? scaleControl : jsonEncode(scaleControl),
      if (scaleControlOptions != null)
        'scaleControlOptions': scaleControlOptions!.toJson(),
      if (scrollWheel != null)
        'scrollWheel': kIsWeb ? scrollWheel : jsonEncode(scrollWheel),
      if (size != null) 'size': size!.toJson(),
      if (overlayZoomEffect != null)
        'overlayZoomEffect': kIsWeb
            ? overlayZoomEffect
            : jsonEncode(overlayZoomEffect),
      if (tileSpare != null)
        'tileSpare': kIsWeb ? tileSpare : jsonEncode(tileSpare),
      if (tileTransition != null)
        'tileTransition': kIsWeb ? tileTransition : jsonEncode(tileTransition),
      if (tileDuration != null)
        'tileDuration': kIsWeb ? tileDuration : jsonEncode(tileDuration),
      if (zoom != null) 'zoom': kIsWeb ? zoom : jsonEncode(zoom),
      if (zoomControl != null)
        'zoomControl': kIsWeb ? zoomControl : jsonEncode(zoomControl),
      if (zoomControlOptions != null)
        'zoomControlOptions': zoomControlOptions!.toJson(),
      if (zoomOrigin != null) 'zoomOrigin': zoomOrigin!.toJson(),
      if (blankTileImage != null)
        'blankTileImage': kIsWeb ? blankTileImage : jsonEncode(blankTileImage),
      if (gl != null) 'gl': kIsWeb ? gl : jsonEncode(gl),
      if (customStyleId != null)
        'customStyleId': kIsWeb ? customStyleId : jsonEncode(customStyleId),
    };
  }
}
