//
//  TSWContactsLetterCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/14.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWContactsLetterCell.h"

@interface TSWContactsLetterCell()

@property (nonatomic, strong) UILabel *letterLabel;

@end

@implementation TSWContactsLetterCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = RGB(234, 234, 234);
        self.letterLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.letterLabel.textAlignment = NSTextAlignmentLeft;
        self.letterLabel.textColor = RGB(134, 134, 134);
        self.letterLabel.font = [UIFont systemFontOfSize:12.0f];
        self.letterLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.letterLabel.numberOfLines = 0;
        self.letterLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.letterLabel setText:@""];
        [self.contentView addSubview:self.letterLabel];
        
        NSDictionary *views = @{
                                @"contentView":self.contentView,
                                @"letterLabel":self.letterLabel
                                };
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[letterLabel]-10-|" options:0 metrics:0 views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[letterLabel]-5-|" options:0 metrics:0 views:views]];
    }
    return self;
}

- (void)layoutSubviews
{
}

- (void)setLetter:(NSString *)letter
{
    _letterLabel.text = letter;
    
}

@end

