//
//  TSWArticleCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWArticleCell.h"
#import "TSWArticle.h"
#import "CXImageLoader.h"

static const CGFloat imgWidth = 100.0f;
static const CGFloat margin = 10.0f;
static const CGFloat innerMargin = 7.0f;


@interface TSWArticleCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *labelView;
@property (nonatomic, strong) UILabel *summaryLabel;
@property (nonatomic, strong) UIView *ratingView;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation TSWArticleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.contentView.bounds);
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(margin, margin, width - 2*margin, 0.5f)];
        lineView.backgroundColor = RGB(206, 206, 206);
        [self.contentView addSubview:lineView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, 2*margin+0.5f, imgWidth, imgWidth)];
        [_imageView setImage:[UIImage imageNamed:@"small_default"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin+imgWidth+innerMargin, 2*margin+0.5f+5.0f, width - (margin*2+imgWidth+innerMargin), 14.0f)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = RGB(60, 60, 60);
        self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        self.titleLabel.backgroundColor = [UIColor clearColor];
//        self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.titleLabel.text = @"";
//        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.titleLabel];
        
        self.labelView = [[UIView alloc] initWithFrame:CGRectMake(margin+imgWidth+innerMargin, 2*margin+0.5f+5.0f+14.0f+7.0f, width - (margin*2+imgWidth+innerMargin), 16.0f)];
        
        [self.contentView addSubview:self.labelView];
        
//        self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        self.summaryLabel.textAlignment = NSTextAlignmentLeft;
//        self.summaryLabel.textColor = RGB(149, 149, 149);
//        self.summaryLabel.font = [UIFont systemFontOfSize:13.0f];
//        self.summaryLabel.backgroundColor = [UIColor clearColor];
//        self.summaryLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//        NSString *titleContent = @"亲，欢迎您通过以下方式与我们的营销顾问取得联系，交流您再营销推广工作中遇到的问题，营销顾问将免费为您提供咨询服务。";
//        self.summaryLabel.text = titleContent;
//        self.summaryLabel.numberOfLines = 2;
//        CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width - (margin*2+imgWidth+innerMargin), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
//        self.summaryLabel.frame = CGRectMake(margin+imgWidth+innerMargin, 13.0f+7.0f+16.0f+7.0f, titleSize.width, titleSize.height);
//        
//        [self.contentView addSubview:self.summaryLabel];
        
        self.ratingView = [[UIView alloc] initWithFrame:CGRectMake(margin+imgWidth+innerMargin, 120.5f - 10.0f, 100.0f, 10.0f)];
        
        [self.contentView addSubview:self.ratingView];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin+imgWidth+innerMargin+100.0f, 120.5f - 10.0f, width - (margin*2+imgWidth+innerMargin+100), 10.0f)];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.textColor = RGB(199, 199, 199);
        self.timeLabel.font = [UIFont systemFontOfSize:10.0f];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.timeLabel.text = @"时间";
        self.timeLabel.numberOfLines = 0;
        
        [self.contentView addSubview:self.timeLabel];
        
        UITapGestureRecognizer *articleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction)];
        
        [self.contentView addGestureRecognizer:articleTapGesture];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setArticle:(TSWArticle *)article
{
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    _article = article;
    
    // 设置所有控件的值
    
    if (article.imgUrl_3x) {
        [[CXImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:article.imgUrl_3x] image:^(UIImage *image, NSError *error) {
            _imageView.image = [self cutImage:image];
        }];
    }
    NSString *titleContent = article.title;
    _titleLabel.text = titleContent;
    _titleLabel.numberOfLines = 2;
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width - (margin*2+imgWidth+innerMargin), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    _titleLabel.frame = CGRectMake(margin+imgWidth+innerMargin, 2*margin+0.5f+5.0f, width - (margin*2+imgWidth+innerMargin), titleSize.height);

    // 逗号分隔成数组，循环显示button
    NSArray *labelArray = [article.label componentsSeparatedByString:@","];
    NSUInteger count = labelArray.count;
    for(UIView *view in [self.labelView subviews])
    {
        [view removeFromSuperview];
    }
    for (int i=0; i<count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*(45.0f+5.0f), 0.0f, 45.0f, 16.0f)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGB(234, 234, 234);
        label.font = [UIFont systemFontOfSize:10.0f];
        label.backgroundColor = RGB(83, 172, 232);
        label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        label.text = labelArray[i];
        label.numberOfLines = 0;
        [self.labelView addSubview:label];
    }
    self.labelView.frame = CGRectMake(margin+imgWidth+innerMargin, 2*margin+0.5f+5.0f+titleSize.height+7.0f, width - (margin*2+imgWidth+innerMargin), 16.0f);
    
//    _summaryLabel.text = article.summary;
    // 根据星级显示五角星
    for (int i=0; i<5; i++) {
        if(i<[article.rating intValue] && [article.rating intValue]>=0){
            UIImageView *highStar = [[UIImageView alloc]initWithFrame:CGRectMake(i*(11.0f+3.0f), 0.0f, 11.0f, 10.0f)];
            [highStar setImage:[UIImage imageNamed:@"star_highlighted"]];
            [self.ratingView addSubview:highStar];
        }else{
            UIImageView *normalStar = [[UIImageView alloc]initWithFrame:CGRectMake(i*(11.0f+3.0f), 0.0f, 11.0f, 10.0f)];
            [normalStar setImage:[UIImage imageNamed:@"star_normal"]];
            [self.ratingView addSubview:normalStar];
        }
        
    }
    
    // 根据时间算出来几小时前
    NSDate *oldDate = [NSDate dateWithTimeIntervalSince1970:[article.time doubleValue]];
    //获取randomDate和当前时间的时间差
    NSTimeInterval time = [oldDate timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha=now-time;
    if(cha <60){
        _timeLabel.text = @"刚刚";
    }else if (cha<3600){
        int minute = cha/60;
//        NSLog(@"%d分钟前",minute);
        _timeLabel.text = [[NSString alloc]initWithFormat:@"%d分钟前",minute];
    }else if (cha<3600*24){
        int hour = cha/3600;
//        NSLog(@"%d小时前",hour);
        _timeLabel.text = [[NSString alloc]initWithFormat:@"%d小时前",hour];
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:oldDate];
        _timeLabel.text = currentDateStr;
    }
    [self setNeedsLayout];
}


+ (CGSize)calculateCellSizeWithSummary:(TSWArticle *)article containerWidth:(CGFloat)containerWidth
{
    return CGSizeMake(containerWidth, 120.5f);
}

-(void)clickAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoArticleDetail:withArticle:)]) {
        [self.delegate gotoArticleDetail:self withArticle:_article];
    }
}

//裁剪图片
- (UIImage *)cutImage:(UIImage*)image
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (imgWidth / imgWidth)) {
        newSize.width = image.size.width*image.scale;
        newSize.height = image.size.width*image.scale;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.scale*image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height*image.scale;
        newSize.width = image.size.height*image.scale;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.scale*image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

@end
