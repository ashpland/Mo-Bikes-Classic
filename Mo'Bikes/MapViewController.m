//
//  MapViewController.m
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import "MapViewController.h"
@import MapKit;

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *compassButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bikesDocksSegmentedControl;


- (IBAction)compassButtonPressed:(UIButton *)sender;

- (IBAction)bikesDocksSegControlChanged:(UISegmentedControl *)sender;



@property (weak, nonatomic) IBOutlet UIBarButtonItem *layersButton;




@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}





- (IBAction)compassButtonPressed:(UIButton *)sender {
}

- (IBAction)bikesDocksSegControlChanged:(UISegmentedControl *)sender {
}
@end
