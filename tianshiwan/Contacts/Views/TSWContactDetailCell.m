//
//  TSWContactDetailCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/15.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWContactDetailCell.h"

@implementation TSWContactDetailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        //头部
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, width-2*15.0f, 90.0f)];
        UIImageView *faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 10.0f, 60.0f, 60.0f)];
        faceImageView.image = [UIImage imageNamed:@"default_face"];
        [headerView addSubview:faceImageView];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f+15.0f,22.0f, width - (15.0f+60.0f+15.0f+15.0f), 14.0f)];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = RGB(32, 158, 217);
        nameLabel.font = [UIFont systemFontOfSize:15.0f];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = @"碧波";
        [headerView addSubview:nameLabel];
        
        UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f+15.0f, 22.0f+14.0f+10.0f, width - (15.0f+60.0f+15.0f+15.0f), 12.0f)];
        positionLabel.textAlignment = NSTextAlignmentLeft;
        positionLabel.textColor = RGB(132, 132, 132);
        positionLabel.font = [UIFont systemFontOfSize:12.0f];
        positionLabel.backgroundColor = [UIColor clearColor];
        positionLabel.text = @"";
        [headerView addSubview:positionLabel];
        
        [self.contentView addSubview:headerView];
        
        // 分层次介绍
        UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+60.0f+15.0f, width-2*15.0f, 12.0f)];
        titleLabel1.textAlignment = NSTextAlignmentLeft;
        titleLabel1.textColor = RGB(105, 105, 105);
        titleLabel1.font = [UIFont systemFontOfSize:12.0f];
        titleLabel1.backgroundColor = [UIColor clearColor];
        titleLabel1.text = @"项目信息:";
        [self.contentView addSubview:titleLabel1];
        
        UILabel *projectInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 10.0f+60.0f+15.0f+12.0f+5.0f, width, 50.0f)];
        projectInfoLabel.textAlignment = NSTextAlignmentLeft;
        projectInfoLabel.textColor = RGB(155, 155, 155);
        projectInfoLabel.font = [UIFont systemFontOfSize:12.0f];
        projectInfoLabel.backgroundColor = [UIColor clearColor];
        NSString *titleContent = @"";
        projectInfoLabel.text = titleContent;
        projectInfoLabel.numberOfLines = 0;
        CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        projectInfoLabel.frame = CGRectMake(20.0f, 10.0f+60.0f+15.0f+12.0f+5.0f, titleSize.width, titleSize.height);
        [self.contentView addSubview:projectInfoLabel];
        
        UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+60.0f+15.0f+12.0f+5.0f+CGRectGetHeight(projectInfoLabel.frame)+15.0f, width-2*15.0f, 12.0f)];
        titleLabel2.textAlignment = NSTextAlignmentLeft;
        titleLabel2.textColor = RGB(105, 105, 105);
        titleLabel2.font = [UIFont systemFontOfSize:12.0f];
        titleLabel2.backgroundColor = [UIColor clearColor];
        titleLabel2.text = @"公司信息:";
        [self.contentView addSubview:titleLabel2];
        
        UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 10.0f+60.0f+15.0f+2*(12.0f+5.0f)+CGRectGetHeight(projectInfoLabel.frame)+15.0f, width-2*20.0f, 12.0f)];
        cityLabel.textAlignment = NSTextAlignmentLeft;
        cityLabel.textColor =RGB(155, 155, 155);
        cityLabel.font = [UIFont systemFontOfSize:12.0f];
        cityLabel.backgroundColor = [UIColor clearColor];
        cityLabel.text = @"";
        [self.contentView addSubview:cityLabel];
        UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 10.0f+60.0f+15.0f+3*(12.0f+5.0f)+CGRectGetHeight(projectInfoLabel.frame)+15.0f, width-2*20.0f, 12.0f)];
        companyLabel.textAlignment = NSTextAlignmentLeft;
        companyLabel.textColor = RGB(155, 155, 155);
        companyLabel.font = [UIFont systemFontOfSize:12.0f];
        companyLabel.backgroundColor = [UIColor clearColor];
        companyLabel.text = @"";
        [self.contentView addSubview:companyLabel];
        UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 10.0f+60.0f+15.0f+4*(12.0f+5.0f)+CGRectGetHeight(projectInfoLabel.frame)+15.0f, width-2*20.0f, 12.0f)];
        addressLabel.textAlignment = NSTextAlignmentLeft;
        addressLabel.textColor = RGB(155, 155, 155);
        addressLabel.font = [UIFont systemFontOfSize:12.0f];
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.text = @"";
        [self.contentView addSubview:addressLabel];
        
        UILabel *titleLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+60.0f+15.0f+4*(12.0f+5.0f)+CGRectGetHeight(projectInfoLabel.frame)+15.0f+12.0f+15.0f, width-2*15.0f, 12.0f)];
        titleLabel3.textAlignment = NSTextAlignmentLeft;
        titleLabel3.textColor = RGB(105, 105, 105);
        titleLabel3.font = [UIFont systemFontOfSize:12.0f];
        titleLabel3.backgroundColor = [UIColor clearColor];
        titleLabel3.text = @"联系方式";
        [self.contentView addSubview:titleLabel3];
        
        UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 10.0f+60.0f+15.0f+5*(12.0f+5.0f)+CGRectGetHeight(projectInfoLabel.frame)+15.0f+12.0f+15.0f, width-2*20.0f, 12.0f)];
        phoneLabel.textAlignment = NSTextAlignmentLeft;
        phoneLabel.textColor = RGB(155, 155, 155);
        phoneLabel.font = [UIFont systemFontOfSize:12.0f];
        phoneLabel.backgroundColor = [UIColor clearColor];
        phoneLabel.text = @"";
        [self.contentView addSubview:phoneLabel];
        
        UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 10.0f+60.0f+15.0f+6*(12.0f+5.0f)+CGRectGetHeight(projectInfoLabel.frame)+15.0f+12.0f+15.0f, width-2*20.0f, 12.0f)];
        emailLabel.textAlignment = NSTextAlignmentLeft;
        emailLabel.textColor = RGB(155, 155, 155);
        emailLabel.font = [UIFont systemFontOfSize:12.0f];
        emailLabel.backgroundColor = [UIColor clearColor];
        emailLabel.text = @"";
        [self.contentView addSubview:emailLabel];
        
        UILabel *weixinLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 10.0f+60.0f+15.0f+7*(12.0f+5.0f)+CGRectGetHeight(projectInfoLabel.frame)+15.0f+12.0f+15.0f, width-2*20.0f, 12.0f)];
        weixinLabel.textAlignment = NSTextAlignmentLeft;
        weixinLabel.textColor = RGB(155, 155, 155);
        weixinLabel.font = [UIFont systemFontOfSize:12.0f];
        weixinLabel.backgroundColor = [UIColor clearColor];
        weixinLabel.text = @"";
        [self.contentView addSubview:weixinLabel];
    }
    return self;
}

- (void)layoutSubviews
{
        [super layoutSubviews];
}

- (void)setContactDetail:(TSWContactDetail *)contactDetail{
    _contactDetail = contactDetail;
}

- (void) phone{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoPhone:withContact:)]) {
        [self.delegate gotoPhone:self withContact:_contactDetail];
    }
}

- (void) email{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoEmail:withContact:)]) {
        [self.delegate gotoEmail:self withContact:_contactDetail];
    }
}

- (void) weixin{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoWeixin:withContact:)]) {
        [self.delegate gotoWeixin:self withContact:_contactDetail];
    }
}

@end


