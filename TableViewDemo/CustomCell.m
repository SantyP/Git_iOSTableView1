//
//  CustomCell.m
//  TableViewDemo
//
//  Created by iLit on 02/12/16.
//  Copyright © 2016 LM. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell


- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    
    [self.imageView setFrame:CGRectMake(0, (self.bounds.size.height - 80) /2, 80, 80)];
}

@end
