//
//  MapViewDelegate.m
//  Mo'Bikes
//
//  Created by Andrew on 2017-11-02.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import "MapViewDelegate.h"
#import "Station+CoreDataClass.h"
#import "Mo_Bikes-Swift.h"


@interface MapViewDelegate()

@property (strong, nonatomic) UIColor *normalStationColor;
@property (strong, nonatomic) UIColor *lowStationColor;

@end


@implementation MapViewDelegate


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.normalStationColor  = [UIColor colorWithHue:0.83 saturation:1.0 brightness:0.5 alpha:1.0];
        self.lowStationColor     = [UIColor colorWithHue:0.83 saturation:0.1 brightness:0.8 alpha:1.0];
    }
    return self;
}


- (MKAnnotationView * _Nullable)getStationMarkerFor:(id<MKAnnotation> _Nonnull)annotation mapView:(MKMapView * _Nonnull)mapView {
    
    Station *station = (Station *)annotation;
    MKMarkerAnnotationView *newStationMarkerView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"StationMarkerView" forAnnotation:station];
    
    newStationMarkerView.markerTintColor = self.normalStationColor;
    newStationMarkerView.titleVisibility = MKFeatureVisibilityHidden;
    newStationMarkerView.canShowCallout = YES;
    newStationMarkerView.animatesWhenAdded = YES;
    
    bool bikesSelected = self.bikesDocksSegmentedControl.selectedSegmentIndex == 0;
    bool haveActualData = !(station.available_bikes == 0 && station.available_docks == 0);
    
    if(bikesSelected){
        newStationMarkerView.glyphImage = [UIImage imageNamed:@"mbike"];
        if (station.available_bikes < 3 && haveActualData)
            newStationMarkerView.markerTintColor = self.lowStationColor;
    }
    else /*docksSelected */ {
        newStationMarkerView.glyphImage = [UIImage imageNamed:@"mdock"];
        if (station.available_docks < 3 && haveActualData)
            newStationMarkerView.markerTintColor = self.lowStationColor;
    }
    
    return newStationMarkerView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[Station class]]) {
        MKMarkerAnnotationView *theMarker = (MKMarkerAnnotationView *)view;
        Station *theStation = (Station *)theMarker.annotation;
        
        bool showBikesMode = self.bikesDocksSegmentedControl.selectedSegmentIndex == 0;
        
        if (showBikesMode) {
            theMarker.glyphText = theStation.available_bikes_string;
        } else {
            theMarker.glyphText = theStation.available_docks_string;
        }
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[Station class]]) {
        MKMarkerAnnotationView *theMarker = (MKMarkerAnnotationView *)view;
        theMarker.glyphText = nil;
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[SupplementaryAnnotation class]]) {
        
        SupplementaryAnnotation *curAnnotation = (SupplementaryAnnotation *)annotation;
        
        UIColor *supColor = [UIColor colorWithHue:0.59 saturation:1.0 brightness:1.0 alpha:1.0];
        UIImage *icon;
        
        if (curAnnotation.layerType == SupplementaryLayerTypeWashroom)
            icon = [UIImage imageNamed:@"toilet"];
        else if (curAnnotation.layerType == SupplementaryLayerTypeFountain)
            icon = [UIImage imageNamed:@"fountain"];
        
        MKMarkerAnnotationView *newMarkerView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"SupplementaryAnnotationMarker" forAnnotation:annotation];
        
        newMarkerView.markerTintColor = supColor;
        newMarkerView.glyphImage = icon;
        newMarkerView.enabled = NO;
        newMarkerView.animatesWhenAdded = YES;
        
        return newMarkerView;
    }
    
    if ([annotation isKindOfClass:[Station class]])
    {
        return [self getStationMarkerFor:annotation mapView:mapView];
    }
    else return  nil;
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    //directions
    /*
    if([overlay.title isEqualToString:@"Direction"]){
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor greenColor]];
        [renderer setLineWidth:5.0];
        return renderer;
    }
    */
    
    MKPolylineRenderer *bikewayRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    
    
    BikewayPolyline *currentBikeway = (BikewayPolyline *)overlay;
    bikewayRenderer.strokeColor = [UIColor colorWithHue:0.59 saturation:1.0 brightness:1.0 alpha:1.0];
    bikewayRenderer.lineWidth = 3.0;
    
    
    switch (currentBikeway.bikewayType) {
        
        case BikewayTypeLocal:
            break;
        case BikewayTypeShared:
            return nil;
            break;
        case BikewayTypePainted:
            bikewayRenderer.lineDashPattern = @[@5, @5];
            break;
        case BikewayTypeProtected:
            break;
    }
    
    
    return bikewayRenderer;
}


@end
