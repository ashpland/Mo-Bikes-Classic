//
//  StationDamageTableViewController.m
//  Mo'Bikes
//
//  Created by Sanjay Shah on 2017-11-02.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import "StationDamageTableViewController.h"
#import "Mo'Bikes-Bridging-Header.h"
#import "Mo_Bikes-Swift.h"

@interface StationDamageTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property NSArray<NSString*> *damageTypesArray;

@property NSMutableArray<NSString*> *tickedDamagesArray;

@end

@implementation StationDamageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.tableView.allowsMultipleSelection = true;
    //self.tableView.editing = NO;
    self.damageTypesArray = [[NSArray alloc] initWithObjects:@"Dock", @"Lock", @"What ", nil];
    self.tickedDamagesArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stationDamageCellID" forIndexPath:indexPath];
    
    cell.textLabel.text = self.damageTypesArray[indexPath.row];
    
    return  cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.damageTypesArray.count;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    if ([segue.identifier isEqualToString: @"showEmailSegue"]){
        
        Email *newEmail = [segue destinationViewController];
        [newEmail sendEmailWithMyName:@"Sanjay Shah" qrCode:@"No QRCode on station" damageArray:self.tickedDamagesArray];
    }
}

- (IBAction)showEmail:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"showEmailSegue" sender:sender];
}


@end
