//
//  MapView.m
//  mapmapmap
//
//  Created by 황수경 on 2020/06/03.
//

#import <Foundation/Foundation.h>
#import <DaumMap/MTMapView.h>
#import <DaumMap/MTMapCircle.h>
#import <DaumMap/MTMapPolyline.h>

// import RCTEventDispatcher
#if __has_include(<React/RCTEventDispatcher.h>)
#import <React/RCTEventDispatcher.h>
#elif __has_include("RCTEventDispatcher.h")
#import "RCTEventDispatcher.h"
#else
#import "React/RCTEventDispatcher.h" // Required when used as a Pod in a Swift project
#endif

#import "MapView.h"
#import "React/RCTLog.h"

@implementation MapView : UIView {
    MTMapView *_mapView;
}

-(instancetype) initWithFrame:(CGRect)frame {
  NSString* id = [[NSBundle mainBundle] bundleIdentifier];
  RCTLog(@"BUNDLEID - %@", id);

  self = [super initWithFrame:frame];
//    if ((self = [super init])) {
        _mapView = [[MTMapView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,
                                                               self.bounds.origin.y,
                                                               self.bounds.size.width,
                                                               self.bounds.size.height)];
//      _mapView = [[MTMapView alloc] initWithFrame:frame];
      _mapView.delegate = self;
      _mapView.baseMapType = MTMapTypeStandard;

        _latdouble  = 36.143099;
        _londouble  = 128.392905;
        _zoomLevel  = 2;
        _tagIDX     = 0;

        _isTracking = false;
        _isCompass  = false;
//    }

    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    _mapView.frame = self.bounds;
    [self addSubview:_mapView];
}

- (void) setInitialRegion:(NSDictionary *)region {
    if ([region valueForKey:@"latitude"] != [NSNull null]) {
        _latdouble = [[region valueForKey:@"latitude"] floatValue];
    }
    if ([region valueForKey:@"longitude"] != [NSNull null]) {
        _londouble = [[region valueForKey:@"longitude"] floatValue];
    }
    if ([region valueForKey:@"zoomLevel"] != [NSNull null]) {
        _zoomLevel = [[region valueForKey:@"zoomLevel"] intValue];
    }
}

- (void) setMarkers:(NSArray *)markers {
    NSArray *markerList = [NSArray arrayWithObjects: NULL];

    for (int i = 0; i < [markers count]; i++) {
        NSDictionary *dict = [markers objectAtIndex:i];
        NSString *itemName = [dict valueForKey:@"title"];
        NSString *pinColor = [[dict valueForKey:@"pinColor"] lowercaseString];
        NSString *selectPinColor = [[dict valueForKey:@"pinColorSelect"] lowercaseString];
        MTMapPOIItemMarkerType markerType = MTMapPOIItemMarkerTypeBluePin;
        if ([pinColor isEqualToString:@"red"]) {
            markerType = MTMapPOIItemMarkerTypeRedPin;
        } else if ([pinColor isEqualToString:@"yellow"]) {
            markerType = MTMapPOIItemMarkerTypeYellowPin;
        } else if ([pinColor isEqualToString:@"blue"]) {
            markerType = MTMapPOIItemMarkerTypeBluePin;
        } else if ([pinColor isEqualToString:@"image"]) {
            markerType = MTMapPOIItemMarkerTypeCustomImage;
        }

        MTMapPOIItemMarkerSelectedType sMarkerType = MTMapPOIItemMarkerSelectedTypeRedPin;
        if ([selectPinColor isEqualToString:@"red"]) {
            sMarkerType = MTMapPOIItemMarkerSelectedTypeRedPin;
        } else if ([selectPinColor isEqualToString:@"yellow"]) {
            sMarkerType = MTMapPOIItemMarkerSelectedTypeYellowPin;
        } else if ([selectPinColor isEqualToString:@"blue"]) {
            sMarkerType = MTMapPOIItemMarkerSelectedTypeBluePin;
        } else if ([pinColor isEqualToString:@"image"]) {
            sMarkerType = MTMapPOIItemMarkerSelectedTypeCustomImage;
        } else if ([selectPinColor isEqualToString:@"none"]) {
            sMarkerType = MTMapPOIItemMarkerSelectedTypeNone;
        }

        MTMapPOIItem* markerItem = [MTMapPOIItem poiItem];
        if (itemName != NULL) markerItem.itemName = itemName;
        float latdouble = [[dict valueForKey:@"latitude"] floatValue];
        float londouble = [[dict valueForKey:@"longitude"] floatValue];

        markerItem.mapPoint = [MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(latdouble, londouble)];
        markerItem.markerType = markerType;
        if (markerType == MTMapPOIItemMarkerTypeCustomImage) {
            markerItem.customImageName = [dict valueForKey:@"markerImage"];
        }
        markerItem.markerSelectedType = sMarkerType;
        if (sMarkerType == MTMapPOIItemMarkerSelectedTypeCustomImage) {
            markerItem.customSelectedImageName = [dict valueForKey:@"markerImageSelect"];
        }
        markerItem.showAnimationType = MTMapPOIItemShowAnimationTypeSpringFromGround; // Item이 화면에 추가될때 애니매이션
        bool draggable = [dict valueForKey:@"draggable"];
        markerItem.draggable = draggable;
        markerItem.tag = i;
        markerItem.showDisclosureButtonOnCalloutBalloon = NO;

        markerList = [markerList arrayByAddingObject: markerItem];
    }

    [_mapView addPOIItems:markerList];
}

