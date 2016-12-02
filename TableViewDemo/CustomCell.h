//
//  CustomCell.h
//  TableViewDemo
//
//  Created by Santosh Vishwakarma on 02/12/16.
//  Copyright © 2016 LM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
