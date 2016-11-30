//
//  MyRequirementsCollectionViewCell.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/15.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "MyRequirementsCollectionViewCell.h"
#define kWidth CGRectGetWidth(self.contentView.frame)
#define kHeight CGRectGetHeight(self.contentView.frame)
#define kWidth_label 100
#define kHeight_label 30
#define kMargin_top 20
@implementation MyRequirementsCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.statusLabel];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.financingLabel];
        UITapGestureRecognizer *rTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction)];
        
        [self.contentView addGestureRecognizer:rTapGesture];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, kMargin_top, kWidth - CGRectGetMaxX(self.imageView.frame) - 100, kHeight_label)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
//        self.titleLabel.backgroundColor = [UIColor yellowColor];
        //self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.titleLabel.frame))];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.font = [UIFont systemFontOfSize:14.0f];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.timeLabel.numberOfLines = 0;
    }
    return _timeLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        self.statusLabel = [[UILabel alloc] init];
    }
    return _statusLabel;
}

- (UILabel *)financingLabel {
    if (!_financingLabel) {
        self.financingLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame), kWidth - 30, CGRectGetHeight(self.titleLabel.frame))];
        self.financingLabel.textAlignment = NSTextAlignmentLeft;
        self.financingLabel.font = [UIFont systemFontOfSize:14.0f];
        self.financingLabel.numberOfLines = 0;
    }
    return _financingLabel;
}

- (void)setMyRequirement:(TSWMyRequirement *)myRequirement
{
    _myRequirement = myRequirement;
    
    if(_myRequirement.status == 0){
        _statusLabel.text = @"已提交";
    }else if(_myRequirement.status == 1){
        _statusLabel.text = @"处理中";
    }else if(_myRequirement.status == 2){
        _statusLabel.text = @"已完成";
    }else if(_myRequirement.status == 3){
        _statusLabel.text = @"关闭";
    }

    
    if([_myRequirement.type isEqualToString:@"financing"]){
        NSString *str = @"融资需求";
        _titleLabel.text = [[[[str stringByAppendingString:@" / "] stringByAppendingString:_statusLabel.text] stringByAppendingString:@" / "] stringByAppendingString:@"小侠"];
        _imageView.image = [UIImage imageNamed:@"money"];
        NSString *money;
        if ([myRequirement.amountType isEqualToString:@"rmb"]) {
            money = @"万人民币";
        } else {
            money = @"万美元";
        }
        _financingLabel.text = [[[[@"融资" stringByAppendingString:myRequirement.amount] stringByAppendingString:money] stringByAppendingString:@" / 估值"] stringByAppendingString:myRequirement.valuation] ;
    }else if([_myRequirement.type isEqualToString:@"personnel"]){
//        _titleLabel.text = @"人才需求";
        NSString *str = @"人才需求";
        _titleLabel.text = [[[[str stringByAppendingString:@" / "] stringByAppendingString:_statusLabel.text] stringByAppendingString:@" / "] stringByAppendingString:@"胖胖"];
        _imageView.image = [UIImage imageNamed:@"man"];
        
        _financingLabel.text = [[[[[[myRequirement.name stringByAppendingString:@" / 经验"] stringByAppendingString:myRequirement.amount] stringByAppendingString:@"+年 / "] stringByAppendingString:@"月薪"] stringByAppendingString: myRequirement.salary] stringByAppendingString:@"元"];
        
    }else{
        _titleLabel.text = @"其他需求";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *datea = [NSDate dateWithTimeIntervalSince1970:[_myRequirement.time doubleValue]];
    NSString *dateString = [formatter stringFromDate:datea];
    
    _timeLabel.text = [[NSString alloc]initWithFormat:@"%@",dateString];
    
    
    
    [self setNeedsLayout];
}

-(void)clickAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoList:withRequirement:)]) {
        [self.delegate gotoList:self withRequirement:_myRequirement];
    }
}
@end