- (void) setMapType:(NSString *)mapType {
    mapType = [mapType lowercaseString];
    if ([mapType isEqualToString:@"standard"]) {
        _mapView.baseMapType = MTMapTypeStandard;
    } else if ([mapType isEqualToString:@"satellite"]) {
        _mapView.baseMapType = MTMapTypeSatellite;
    } else if ([mapType isEqualToString:@"hybrid"]) {
        _mapView.baseMapType = MTMapTypeHybrid;
    } else {
        _mapView.baseMapType = MTMapTypeStandard;
    }
}

- (void) setRegion:(NSDictionary *)region {
    if ([region valueForKey:@"latitude"] != [NSNull null] && [region valueForKey:@"longitude"] != [NSNull null]) {
        float latdouble = [[region valueForKey:@"latitude"] floatValue];
        float londouble = [[region valueForKey:@"longitude"] floatValue];

        [_mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(latdouble, londouble)] animated:YES];
    }
}

- (void) setIsCurrentMarker: (BOOL)isCurrentMarker {
    [_mapView setShowCurrentLocationMarker:isCurrentMarker];
}

- (void) setIsTracking:(BOOL)isTracking {
    _isTracking = isTracking;
    [self setMapTracking];
}

- (void) setIsCompass:(BOOL)isCompass {
    _isCompass = isCompass;
    [self setMapTracking];
}

- (void) setPolyLines:(NSDictionary *) polyLines {
    [_mapView removeAllPolylines];

    if ([polyLines valueForKey:@"points"] != [NSNull null]) {
        MTMapPolyline *polyline1 = [MTMapPolyline polyLine];

        NSString *polyLineColor = [[polyLines valueForKey:@"color"] lowercaseString];
        NSArray  *polyLineArray = [polyLines valueForKey:@"points"];
        NSInteger tagIdx    = 0;
        if ([polyLines valueForKey:@"tag"] != [NSNull null] && [polyLines valueForKey:@"tag"] > 0) {
            tagIdx = [[polyLines valueForKey:@"tag"] intValue];
        } else {
            tagIdx = _tagIDX++;
        }
        polyline1.tag= tagIdx;

        for (int i = 0; i < [polyLineArray count]; i++) {
            NSDictionary *dict = [polyLineArray objectAtIndex:i];
            float latdouble     = [[dict valueForKey:@"latitude"] floatValue];
            float londouble     = [[dict valueForKey:@"longitude"] floatValue];
            [polyline1 addPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(latdouble, londouble)]];
        }

        UIColor *color = [self getColor:polyLineColor];

        polyline1.polylineColor = color;
        [_mapView addPolyline:polyline1];
    }
}

