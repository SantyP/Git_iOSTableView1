//
//  ViewController.m
//  TableViewDemo
//
//  Created by Training on 02/12/16.
//  Copyright © 2016 Training. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.data = [[NSMutableArray alloc] init];
    self.tableView.delegate= self;
    self.tableView.dataSource= self;
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
            
            [self.tableView reloadData];
        });
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    // data validation
    if (![self.data[indexPath.row][@"title"] isKindOfClass:[NSNull class]]) {
        cell.textLabel.text = self.data[indexPath.row][@"title"];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
