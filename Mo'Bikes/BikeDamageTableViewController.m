//
//  BikeDamageTableViewController.m
//  Mo'Bikes
//
//  Created by Sanjay Shah on 2017-11-01.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import "BikeDamageTableViewController.h"
#import "Mo'Bikes-Bridging-Header.h"
#import "Mo_Bikes-Swift.h"



@interface BikeDamageTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray<NSString*> *damageTypesArray;
@property NSMutableArray<NSString*> *tickedDamagesArray;

@end

@implementation BikeDamageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.damageTypesArray = [[NSArray alloc] initWithObjects:@"Front Tire", @"Back Tire", @"Gears", @"Seat", @"Brakes" , nil];
    self.tickedDamagesArray = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)showQRVC:(UIButton *)sender {
    [self performSegueWithIdentifier:@"showQRVC" sender:sender];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bikeDamageCellID" forIndexPath:indexPath];
    
    cell.textLabel.text = self.damageTypesArray[indexPath.row];
    
    return  cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.damageTypesArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //shows select-deselect animation
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark ){
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.tickedDamagesArray addObject:(self.damageTypesArray[indexPath.row])];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: @"showQRVC"]){
        
        QRViewController *qrvc =  (QRViewController*)[segue destinationViewController];
        qrvc.damageArray= self.tickedDamagesArray;
    }
}


@end
