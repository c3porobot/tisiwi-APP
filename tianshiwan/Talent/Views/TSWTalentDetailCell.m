//
//  TSWTalentDetailCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWTalentDetailCell.h"
#import "TSWTalentDetail.h"

@implementation TSWTalentDetailCell

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
        
        UILabel *locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-15.0f, 2.0f, width/2-15.0f, 12.0f)];
        locationLabel.textAlignment = NSTextAlignmentRight;
        locationLabel.textColor = RGB(127, 127, 127);
        locationLabel.font = [UIFont systemFontOfSize:12.0f];
        locationLabel.backgroundColor = [UIColor clearColor];
        locationLabel.text = @"";
        CGSize size = [locationLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
        [headerView addSubview:locationLabel];
        
        UIImageView *mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 15.0f - size.width - 2.0f - 15.0f - 15.0f, 2.0f, 11.0f, 15.0f)];
        mapImageView.image = [UIImage imageNamed:@"location"];
        mapImageView.backgroundColor = [UIColor clearColor];
        [headerView addSubview:mapImageView];
        
        [self.contentView addSubview:headerView];
        
        
        // 分层次介绍
        UILabel *baseLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f, width-2*15.0f, 12.0f)];
        baseLabel1.textAlignment = NSTextAlignmentLeft;
        baseLabel1.textColor = RGB(127, 127, 127);
        baseLabel1.font = [UIFont systemFontOfSize:12.0f];
        baseLabel1.backgroundColor = [UIColor clearColor];
        baseLabel1.text = @"基本信息:";
        [self.contentView addSubview:baseLabel1];
        UILabel *baseLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+12.0f+5.0f, width-2*20.0f, 12.0f)];
        baseLabel2.textAlignment = NSTextAlignmentLeft;
        baseLabel2.textColor = RGB(155, 155, 155);
        baseLabel2.font = [UIFont systemFontOfSize:12.0f];
        baseLabel2.backgroundColor = [UIColor clearColor];
        baseLabel2.text = @"";
        [self.contentView addSubview:baseLabel2];
        UILabel *baseLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+2*(12.0f+5.0f), width-2*20.0f, 12.0f)];
        baseLabel3.textAlignment = NSTextAlignmentLeft;
        baseLabel3.textColor = RGB(155, 155, 155);
        baseLabel3.font = [UIFont systemFontOfSize:12.0f];
        baseLabel3.backgroundColor = [UIColor clearColor];
        baseLabel3.text = @"";
        [self.contentView addSubview:baseLabel3];
        
        UILabel *directLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+2*(12.0f+5.0f)+12.0f+15.0f, width-2*15.0f, 12.0f)];
        directLabel1.textAlignment = NSTextAlignmentLeft;
        directLabel1.textColor = RGB(127, 127, 127);
        directLabel1.font = [UIFont systemFontOfSize:12.0f];
        directLabel1.backgroundColor = [UIColor clearColor];
        directLabel1.text = @"意向岗位:";
        [self.contentView addSubview:directLabel1];
        UILabel *directLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+3*(12.0f+5.0f)+12.0f+15.0f, width-2*20.0f, 12.0f)];
        directLabel2.textAlignment = NSTextAlignmentLeft;
        directLabel2.textColor = RGB(155, 155, 155);
        directLabel2.font = [UIFont systemFontOfSize:12.0f];
        directLabel2.backgroundColor = [UIColor clearColor];
        directLabel2.text = @"";
        [self.contentView addSubview:directLabel2];
        
        UILabel *jianLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+3*(12.0f+5.0f)+2*(12.0f+15.0f), width-2*15.0f, 12.0f)];
        jianLabel1.textAlignment = NSTextAlignmentLeft;
        jianLabel1.textColor = RGB(127, 127, 127);
        jianLabel1.font = [UIFont systemFontOfSize:12.0f];
        jianLabel1.backgroundColor = [UIColor clearColor];
        jianLabel1.text = @"个人简介:";
        [self.contentView addSubview:jianLabel1];
        UILabel *jianLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+4*(12.0f+5.0f)+2*(12.0f+15.0f), width-2*20.0f, 12.0f)];
        jianLabel2.textAlignment = NSTextAlignmentLeft;
        jianLabel2.textColor = RGB(155, 155, 155);
        jianLabel2.font = [UIFont systemFontOfSize:12.0f];
        jianLabel2.backgroundColor = [UIColor clearColor];
        NSString *titleContent = @"";
        jianLabel2.text = titleContent;
        jianLabel2.numberOfLines = 0;
        CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        jianLabel2.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(headerView.frame)+28.0f+4*(12.0f+5.0f)+2*(12.0f+15.0f), titleSize.width, titleSize.height);
        [self.contentView addSubview:jianLabel2];
        
        
        
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

- (void)setTalentDetail:(TSWTalentDetail *)talentDetail{
    _talentDetail = talentDetail;
    
}

- (void) phone{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoPhone:withTalentDetail:)]) {
        [self.delegate gotoPhone:self withTalentDetail:_talentDetail];
    }
}

- (void) email{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoEmail:withTalentDetail:)]) {
        [self.delegate gotoEmail:self withTalentDetail:_talentDetail];
    }
}

@end
