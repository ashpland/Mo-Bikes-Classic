//
//  MapViewController.m
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import "MapViewController.h"
//#import "LocationManager.h"
#import "StationManager.h"
#import "DownloadManager.h"

@import MapKit;

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *compassButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bikesDocksSegmentedControl;

@property (nonatomic, retain) CLLocation *currentPosition;

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *layersButton;

@property (strong, nonatomic) NSArray<Station*> *stationsArray;
@property NSMutableArray *stationsAnnotationsArray;


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





//-(void) showMarkers {
    
   // self.stationsArray = [[NSMutableArray alloc] init];
    
    //self.myMapView.delegate = self;
   // self.stationsAnnotationsArray = [[NSMutableArray alloc] init];
    
    //add annotation for each cat
//    for (Station *station in self.stationsArray){
//
//        //MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];[myAnnotation setTitle:[NSString stringWithFormat:@"%@", station.name]];
//
//        //        MKAnnotationView *myCatAnnotation = [[MKAnnotationView alloc] init];
//        //        myCatAnnotation.image = cat.catImage;
//        //        myCatAnnotation.annotation = myAnnotation;
//
//        //[self.stationsAnnotationsArray addObject:myAnnotation];
//    }
    
    //add all the annotations
    
    
//}





- (IBAction)compassButtonPressed:(UIButton *)sender {
    
    //move back to currentPosition region
    MKCoordinateSpan span = MKCoordinateSpanMake(.007f, .007f);
    MKCoordinateRegion newRegion = MKCoordinateRegionMake(self.currentPosition.coordinate, span);
    [self.mapView setRegion:newRegion animated:YES];
}

- (IBAction)bikesDocksSegControlChanged:(UISegmentedControl *)sender {
}
@end
