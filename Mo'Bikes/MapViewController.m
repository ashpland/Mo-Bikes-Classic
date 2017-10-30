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

@property (weak, nonatomic) IBOutlet UIBarButtonItem *layersButton;




@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self getLocation];
    
    
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


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentPosition = [locations objectAtIndex:0];
    [self.locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.currentPosition completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             NSLog(@"\nCurrent Location Detected\n");

         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
         }
     }];
}




- (IBAction)compassButtonPressed:(UIButton *)sender {
}

- (IBAction)bikesDocksSegControlChanged:(UISegmentedControl *)sender {
}
@end