- (void) setCircles: (NSArray *) circles {
    [_mapView removeAllCircles];

    for (int i = 0; i < [circles count]; i++) {
        NSDictionary *dict = [circles objectAtIndex:i];
        float latdouble = [[dict valueForKey:@"latitude"] floatValue];
        float londouble = [[dict valueForKey:@"longitude"] floatValue];
        NSString *lineColorStr = [[dict valueForKey:@"lineColor"] lowercaseString];
        NSString *fillColorStr = [[dict valueForKey:@"fillColor"] lowercaseString];
        NSInteger radius    = 50;
        NSInteger lineWidth = 10;
        NSInteger tagIdx    = 0;

        if ([dict valueForKey:@"lineWidth"] != [NSNull null] && [dict valueForKey:@"lineWidth"] > 0) {
            lineWidth = [[dict valueForKey:@"lineWidth"] intValue];
        }
        if ([dict valueForKey:@"radius"] != [NSNull null] && [dict valueForKey:@"radius"] > 0) {
            radius = [[dict valueForKey:@"radius"] intValue];
        }
        if ([dict valueForKey:@"tag"] != [NSNull null] && [dict valueForKey:@"tag"] > 0) {
            tagIdx = [[dict valueForKey:@"tag"] intValue];
        } else {
            tagIdx = _tagIDX++;
        }

        UIColor *lineColor = [self getColor:lineColorStr];
        UIColor *fillColor = [self getColor:fillColorStr];

        MTMapCircle *circle1 = [MTMapCircle circle];
        circle1.circleCenterPoint = [MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(latdouble, londouble)];
        circle1.circleLineColor = lineColor;
        circle1.circleFillColor = fillColor;
        circle1.circleLineWidth = lineWidth;
        circle1.circleRadius    = radius;
        circle1.tag             = tagIdx;

        [_mapView addCircle:circle1];
    }
}

