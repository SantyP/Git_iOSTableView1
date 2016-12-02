//
//  CustomCell.m
//  TableViewDemo
//
//  Created by Santosh Vishwakarma on 02/12/16.
//  Copyright © 2016 LM. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell


- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0,0,80,80);
    
    //Any additional setting that you want to do with image view
    [self.imageView setAutoresizingMask:UIViewAutoresizingNone];
}


@end
