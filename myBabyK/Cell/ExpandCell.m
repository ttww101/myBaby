//
//  ExpandCell.m
//  iHealthS
//
//  Created by Apple on 2019/3/27.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import "ExpandCell.h"

@implementation ExpandCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.expand_lab setFrame: CGRectMake(40, 20, 200, 44)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
