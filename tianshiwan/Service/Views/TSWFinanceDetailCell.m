//
//  TSWFinanceDetailCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/17.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWFinanceDetailCell.h"
#import "TSWFinanceDetail.h"

@implementation TSWFinanceDetailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //头部
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(15.0f, 22.0f, width-2*15.0f, 14.0f)];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, (width-2*15.0f)/2, 14.0f)];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = RGB(32, 158, 217);
        nameLabel.font = [UIFont systemFontOfSize:14.0f];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = @"";
        [headerView addSubview:nameLabel];
        
        UILabel *zanLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-15.0f, 2.0f, width/2-15.0f, 12.0f)];
        zanLabel.textAlignment = NSTextAlignmentRight;
        zanLabel.textColor = RGB(127, 127, 127);
        zanLabel.font = [UIFont systemFontOfSize:12.0f];
        zanLabel.backgroundColor = [UIColor clearColor];
        zanLabel.text = @"";
        CGSize size2 = [zanLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
        [headerView addSubview:zanLabel];
        UIImageView *zanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 15.0f - size2.width - 2.0f - 15.0f - 15.0f - 3.0f, 0.0f, 15.0f, 15.0f)];
        zanImageView.image = [UIImage imageNamed:@"agree"];
        zanImageView.backgroundColor = [UIColor clearColor];
        [headerView addSubview:zanImageView];
        
        UILabel *locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(60.0f+15.0f, 2.0f, width-60.0f-15.0f-(15.0f + size2.width + 2.0f + 15.0f + 15.0f+15.0f), 12.0f)];
        locationLabel.textAlignment = NSTextAlignmentRight;
        locationLabel.textColor = RGB(127, 127, 127);
        locationLabel.font = [UIFont systemFontOfSize:12.0f];
        locationLabel.backgroundColor = [UIColor clearColor];
        locationLabel.text = @"";
        CGSize size = [locationLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
        [headerView addSubview:locationLabel];
        UIImageView *mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - (15.0f + size2.width + 2.0f + 15.0f + 15.0f+15.0f) - size.width - 3.0f - 11.0f, 2.0f, 11.0f, 15.0f)];
        mapImageView.image = [UIImage imageNamed:@"location"];
        mapImageView.backgroundColor = [UIColor clearColor];
        
        [headerView addSubview:mapImageView];
        
        [self.contentView addSubview:headerView];
        
        UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 22.0f+14.0f+8.0f, width - 2*15.0f, 12.0f)];
        positionLabel.textAlignment = NSTextAlignmentLeft;
        positionLabel.textColor = RGB(105, 105, 105);
        positionLabel.font = [UIFont systemFontOfSize:12.0f];
        positionLabel.backgroundColor = [UIColor clearColor];
        positionLabel.text = @"";
        [self.contentView addSubview:positionLabel];
        
        
        // 分层次介绍
        UILabel *personInfo = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+18.0f, width-2*15.0f, 12.0f)];
        personInfo.textAlignment = NSTextAlignmentLeft;
        personInfo.textColor = RGB(127, 127, 127);
        personInfo.font = [UIFont systemFontOfSize:12.0f];
        personInfo.backgroundColor = [UIColor clearColor];
        personInfo.text = @"个人介绍:";
        [self.contentView addSubview:personInfo];
        UILabel *personContent = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+18.0f+12.0f+5.0f, width-2*20.0f, 12.0f)];
        personContent.textAlignment = NSTextAlignmentLeft;
        personContent.textColor = RGB(155, 155, 155);
        personContent.font = [UIFont systemFontOfSize:12.0f];
        personContent.backgroundColor = [UIColor clearColor];
        NSString *titleContent = @"";
        personContent.text = titleContent;
        personContent.numberOfLines = 0;
        CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        personContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+18.0f+12.0f+5.0f, titleSize.width, titleSize.height);
        [self.contentView addSubview:personContent];
        
        UILabel *fieldLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+18.0f+(12.0f+5.0f)+titleSize.height+15.0f, width-2*15.0f, 12.0f)];
        fieldLabel.textAlignment = NSTextAlignmentLeft;
        fieldLabel.textColor = RGB(127, 127, 127);
        fieldLabel.font = [UIFont systemFontOfSize:12.0f];
        fieldLabel.backgroundColor = [UIColor clearColor];
        fieldLabel.text = @"投资领域:";
        [self.contentView addSubview:fieldLabel];
        
        UILabel *fieldContent = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+18.0f+2*(12.0f+5.0f)+titleSize.height+15.0f, width-2*20.0f, 12.0f)];
        fieldContent.textAlignment = NSTextAlignmentLeft;
        fieldContent.textColor = RGB(155, 155, 155);
        fieldContent.font = [UIFont systemFontOfSize:12.0f];
        fieldContent.backgroundColor = [UIColor clearColor];
        NSString *titleContent2 = @"";
        fieldContent.text = titleContent2;
        fieldContent.numberOfLines = 0;
        CGSize titleSize2 = [titleContent2 boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        fieldContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+18.0f+2*(12.0f+5.0f)+titleSize.height+15.0f, titleSize2.width, titleSize2.height);
        [self.contentView addSubview:fieldContent];
        
        UILabel *stepLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+18.0f+2*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f, width-2*15.0f, 12.0f)];
        stepLabel.textAlignment = NSTextAlignmentLeft;
        stepLabel.textColor = RGB(127, 127, 127);
        stepLabel.font = [UIFont systemFontOfSize:12.0f];
        stepLabel.backgroundColor = [UIColor clearColor];
        stepLabel.text = @"投资阶段:";
        [self.contentView addSubview:stepLabel];
        
        UILabel *stepContent = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+18.0f+3*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f, width-2*20.0f, 12.0f)];
        stepContent.textAlignment = NSTextAlignmentLeft;
        stepContent.textColor = RGB(155, 155, 155);
        stepContent.font = [UIFont systemFontOfSize:12.0f];
        stepContent.backgroundColor = [UIColor clearColor];
        NSString *titleContent3 = @"";
        stepContent.text = titleContent3;
        stepContent.numberOfLines = 0;
        CGSize titleSize3 = [titleContent3 boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        stepContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+18.0f+3*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f, titleSize3.width, titleSize3.height);
        [self.contentView addSubview:stepContent];
        
        UILabel *sampleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+18.0f+3*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0f, width-2*15.0f, 12.0f)];
        sampleLabel.textAlignment = NSTextAlignmentLeft;
        sampleLabel.textColor = RGB(127, 127, 127);
        sampleLabel.font = [UIFont systemFontOfSize:12.0f];
        sampleLabel.backgroundColor = [UIColor clearColor];
        sampleLabel.text = @"投资案例:";
        [self.contentView addSubview:sampleLabel];
        
        UILabel *sampleContent = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+12.0f+4*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F, width-2*20.0f, 12.0f)];
        sampleContent.textAlignment = NSTextAlignmentLeft;
        sampleContent.textColor = RGB(155, 155, 155);
        sampleContent.font = [UIFont systemFontOfSize:12.0f];
        sampleContent.backgroundColor = [UIColor clearColor];
        NSString *titleContent4 = @"";
        sampleContent.text = titleContent4;
        sampleContent.numberOfLines = 0;
        CGSize titleSize4 = [titleContent4 boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        sampleContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+18.0f+4*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F, titleSize4.width, titleSize4.height);
        [self.contentView addSubview:sampleContent];
        
        UILabel *wayLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+18.0f+4*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f, width-2*15.0f, 12.0f)];
        wayLabel.textAlignment = NSTextAlignmentLeft;
        wayLabel.textColor = RGB(127, 127, 127);
        wayLabel.font = [UIFont systemFontOfSize:12.0f];
        wayLabel.backgroundColor = [UIColor clearColor];
        wayLabel.text = @"申请方式:";
        [self.contentView addSubview:wayLabel];
        
        UILabel *wayContent = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+18.0f+5*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f, width-2*20.0f, 12.0f)];
        wayContent.textAlignment = NSTextAlignmentLeft;
        wayContent.textColor = RGB(155, 155, 155);
        wayContent.font = [UIFont systemFontOfSize:12.0f];
        wayContent.backgroundColor = [UIColor clearColor];
        NSString *titleContent5 = @"";
        wayContent.text = titleContent5;
        wayContent.numberOfLines = 0;
        CGSize titleSize5 = [titleContent5 boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        wayContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+18.0f+5*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f, titleSize5.width, titleSize5.height);
        [self.contentView addSubview:wayContent];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    //
    self.contentView.frame = CGRectMake(0.0f,0.0f,width,height);
}

- (void)setFinanceDetail:(TSWFinanceDetail *)financeDetail{
    _financeDetail = financeDetail;
    //
    
}

- (void) phone{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoPhone:withFinanceDetail:)]) {
        [self.delegate gotoPhone:self withFinanceDetail:_financeDetail];
    }
}

- (void) email{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoEmail:withFinanceDetail:)]) {
        [self.delegate gotoEmail:self withFinanceDetail:_financeDetail];
    }
}


@end
