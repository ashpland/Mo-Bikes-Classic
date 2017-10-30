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

//@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *compassButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bikesDocksSegmentedControl;

@property (nonatomic, retain) CLLocation *currentPosition;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *layersButton;




@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self getLocation];
    
    
    
    MKCoordinateSpan span = MKCoordinateSpanMake(.001f, .001f);
    self.myMapView.region = MKCoordinateRegionMake(self.currentPosition.coordinate, span);
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

  
     
 
 -(void) getLocation {
     
     if (self.locationManager == nil)
         
     {
         self.locationManager = [[CLLocationManager alloc] init];
         self.locationManager.desiredAccuracy =
         kCLLocationAccuracyNearestTenMeters;
         self.locationManager.distanceFilter = kCLDistanceFilterNone;
         self.locationManager.delegate = self;
     }
     [self.locationManager startUpdatingLocation];
     
     self.currentPosition = self.locationManager.location;
     NSString *latitude = [[NSNumber numberWithDouble:self.currentPosition.coordinate.latitude] stringValue];
     NSString *longitude = [[NSNumber numberWithDouble:self.currentPosition.coordinate.longitude] stringValue];
     
     NSLog(@"Lat: %@", latitude);
     NSLog(@"Long: %@", longitude);
     
 }




- (IBAction)compassButtonPressed:(UIButton *)sender {
}

- (IBAction)bikesDocksSegControlChanged:(UISegmentedControl *)sender {
}
@end
