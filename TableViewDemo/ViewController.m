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
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.data = [[NSMutableArray alloc] init];
    self.images = [[NSMutableArray alloc] init];
    self.tableView.delegate= self;
    self.tableView.dataSource= self;
    self.tableView.estimatedRowHeight= 44.0;
    
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
            //
            [self loadThumbnailImagesFromNetwork];
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
    
    static NSString *cellIdentifier = @"CustomCell";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }    // data validation
    if (![self isNULL:self.data[indexPath.row][@"title"]]) {
        cell.titleLabel.text = self.data[indexPath.row][@"title"];
        if (![self isNULL:self.data[indexPath.row][@"description"]]) {
            cell.descLabel.text = self.data[indexPath.row][@"description"];
        }
    }
//    if ([self.images count] > 0 && (indexPath.row < [self.images count]) && [self.images objectAtIndex:indexPath.row]) {
//        [cell.imageView setImage:self.images[indexPath.row][self.data[indexPath.row][@"title"]]];
//        
//    }
    return cell;
}

- (void) loadThumbnailImagesFromNetwork {
    // Dispatch network call into a Queue : GCD
    for (int i= 0; i < [self.data count]; i++) {
        if (![self isNULL:self.data[i][@"imageHref"]] && ![self.data[i][@"imageHref"] isEqualToString:@"null"]) {
            // Load Image from network
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.data[i][@"imageHref"]]];
                NSLog(@"");
                UIImage *image = [UIImage imageWithData:imageData];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                if (image) {
                    //[self.images addObject:image];
                    [dict setObject:image forKey:self.data[i][@"title"]];
                } else {
                    //[self.images addObject:[UIImage imageNamed:@"placeholder"]];
                    [dict setObject:[UIImage imageNamed:@"placeholder"] forKey:self.data[i][@"title"]];
                }
                
                
                [self.images addObject:dict];
                // Main Thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            });
        }
    }
}


- (BOOL) isNULL : (id)value {
    return [value isKindOfClass:[NSNull class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
