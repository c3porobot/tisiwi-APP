//
//  TSWTalentCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWTalentCell.h"

@interface TSWTalentCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *salaryLabel;
@property (nonatomic, strong) UILabel *positionLabel;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation TSWTalentCell

/**
 * 他把整个cell分成两个部分,展示信息一个视图,发送Email是另一个视图, 然后在这两个视图上添加手势.
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width-68.0f, 80.0f)];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 12.0f, 60.0f, 17.0f)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = RGB(32, 158, 217);
        _nameLabel.font = [UIFont systemFontOfSize:17.0f];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.text = @"";
        [titleView addSubview:_nameLabel];
        _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f+60.0f+10.0f, 13.0f, 80.0f, 12.0f)];
        _yearLabel.textAlignment = NSTextAlignmentLeft;
        _yearLabel.textColor = RGB(127, 127, 127);
        _yearLabel.font = [UIFont systemFontOfSize:12.0f];
        _yearLabel.backgroundColor = [UIColor clearColor];
        _yearLabel.text = @"";
        [titleView addSubview:_yearLabel];
        
        /**
         * 地理位置
         */
        
        UIImageView *mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f+60.0f+10.0f+80.0f+10.0f, 10.0f, 11.0f, 15.0f)];
        mapImageView.image = [UIImage imageNamed:@"location"];
        mapImageView.backgroundColor = [UIColor clearColor];
        [titleView addSubview:mapImageView];
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f+60.0f+10.0f+80.0f+10.0f+11.0f+3.0f, 13.0f, 60.0f, 12.0f)];
        _cityLabel.textAlignment = NSTextAlignmentLeft;
        _cityLabel.textColor = RGB(127, 127, 127);
        _cityLabel.font = [UIFont systemFontOfSize:12.0f];
        _cityLabel.backgroundColor = [UIColor clearColor];
        _cityLabel.text = @"";
        [titleView addSubview:_cityLabel];
        
        _salaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 12.0f+17.0f+8.0f, width - 68.0f, 12.0f)];
        _salaryLabel.textAlignment = NSTextAlignmentLeft;
        _salaryLabel.textColor = RGB(127, 127, 127);
        _salaryLabel.font = [UIFont systemFontOfSize:12.0f];
        _salaryLabel.backgroundColor = [UIColor clearColor];
        _salaryLabel.text = @"";
        [titleView addSubview:_salaryLabel];
        
        _positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 12.0f+17.0f+8.0f+12.0f+8.0f, width - 68.0f, 12.0f)];
        
        _positionLabel.textAlignment = NSTextAlignmentLeft;
        _positionLabel.textColor = RGB(127, 127, 127);
        _positionLabel.font = [UIFont systemFontOfSize:12.0f];
        _positionLabel.backgroundColor = [UIColor clearColor];
        _positionLabel.text = @"";
        [titleView addSubview:_positionLabel];
        
        UITapGestureRecognizer *talentTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction)];
        
        [titleView addGestureRecognizer:talentTapGesture];
        
        [self.contentView addSubview:titleView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 80.0f, width, 10.0f)];
        bottomView.backgroundColor = RGB(234, 234, 234);
        [self.contentView addSubview:bottomView];
        
        /**
         *图片设置大小
         */
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 68.0f + 12.0f, 20.0f, 35, 35)];
        _imageView.image = [UIImage imageNamed:@"maildown_disabled"];
        _imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imageView];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setTalent:(TSWTalent *)talent
{
    _talent = talent;
    
    _nameLabel.text = _talent.name;
    _yearLabel.text = [NSString stringWithFormat:@"%@年工作经验", _talent.seniority];
    
    
    NSArray *provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    for (int i=0; i<[provinces count]; i++) {
        NSArray *cities = [[provinces objectAtIndex:i] objectForKey:@"cities"];
        for(int j=0; j<[cities count];j++){
            NSString *code = [[cities objectAtIndex:j] objectForKey:@"code"];
            if([code isEqualToString: _talent.cityCode]){
                _cityLabel.text = [[cities objectAtIndex:j] objectForKey:@"CityName"];
                break;
            }
        }
    }
    
    _salaryLabel.text = [NSString stringWithFormat:@"月薪要求: %@元", _talent.salary];
    _positionLabel.text = [NSString stringWithFormat:@"意向岗位: %@", _talent.titles];
    
    if(_talent.hasAttachment == 1){
        _imageView.image = [UIImage imageNamed:@"maildown"];
        UITapGestureRecognizer *mailGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(email)];
        [_imageView setUserInteractionEnabled:YES];
        _imageView.exclusiveTouch = YES;
        [_imageView addGestureRecognizer:mailGesture];
    }else{
        _imageView.image = [UIImage imageNamed:@"maildown_disabled"];
        
        /**
         * 添加手势, 发送邮件的手势
         */
        
        UITapGestureRecognizer *mailGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(email)];
        [_imageView setUserInteractionEnabled:NO];
        _imageView.exclusiveTouch = NO;
        [_imageView removeGestureRecognizer:mailGesture];
    }
    
}
//点击事件 ,点击cell的点击事件
- (void) clickAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoTalentDetail:withTalent:)]) {
        [self.delegate gotoTalentDetail:self withTalent:_talent];
    }
}
//发送Email
-(void) email{
    if (self.delegate && [self.delegate respondsToSelector:@selector(email:)]) {
        [self.delegate email:_talent];
    }
}

@end
