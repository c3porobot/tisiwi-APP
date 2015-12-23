//
//  TSWMyRequirementsCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/23.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWMyRequirementsCell.h"

@interface TSWMyRequirementsCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation TSWMyRequirementsCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        
        UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 10.0f, width, 60.0f)];
        top.backgroundColor = RGB(32, 158, 217);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12.0f, 8.0f, 44.0f, 44.0f)];
        imageView.image = [UIImage imageNamed:@"requirement_highlighted"];
        [top addSubview:imageView];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(44.0f+18.0f, 12.0f, width-24.0f-44.0f-5.0f-75.0f, 14.0f)];
        self.titleLabel.textColor = RGB(250, 250, 250);
        self.titleLabel.text = @"需求A";
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.titleLabel.numberOfLines = 0;
        [top addSubview:self.titleLabel];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(44.0f+18.0f, 12.0f+14.0f+8.0f, width-24.0f-44.0f-5.0f, 10.0f)];
        self.timeLabel.textColor = RGB(192, 206, 213);
        self.timeLabel.text = @"提交时间:2015-8-10";
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.font = [UIFont systemFontOfSize:10.0f];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.timeLabel.numberOfLines = 0;
        [top addSubview:self.timeLabel];
        
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(width-75.0f, 12.0f, 75.0f, 14.0f)];
        self.statusLabel.textColor = RGB(234, 234, 234);
        self.statusLabel.text = @"已提交";
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.font = [UIFont systemFontOfSize:14.0f];
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.statusLabel.numberOfLines = 0;
        [top addSubview:self.statusLabel];
        
        [self.contentView addSubview:top];
        
        UITapGestureRecognizer *rTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction)];
        
        [self.contentView addGestureRecognizer:rTapGesture];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setMyRequirement:(TSWMyRequirement *)myRequirement
{
    _myRequirement = myRequirement;
    
    if([_myRequirement.type isEqualToString:@"financing"]){
        _titleLabel.text = @"融资需求";
    }else if([_myRequirement.type isEqualToString:@"personnel"]){
        _titleLabel.text = @"人才需求";
    }else{
        _titleLabel.text = @"其他需求";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *datea = [NSDate dateWithTimeIntervalSince1970:[_myRequirement.time doubleValue]];
    NSString *dateString = [formatter stringFromDate:datea];
    
    _timeLabel.text = [[NSString alloc]initWithFormat:@"提交时间:%@",dateString];
    
    if(_myRequirement.status == 0){
        _statusLabel.text = @"已提交";
    }else if(_myRequirement.status == 1){
        _statusLabel.text = @"处理中";
    }else if(_myRequirement.status == 2){
        _statusLabel.text = @"已完成";
    }else if(_myRequirement.status == 3){
        _statusLabel.text = @"关闭";
    }
    

    [self setNeedsLayout];
}

-(void)clickAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoList:withRequirement:)]) {
        [self.delegate gotoList:self withRequirement:_myRequirement];
    }
}


@end

