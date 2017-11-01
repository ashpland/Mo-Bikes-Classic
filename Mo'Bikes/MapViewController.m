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
#import "StationAnnotation.h"

@import MapKit;

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *compassButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bikesDocksSegmentedControl;

@property (nonatomic, retain) CLLocation *currentPosition;

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *layersButton;

@property (strong, nonatomic) NSArray<Station*> *stationsArray;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    
    //Test download of API data. It's just logged out currently.
    [DownloadManager downloadJsonAtURL:@"https://vancouver-ca.smoove.pro/api-public/stations"
                        withCompletion:^(NSArray *stationArray)
     {
         
         [StationManager updateStationsFromArray:stationArray];
         
         self.stationsArray = [StationManager getAllStations];
         [self.mapView addAnnotations:self.stationsArray];
         
     }];
    
    
    
    [self getLocation];

    [self setupUI];
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // If its a station, use dynamic markers
    if ([annotation isKindOfClass:[Station class]])
    {
        // Try to dequeue an existing pin view first.
        StationAnnotation *pinView = (StationAnnotation*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        Station *station = (Station *)annotation;
        UIImage * tempImage;
        
        if(pinView == nil){
            pinView = [[StationAnnotation alloc] initWithAnnotation:station reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            
            //dynamism -  0>3, 3>8, 8+
            if((station.available_bikes < 3) && (station.available_bikes >= 0))
            {
                tempImage = [UIImage imageNamed:@"stationLow"];
            }
            else if ((station.available_bikes < 8) && (station.available_bikes >= 3))
            {
                tempImage = [UIImage imageNamed:@"stationMedium"];
            }
            else if (station.available_bikes >=8)
            {
                tempImage = [UIImage imageNamed:@"stationHigh"];
            }
            else
            {
                tempImage = [UIImage imageNamed:@"station"];
            }
            
            //resize the image
            CGRect resizeRect;
            resizeRect.size.height = 40;
            resizeRect.size.width = 40;
            resizeRect.origin = (CGPoint){0.0f, 0.0f};
            UIGraphicsBeginImageContext(resizeRect.size);
            [tempImage drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            pinView.image = resizedImage;
            
        }
        else {
            pinView.annotation = annotation;
        }
        return  pinView;
    }
    else return  nil;
}

//updates our location after we authorize
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //get currentPosition
    self.currentPosition = self.locationManager.location;
    //set region
    
    if(self.mapView.region.center.latitude == 0) {
        
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