- (UIColor *) getColor: (NSString *) colorStr {
    if ([colorStr isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([colorStr isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if ([colorStr isEqualToString:@"yellow"]) {
        return [UIColor yellowColor];
    } else if ([colorStr isEqualToString:@"black"]) {
        return [UIColor blackColor];
    } else if ([colorStr isEqualToString:@"green"]) {
        return [UIColor greenColor];
    } else if ([colorStr isEqualToString:@"green"]) {
        return [UIColor greenColor];
    } else if ([colorStr isEqualToString:@"white"]) {
        return [UIColor whiteColor];
    } else {
        return [UIColor whiteColor];
    }
}

- (MTMapCurrentLocationTrackingMode) getTrackingMode {
    // 트래킹 X, 나침반 X, 지도이동 X : MTMapCurrentLocationTrackingOff
    // 트래킹 O, 나침반 X, 지도이동 O : MTMapCurrentLocationTrackingOnWithoutHeading
    // 트래킹 O, 나침반 O, 지도이동 O : MTMapCurrentLocationTrackingOnWithHeading
    // 트래킹 O, 나침반 X, 지도이동 X : MTMapCurrentLocationTrackingOnWithoutHeadingWithoutMapMoving
    // 트래킹 O, 나침반 O, 지도이동 X : MTMapCurrentLocationTrackingOnWithHeadingWithoutMapMoving

    return [_mapView currentLocationTrackingMode];
}

- (void) setMapTracking {
    MTMapCurrentLocationTrackingMode trackingModeValue = MTMapCurrentLocationTrackingOff;
    if (_isTracking && _isCompass) {
        trackingModeValue = MTMapCurrentLocationTrackingOnWithHeading;
    } else if (_isTracking && !_isCompass) {
        trackingModeValue = MTMapCurrentLocationTrackingOnWithoutHeading;
    } else {
        trackingModeValue = MTMapCurrentLocationTrackingOff;
    }

    [_mapView setCurrentLocationTrackingMode:trackingModeValue];
}

/****************************************************************/
// 이벤트 처리 시작
/****************************************************************/
// APP KEY 인증 서버에 인증한 결과를 통보받을 수 있다.
- (void)mapView:(MTMapView*)mapView openAPIKeyAuthenticationResultCode:(int)resultCode resultMessage:(NSString*)resultMessage {
    [_mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(_latdouble, _londouble)] zoomLevel:(int)_zoomLevel animated:YES];
}

// 단말의 현위치 좌표값
- (void)mapView:(MTMapView*)mapView updateCurrentLocation:(MTMapPoint*)location withAccuracy:(MTMapLocationAccuracy)accuracy {
    id event = @{
                 @"action": @"updateCurrentLocation",
                 @"accuracyInMeters": @(accuracy),
                 @"coordinate": @{
                         @"latitude": @([location mapPointGeo].latitude),
                         @"longitude": @([location mapPointGeo].longitude)
                         }
                 };
    if (self.onUpdateCurrentLocation) self.onUpdateCurrentLocation(event);
}

- (void)mapView:(MTMapView*)mapView updateDeviceHeading:(MTMapRotationAngle)headingAngle {
    id event = @{
                 @"action": @"currentHeading",
                 @"headingAngle": @(headingAngle),
                 };
    if (self.onUpdateCurrentHeading) self.onUpdateCurrentHeading(event);
}

// 단말 사용자가 POI Item을 선택한 경우
- (BOOL)mapView:(MTMapView*)mapView selectedPOIItem:(MTMapPOIItem*)poiItem {
    id event = @{
                 @"action": @"markerSelect",
                 @"id": @(poiItem.tag),
                 @"coordinate": @{
                         @"latitude": @(poiItem.mapPoint.mapPointGeo.latitude),
                         @"longitude": @(poiItem.mapPoint.mapPointGeo.longitude)
                         }
                 };
    if (self.onMarkerSelect) self.onMarkerSelect(event);

    return YES;
}

// 단말 사용자가 POI Item 아이콘(마커) 위에 나타난 말풍선(Callout Balloon)을 터치한 경우
- (void)mapView:(MTMapView *)mapView touchedCalloutBalloonOfPOIItem:(MTMapPOIItem *)poiItem {
    id event = @{
                 @"action": @"markerPress",
                 @"id": @(poiItem.tag),
                 @"coordinate": @{
                         @"latitude": @(poiItem.mapPoint.mapPointGeo.latitude),
                         @"longitude": @(poiItem.mapPoint.mapPointGeo.longitude)
                         }
                 };
    if (self.onMarkerPress) self.onMarkerPress(event);
}

// 단말 사용자가 길게 누른후(long press) 끌어서(dragging) 위치 이동 가능한 POI Item의 위치를 이동시킨 경우
- (void)mapView:(MTMapView*)mapView draggablePOIItem:(MTMapPOIItem*)poiItem movedToNewMapPoint:(MTMapPoint*)newMapPoint {
    id event = @{
                 @"action": @"markerMoved",
                 @"id": @(poiItem.tag),
                 @"coordinate": @{
                         @"latitude": @(newMapPoint.mapPointGeo.latitude),
                         @"longitude": @(newMapPoint.mapPointGeo.longitude)
                         }
                 };
    if (self.onMarkerMoved) self.onMarkerMoved(event);
}

// 지도 중심 좌표가 이동한 경우
- (void)mapView:(MTMapView*)mapView centerPointMovedTo:(MTMapPoint*)mapCenterPoint {
    id event = @{
                 @"action": @"regionChange",
                 @"coordinate": @{
                         @"latitude": @(mapCenterPoint.mapPointGeo.latitude),
                         @"longitude": @(mapCenterPoint.mapPointGeo.longitude)
                         }
                 };
    if (self.onRegionChange) self.onRegionChange(event);
}
@end
