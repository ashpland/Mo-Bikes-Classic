//
//  MapViewController.m
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import "MapViewController.h"
#import "StationManager.h"
#import "DownloadManager.h"
#import "Mo_Bikes-Swift.h"
#import "BikeDamageTableViewController.h"



@import MapKit;

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *compassButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toiletButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fountainButton;
@property (weak, nonatomic) IBOutlet UILabel *legendLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bikesDocksSegmentedControl;

- (IBAction)contactButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)layerButtonPressed:(UIBarButtonItem *)sender;

@property (nonatomic, retain) CLLocation *currentPosition;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) UIColor *disabledButtonColor;
@property (strong, nonatomic) UIColor *normalStationColor;
@property (strong, nonatomic) UIColor *lowStationColor;

@end

@implementation MapViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self updateAPIData];
    [self getLocation];
    [self setupUI];
}

- (void)updateAPIData {
    [DownloadManager downloadJsonAtURL:@"https://vancouver-ca.smoove.pro/api-public/stations"
                        withCompletion:^(NSArray *stationArray)
     {
         [StationManager updateStationsFromArray:stationArray];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.mapView addAnnotations:[StationManager getAllStations]];
         });
         
     }];
}



- (MKAnnotationView * _Nullable)getStationMarkerFor:(id<MKAnnotation> _Nonnull)annotation mapView:(MKMapView * _Nonnull)mapView {
    
    Station *station = (Station *)annotation;
    MKMarkerAnnotationView *newStationMarkerView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"StationMarkerView" forAnnotation:station];
    
    newStationMarkerView.markerTintColor = self.normalStationColor;
    newStationMarkerView.titleVisibility = MKFeatureVisibilityHidden;
    newStationMarkerView.canShowCallout = YES;
    newStationMarkerView.animatesWhenAdded = YES;
    
    bool bikesSelected = self.bikesDocksSegmentedControl.selectedSegmentIndex == 0;
    
    if(bikesSelected){
        newStationMarkerView.glyphImage = [UIImage imageNamed:@"mbike"];
        if (station.available_bikes < 3)
            newStationMarkerView.markerTintColor = self.lowStationColor;
    }
    else /*docksSelected */ {
        newStationMarkerView.glyphImage = [UIImage imageNamed:@"mdock"];
        if (station.available_docks < 3)
            newStationMarkerView.markerTintColor = self.lowStationColor;
    }
    
    if(newStationMarkerView.isSelected) {
        newStationMarkerView.markerTintColor = [UIColor greenColor];
    }
    return newStationMarkerView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[Station class]]) {
        MKMarkerAnnotationView *theMarker = (MKMarkerAnnotationView *)view;
        Station *theStation = (Station *)theMarker.annotation;
        
        bool showBikesMode = self.bikesDocksSegmentedControl.selectedSegmentIndex == 0;
        
        if (showBikesMode) {
            theMarker.glyphText = [NSString stringWithFormat:@"%d", theStation.available_bikes];
        } else {
            theMarker.glyphText = [NSString stringWithFormat:@"%d", theStation.available_docks];
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

        UIColor *supColor = self.view.tintColor;
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

//updates our location after we authorize
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //get currentPosition
    self.currentPosition = self.locationManager.location;
    
    //set region
    //if we are at default Apple coordinate (0,0), then update region
    float lat = self.mapView.region.center.latitude;
    float lon = self.mapView.region.center.longitude;
    
    if (lat == 0 || lon == 0){
        
        MKCoordinateSpan span = MKCoordinateSpanMake(.007f, .007f);
        self.mapView.region = MKCoordinateRegionMake(self.currentPosition.coordinate, span);
    }
}

 
 -(void) getLocation {
     
     //setup location manager if none exists
     if (self.locationManager == nil)
     {
         self.locationManager = [[CLLocationManager alloc] init];
         self.locationManager.desiredAccuracy =
         kCLLocationAccuracyNearestTenMeters;
         self.locationManager.distanceFilter = kCLDistanceFilterNone;
         self.locationManager.delegate = self;
     }
     
     //alert for requesting access
     [self.locationManager requestWhenInUseAuthorization];
     
     [self.locationManager startUpdatingLocation];
     
     //get currentPosition
     self.currentPosition = self.locationManager.location;
     
     //set region
     MKCoordinateSpan span = MKCoordinateSpanMake(.007f, .007f);
     self.mapView.region = MKCoordinateRegionMake(self.currentPosition.coordinate, span);
     
     self.mapView.showsUserLocation = YES;
     self.mapView.showsPointsOfInterest = NO;
 }

- (void)setupUI {
 
    UIImage *image = [[UIImage imageNamed:@"compass"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.compassButton setImage:image forState:UIControlStateNormal];
    
    self.disabledButtonColor = [UIColor lightGrayColor];
    self.normalStationColor  = [UIColor colorWithHue:0.83 saturation:1.0 brightness:0.5 alpha:1.0];
    self.lowStationColor     = [UIColor colorWithHue:0.83 saturation:0.1 brightness:0.8 alpha:1.0];
    
    
    
    
    self.fountainButton.tintColor = self.disabledButtonColor;
    self.toiletButton.tintColor = self.disabledButtonColor;
    
    self.compassButton.layer.cornerRadius = self.compassButton.frame.size.width / 2.0;
    self.compassButton.layer.masksToBounds = NO;
    self.compassButton.layer.shadowOffset = CGSizeMake(0, 2.0);
    self.compassButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.compassButton.layer.shadowOpacity = 0.5;
    self.compassButton.layer.shadowRadius = 1.0;

    
    
    self.legendLabel.layer.masksToBounds = NO;
    self.legendLabel.layer.cornerRadius = 15;
    self.legendLabel.layer.shadowOffset = CGSizeMake(0, 2.0);
    self.legendLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.legendLabel.layer.shadowOpacity = 0.5;
    self.legendLabel.layer.shadowRadius = 1.0;
    
    [self displayBikeways];
    
    [self.mapView registerClass:[MKMarkerAnnotationView class] forAnnotationViewWithReuseIdentifier:@"SupplementaryAnnotationMarker"];
    [self.mapView registerClass:[MKMarkerAnnotationView class] forAnnotationViewWithReuseIdentifier:@"StationMarkerView"];
    
    [self.mapView addAnnotations:[StationManager getAllStations]];
}


- (IBAction)compassButtonPressed:(UIButton *)sender {
    
    //move back to currentPosition region
    MKCoordinateSpan span = MKCoordinateSpanMake(.007f, .007f);
    MKCoordinateRegion newRegion = MKCoordinateRegionMake(self.currentPosition.coordinate, span);
    [self.mapView setRegion:newRegion animated:YES];
}

- (IBAction)bikesDocksSegControlChanged:(UISegmentedControl *)sender {
    
    NSArray<Station *> *stationsArray = [StationManager getAllStations];
    
    if (sender.selectedSegmentIndex==0)
    {
        //show bikes
        [self.mapView removeAnnotations:stationsArray];
        [self.mapView addAnnotations:stationsArray];
    }
    else if (sender.selectedSegmentIndex ==1)
    {
        //show docks
        [self.mapView removeAnnotations:stationsArray];
        [self.mapView addAnnotations:stationsArray];
    }
}



- (IBAction)contactButtonPressed:(UIBarButtonItem *)sender {
    UIAlertController *contactAlert = [UIAlertController alertControllerWithTitle:@"Wow!" message:@"Something wrong brah?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *callAction = [UIAlertAction actionWithTitle:@"Call Mobi" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //call mobi
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString: @"tel:7786551800"] options:@{} completionHandler:nil];
        
    }];
    UIAlertAction *reportDamageAction = [UIAlertAction actionWithTitle:@"Report Damage" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //ask for bikes or station damage
        UIAlertController *reportDamageAlert = [UIAlertController alertControllerWithTitle:@"Oh no!" message:@"Whats damaged?" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *reportBikeDamageAction = [UIAlertAction actionWithTitle:@"Bike" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          
            [self performSegueWithIdentifier:@"showContactSBSegue" sender:self];
            
            
        }];
        UIAlertAction *reportStationDamageAction = [UIAlertAction actionWithTitle:@"Station" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self performSegueWithIdentifier:@"showStationDamageSBSegue" sender:self];
            
        }];
        UIAlertAction *cancelReportDamageAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [reportDamageAlert dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"Cacnelled");
        }];
        
        [reportDamageAlert addAction:reportBikeDamageAction];
        [reportDamageAlert addAction:reportStationDamageAction];
        [reportDamageAlert addAction:cancelReportDamageAction];
        
        [self presentViewController:reportDamageAlert animated:YES completion:nil];
        
        
    }];

    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [contactAlert dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"Cacnelled");
    }];
    
    [contactAlert addAction:callAction];
    [contactAlert addAction:reportDamageAction];
    [contactAlert addAction:cancelAction];
    
    [self presentViewController:contactAlert animated:YES completion:nil];
    
   // [self performSelector:@selector(dismissAlert:) withObject:contactAlert afterDelay:1.0];
}

