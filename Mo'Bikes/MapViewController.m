//
//  MapViewController.m
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import "MapViewController.h"
//#import "LocationManager.h"

@import MapKit;

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *compassButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bikesDocksSegmentedControl;

@property (nonatomic, retain) CLLocation *currentPosition;

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *layersButton;



@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getLocation];

    [self setupUI];

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
     NSString *latitude = [[NSNumber numberWithDouble:self.currentPosition.coordinate.latitude] stringValue];
     NSString *longitude = [[NSNumber numberWithDouble:self.currentPosition.coordinate.longitude] stringValue];
     
     NSLog(@"Lat: %@", latitude);
     NSLog(@"Long: %@", longitude);
     
     //set region
     MKCoordinateSpan span = MKCoordinateSpanMake(.007f, .007f);
     self.mapView.region = MKCoordinateRegionMake(self.currentPosition.coordinate, span);
     
     self.mapView.showsUserLocation = YES;
     self.mapView.showsPointsOfInterest = NO;
 }

- (void)setupUI {
    self.compassButton.transform = CGAffineTransformMakeRotation(M_PI / -1.5);
}





- (IBAction)compassButtonPressed:(UIButton *)sender {
    
    //move back to currentPosition region
    MKCoordinateSpan span = MKCoordinateSpanMake(.007f, .007f);
    MKCoordinateRegion newRegion = MKCoordinateRegionMake(self.currentPosition.coordinate, span);
    [self.mapView setRegion:newRegion animated:YES];
}

- (IBAction)bikesDocksSegControlChanged:(UISegmentedControl *)sender {
}
@end
