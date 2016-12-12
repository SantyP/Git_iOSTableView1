//
//  ViewController.m
//  TableViewDemo
//
//  Created by Training on 02/12/16.
//  Copyright © 2016 Training. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableDictionary *thumbDict;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.data = [[NSMutableArray alloc] init];
    self.tableView.delegate= self;
    self.tableView.dataSource= self;
    self.tableView.estimatedRowHeight= 44.0;
    self.thumbDict = [[NSMutableDictionary alloc] init];
    //
    [self loadDataFromNetwork:@"https://dl.dropboxusercontent.com/u/746330/facts.json"];
    
}

- (void) loadDataFromNetwork : (NSString *)url {
    
    // Dispatch network call into a Queue : GCD
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSError *error;
        NSString *jsonStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSISOLatin1StringEncoding error:&error];
        
        NSData *responseData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        // set data
        self.data = responseDict[@"rows"];
        // Main Thread
        dispatch_async(dispatch_get_main_queue(), ^{
            // Refresh Table View
            [self.tableView reloadData];
        });
    });
}

#pragma mark - UITableViewDelegate Methods & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"Cell";
    
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil] firstObject];
    }
    
    // Set title and description
    if (![self.data[indexPath.row][@"title"] isKindOfClass:[NSNull class]]) {
         cell.titleLbl.text = self.data[indexPath.row][@"title"];
        if (![self.data[indexPath.row][@"description"] isKindOfClass:[NSNull class]]) {
            cell.descLbl.text = self.data[indexPath.row][@"description"];
        }
    }
    // Set the image
    NSString *indexKey= [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    if ([self.thumbDict objectForKey:indexKey]) {
        [cell.imageView setImage:self.thumbDict[indexKey]];
    } else {
        [cell.imageView setImage:[UIImage imageNamed:@"placeholder"]];
        if (![self.data[indexPath.row][@"imageHref"] isKindOfClass:[NSNull class]]) {
            [self loadImagefromNetwork:self.data[indexPath.row][@"imageHref"] withRowIndex:indexKey];
        }
    }
    return cell;
}


- (void) loadImagefromNetwork : (NSString *)imageUrl withRowIndex : (NSString *)rowIndex{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // Load image in the background
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            UIImage *thumbImage = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (thumbImage) {
                    [self.thumbDict setObject:thumbImage forKey:rowIndex];
                    [self.tableView reloadData];
                } else {
                    [self.thumbDict setObject:[UIImage imageNamed:@"placeholder"] forKey:rowIndex];
                }
            });
        });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
