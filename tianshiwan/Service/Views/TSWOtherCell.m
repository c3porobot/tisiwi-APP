//
//  TSWOtherCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/10/1.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWOtherCell.h"

@interface TSWOtherCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *stepLabel;
@property (nonatomic, strong) UILabel *sampleLabel;
@property (nonatomic, strong) UILabel *zanLabel;
@property (nonatomic, strong) UIImageView *mapImageView;

@property (nonatomic, strong) UIImageView *goodImageView;
@end

@implementation TSWOtherCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width-68.0f, 80.0f)];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 12.0f, (width-15.0f)/2, 17.0f)];
        //_nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = RGB(32, 158, 217);
        _nameLabel.font = [UIFont systemFontOfSize:17.0f];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.text = @"";
        [titleView addSubview:_nameLabel];
        
        _positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 12.0f+17.0f+8.0f, width - 115.0f, 12.0f)];
        _positionLabel.textAlignment = NSTextAlignmentLeft;
        _positionLabel.textColor = RGB(105, 105, 105);
        _positionLabel.font = [UIFont systemFontOfSize:12.0f];
        _positionLabel.backgroundColor = [UIColor clearColor];
        _positionLabel.text = @"";
        [titleView addSubview:_positionLabel];
        
        /**
         * 服务地区和标签
         */
        _stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 12.0f+17.0f+8.0f+12.0f+8.0f, width - 115.0f, 12.0f)];
        _stepLabel.textAlignment = NSTextAlignmentLeft;
        _stepLabel.textColor = RGB(127, 127, 127);
        _stepLabel.font = [UIFont systemFontOfSize:12.0f];
        _stepLabel.backgroundColor = [UIColor clearColor];
        _stepLabel.text = @"";
        [titleView addSubview:_stepLabel];
        
        _sampleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 12.0f+17.0f+8.0f+2*(12.0f+8.0f), width - 68.0f, 12.0f)];
        _sampleLabel.textAlignment = NSTextAlignmentLeft;
        _sampleLabel.textColor = RGB(127, 127, 127);
        _sampleLabel.font = [UIFont systemFontOfSize:12.0f];
        _sampleLabel.backgroundColor = [UIColor clearColor];
        _sampleLabel.text = @"";
        [titleView addSubview:_sampleLabel];
        
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-115.0f, 12.0f, 100.0f, 12.0f)];
        _cityLabel.textAlignment = NSTextAlignmentRight;
        _cityLabel.textColor = RGB(105, 105, 105);
        _cityLabel.font = [UIFont systemFontOfSize:12.0f];
        _cityLabel.backgroundColor = [UIColor clearColor];
        _cityLabel.text = @"";
        CGSize size = [_cityLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
        [titleView addSubview:_cityLabel];
        _mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 15.0f-size.width-11.0f-3.0f, 12.0f, 11.0f, 15.0f)];
        _mapImageView.image = [UIImage imageNamed:@"location"];
        _mapImageView.backgroundColor = [UIColor clearColor];
        [titleView addSubview:_mapImageView];
        
        
        _zanLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-115.0f, 12.0f+17.0f+8.0f+2*(12.0f+8.0f), 100.0f, 12.0f)];
        _zanLabel.textAlignment = NSTextAlignmentRight;
        _zanLabel.textColor = RGB(105, 105, 105);
        _zanLabel.font = [UIFont systemFontOfSize:12.0f];
        _zanLabel.backgroundColor = [UIColor clearColor];
        _zanLabel.text = @"";
        CGSize size2 = [_zanLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
        //[titleView addSubview:_zanLabel];
        _goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 15.0f-size2.width-15.0f-10.0f,12.0f+17.0f+8.0f+2*(12.0f+8.0f)-3.0f, 15.0f, 15.0f)];
        _goodImageView.image = [UIImage imageNamed:@"agree"];
        _goodImageView.backgroundColor = [UIColor clearColor];
        //[titleView addSubview:_goodImageView];
        
        [self.contentView addSubview:titleView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 100.0f, width, 10.0f)];
        bottomView.backgroundColor = RGB(234, 234, 234);
        [self.contentView addSubview:bottomView];
        
        UITapGestureRecognizer *financeTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction)];
        
        [self.contentView addGestureRecognizer:financeTapGesture];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setOther:(TSWOther *)other
{
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    _other = other;
    
    _nameLabel.text = _other.name;
    _positionLabel.text = [NSString stringWithFormat:@"%@  %@", _other.company, _other.title];
    if ([_other.served_aera isEqualToString:@""] || [other.served_aera length] == 0) {
        _stepLabel.text = [NSString stringWithFormat:@"地区: 暂无"];
    } else {
        _stepLabel.text = [NSString stringWithFormat:@"地区: %@", _other.served_aera];
    
    }
    if ([_other.tags isEqualToString:@""] || [other.tags length] == 0) {
        _sampleLabel.text = [NSString stringWithFormat:@"标签: 暂无"];
    } else {
        _sampleLabel.text = [NSString stringWithFormat:@"标签: %@", _other.tags];
    }
    
    NSArray *provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    for (int i=0; i<[provinces count]; i++) {
        NSArray *cities = [[provinces objectAtIndex:i] objectForKey:@"cities"];
        for(int j=0; j<[cities count];j++){
            NSString *code = [[cities objectAtIndex:j] objectForKey:@"code"];
            if([code isEqualToString: _other.cityCode]){
                _cityLabel.text = [[cities objectAtIndex:j] objectForKey:@"CityName"];
                break;
            }
        }
    }
    
    CGSize size = [_cityLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
    _mapImageView.frame = CGRectMake(width - 15.0f-size.width-11.0f-3.0f, 12.0f, 11.0f, 15.0f);
    _zanLabel.text = [NSString stringWithFormat:@"%ld",(long)_other.like];
    CGSize size2 = [_zanLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
    _goodImageView.frame = CGRectMake(width - 15.0f-size2.width-15.0f-6.0f,12.0f+14.0f+8.0f+2*(12.0f+8.0f)-3.0f, 15.0f, 15.0f);
}

- (void) clickAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoOtherDetail:withOther:)]) {
        [self.delegate gotoOtherDetail:self withOther:_other];
    }
}

@end