-(void)dismissAlert:(UIAlertController *)alert
{
    [alert dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)layerButtonPressed:(UIBarButtonItem *)sender {
    
    if (sender.tintColor) {
        [self.mapView addAnnotations:[self getAnnotationArray:sender]];
        sender.tintColor = nil;
        
        UIBarButtonItem *notThisButton = [self notThisButton:sender];
        if (!notThisButton.tintColor) {
            [self.mapView removeAnnotations:[self getAnnotationArray:notThisButton]];
            notThisButton.tintColor = self.disabledButtonColor;
        }
    }
    
    else {
        [self.mapView removeAnnotations:[self getAnnotationArray:sender]];
        sender.tintColor = self.disabledButtonColor;
    }
}

- (UIBarButtonItem *)notThisButton:(UIBarButtonItem *)thisButton {
    if ([thisButton isEqual:self.toiletButton]) {
        return self.fountainButton;
    } else if ([thisButton isEqual:self.fountainButton]) {
        return self.toiletButton;
    }
    return nil;
}

- (NSArray *)getAnnotationArray:(UIBarButtonItem *)thisButton {
    if ([thisButton isEqual: self.toiletButton]) {
        return [SupplementaryLayers sharedInstance].washrooms;
    } else if ([thisButton isEqual:self.fountainButton]) {
        return [SupplementaryLayers sharedInstance].fountains;
    }
    return nil;
}

- (void)displayBikeways {
    NSArray<Bikeway *> *bikeways = [SupplementaryLayers sharedInstance].bikeways;
    for (Bikeway *currentBikeway in bikeways) {
        [self.mapView addOverlays:[currentBikeway makeMKPolylines] level:MKOverlayLevelAboveRoads];
    }
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *bikewayRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    
    BikewayPolyline *currentBikeway = (BikewayPolyline *)overlay;
    bikewayRenderer.strokeColor = self.view.tintColor;
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


- (IBAction)unwindFromEmail:(UIStoryboardSegue*)segue{
    
}






@end
