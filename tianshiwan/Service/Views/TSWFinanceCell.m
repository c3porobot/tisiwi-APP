//
//  TSWFinanceCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/17.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWFinanceCell.h"

@interface TSWFinanceCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *stepLabel;
@property (nonatomic, strong) UILabel *sampleLabel;
@property (nonatomic, strong) UILabel *zanLabel;
@property (nonatomic, strong) UIImageView *mapImageView;
@property (nonatomic, strong) UIImageView *goodImageView;

@end

@implementation TSWFinanceCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width-68.0f, 80.0f)];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 12.0f, (width-15.0f)/2, 17.0f)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = RGB(32, 158, 217);
        _nameLabel.font = [UIFont systemFontOfSize:17.0f];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.text = @"";
        [titleView addSubview:_nameLabel];
        
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2, 12.0f, (width-2*15.0f)/2, 14.0f)];
        _typeLabel.textAlignment = NSTextAlignmentRight;
        _typeLabel.textColor = RGB(206, 206, 206);
        _typeLabel.font = [UIFont systemFontOfSize:14.0f];
        _typeLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.text = @"";
        [titleView addSubview:_typeLabel];
        
        _positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 12.0f+17.0f+8.0f, width - 115.0f, 12.0f)];
        _positionLabel.textAlignment = NSTextAlignmentLeft;
        _positionLabel.textColor = RGB(105, 105, 105);
        _positionLabel.font = [UIFont systemFontOfSize:12.0f];
        _positionLabel.backgroundColor = [UIColor clearColor];
        _positionLabel.text = @"";
        [titleView addSubview:_positionLabel];
        
        
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-115.0f, 12, 100.0f, 12.0f)];
        _cityLabel.textAlignment = NSTextAlignmentRight;
        _cityLabel.textColor = RGB(105, 105, 105);
        _cityLabel.font = [UIFont systemFontOfSize:12.0f];
        _cityLabel.backgroundColor = [UIColor clearColor];
        _cityLabel.text = @"";
        CGSize size = [_cityLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
        [titleView addSubview:_cityLabel];
        _mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 15.0f-size.width-11.0f-3.0f, 12.0f+17.0f+8.0f-2.0f, 11.0f, 15.0f)];
        _mapImageView.image = [UIImage imageNamed:@"location"];
        _mapImageView.backgroundColor = [UIColor clearColor];
        [titleView addSubview:_mapImageView];
        
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
       // [titleView addSubview:_goodImageView];
        
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

- (void)setFinance:(TSWFinance *)finance
{
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    _finance = finance;
    
    _nameLabel.text = _finance.name;
    _positionLabel.text = [NSString stringWithFormat:@"%@  %@", _finance.company, _finance.title];
    
    NSArray *provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    for (int i=0; i<[provinces count]; i++) {
        NSArray *cities = [[provinces objectAtIndex:i] objectForKey:@"cities"];
        for(int j=0; j<[cities count];j++){
            NSString *code = [[cities objectAtIndex:j] objectForKey:@"code"];
            if([code isEqualToString: _finance.cityCode]){
                _cityLabel.text = [[cities objectAtIndex:j] objectForKey:@"CityName"];
                break;
            }
        }
    }
//    _cityLabel.text = _finance.cityName;
    CGSize size = [_cityLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
    _mapImageView.frame = CGRectMake(width - 15.0f-size.width-11.0f-3.0f, 12, 11.0f, 15.0f);
    _stepLabel.text = [NSString stringWithFormat:@"投资阶段: %@",_finance.rounds];
    if ([_finance.fields isEqualToString:@""] || [_finance.fields length] == 0) {
        _sampleLabel.text = [NSString stringWithFormat:@"投资领域: 暂无"];

    } else {
        _sampleLabel.text = [NSString stringWithFormat:@"投资领域: %@",_finance.fields];

    }
    _zanLabel.text = [NSString stringWithFormat:@"%ld",(long)_finance.like];
    CGSize size2 = [_zanLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
    _goodImageView.frame = CGRectMake(width - 15.0f-size2.width-15.0f-6.0f,12.0f+14.0f+8.0f+2*(12.0f+8.0f)-3.0f, 15.0f, 15.0f);
}

- (void) clickAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoFinanceDetail:withFinance:withResult:)]) {
        [self.delegate gotoFinanceDetail:self withFinance:_finance withResult:_result];
    }
}

@end

