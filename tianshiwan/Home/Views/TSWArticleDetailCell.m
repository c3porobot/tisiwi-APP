//
//  TSWArticleDetailCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/18.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWArticleDetailCell.h"
#import "TSWArticleDetail.h"

static const CGFloat margin = 10.0f;
static const CGFloat contentMargin = 16.0f;
static const CGFloat gap = 20.0f;

static CGFloat webViewHeight = 0.0f;

@interface TSWArticleDetailCell()<UIWebViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *labelView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *ratingView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation TSWArticleDetailCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //头部
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, width-2*margin, (width-2*margin)*17/30)];
        self.imageView.image = [UIImage imageNamed:@""];
        [self.contentView addSubview:self.imageView];
        
        self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, margin+(width-2*margin)*17/30, width - 2*margin, 1100.0f)];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, contentMargin, width - 2*margin, 15.0f)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = @"";
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        [self.mainView addSubview:self.titleLabel];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(margin, contentMargin+15.0f+5.0f, width - 2*margin, 0.5f)];
        self.lineView.backgroundColor = RGB(206, 206, 206);
        [self.mainView addSubview:self.lineView];
        
        self.labelView = [[UILabel alloc]initWithFrame:CGRectMake(12.0f, 2*contentMargin+15.0f+5.0f, 148.0f, 12.0f)];
        [self.mainView addSubview:self.labelView];
        
        self.authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(160.0f, 2*contentMargin+15.0f+5.0f, 148.0f, 14.0f)];
        self.authorLabel.textAlignment = NSTextAlignmentRight;
        self.authorLabel.textColor = RGB(150, 150, 150);
        self.authorLabel.font = [UIFont systemFontOfSize:12.0f];
        self.authorLabel.backgroundColor = [UIColor clearColor];
        self.authorLabel.text = @"";
        self.authorLabel.backgroundColor = [UIColor whiteColor];
        [self.mainView addSubview:self.authorLabel];
        
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(margin,  2*contentMargin+15.0f+5.0f+15.0f+gap, width - 2*margin, 100.0f)];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        _webView.delegate = self;
        UIScrollView *scrollView = (UIScrollView *)[[_webView subviews] objectAtIndex:0];
        scrollView.bounces = NO;
        [self.mainView addSubview:self.webView];
        
        self.ratingView = [[UILabel alloc]initWithFrame:CGRectMake(12.0f, 2*contentMargin+15.0f+5.0f+15.0f+gap+100.0f+50.0f, width - 24.0f, 14.0f)];
        UILabel *ratingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 14.0f)];
        ratingLabel.textAlignment = NSTextAlignmentLeft;
        ratingLabel.textColor = RGB(150, 150, 150);
        ratingLabel.font = [UIFont systemFontOfSize:12.0f];
        ratingLabel.backgroundColor = [UIColor clearColor];
        ratingLabel.text = @"评分";
        ratingLabel.backgroundColor = [UIColor whiteColor];
        [self.ratingView addSubview:ratingLabel];
        [self.mainView addSubview:self.ratingView];
        
        [self.contentView addSubview:self.mainView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setArticleDetail:(TSWArticleDetail *)articleDetail{
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    _articleDetail = articleDetail;
    
    // 设置所有控件的值
    [_imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://7xidpx.com2.z0.glb.qiniucdn.com/partner.png"]]]];
    
    NSString *titleContent = articleDetail.title;
    _titleLabel.text = titleContent;
    _titleLabel.numberOfLines = 0;
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width - (margin*2), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _titleLabel.frame = CGRectMake(margin, contentMargin, titleSize.width, titleSize.height);
    
    self.lineView.frame = CGRectMake(margin, contentMargin+titleSize.height+5.0f, width - 2*margin, 0.5f);

    
    // 逗号分隔成数组，循环显示button
    NSArray *labelArray = [articleDetail.label componentsSeparatedByString:@","];
    NSUInteger count = labelArray.count;
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
    
    self.labelView.frame = CGRectMake(12.0f, 2*contentMargin+titleSize.height+5.0f, 148.0f, 12.0f);
    
    // 根据星级显示五角星
    for (int i=0; i<5; i++) {
        if(i<[articleDetail.rating intValue] && [articleDetail.rating intValue]>=0){
            UIImageView *highStar = [[UIImageView alloc]initWithFrame:CGRectMake(30.0f+i*(11.0f+3.0f), 2.0f, 11.0f, 10.0f)];
            [highStar setImage:[UIImage imageNamed:@"star_highlighted"]];
            [self.ratingView addSubview:highStar];
            NSLog(@"1");
        }else{
            UIImageView *normalStar = [[UIImageView alloc]initWithFrame:CGRectMake(30.0f+i*(11.0f+3.0f), 2.0f, 11.0f, 10.0f)];
            [normalStar setImage:[UIImage imageNamed:@"star_normal"]];
            [self.ratingView addSubview:normalStar];
            NSLog(@"0");
        }
        
    }
    
    // 根据时间算出来几小时前
    NSDate *oldDate = [NSDate dateWithTimeIntervalSince1970:[articleDetail.time doubleValue]];
    //获取randomDate和当前时间的时间差
    NSTimeInterval time = [oldDate timeIntervalSinceNow];
    if(time <60){
        _authorLabel.text = [[NSString alloc]initWithFormat:@"%@ 刚刚",articleDetail.author];
    }else if (time<3600){
        int minute = time/60;
        //        NSLog(@"%d分钟前",minute);
        _authorLabel.text = [[NSString alloc]initWithFormat:@"%@ %d分钟前",articleDetail.author, minute];
    }else if (time<3600*24){
        int hour = time/3600;
        //        NSLog(@"%d小时前",hour);
        _authorLabel.text = [[NSString alloc]initWithFormat:@"%@ %d小时前",articleDetail.author, hour];
    }
    
    self.authorLabel.frame = CGRectMake(160.0f, 2*contentMargin+titleSize.height+5.0f, 148.0f, 14.0f);
    
    // 显示html片段
    NSString *HTMLData = articleDetail.content;
    [self.webView loadHTMLString:HTMLData baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    [self setNeedsLayout];
    
    self.webView.frame = CGRectMake(margin,  2*contentMargin+titleSize.height+5.0f+15.0f+gap, width - 2*margin, 100.0f);
    
    self.ratingView.frame = CGRectMake(12.0f, 2*contentMargin+titleSize.height+5.0f+15.0f+gap+100.0f+50.0f, width - 24.0f, 14.0f);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView { //webview 自适应高度
    CGFloat width = CGRectGetWidth(self.bounds);
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    CGFloat height = CGRectGetHeight(frame);
    webViewHeight = height;
    
    // 做一些布局的调整
    self.ratingView.frame = CGRectMake(12.0f, 2*contentMargin+15.0f+5.0f+15.0f+gap+height+50.0f, width - 24.0f, 14.0f);
    self.contentView.frame = CGRectMake(0.0f, margin+(width-2*margin)*17/30, width - 2*margin,margin+(width-2*margin)*17/30+2*contentMargin+15.0f+5.0f+15.0f+gap+height+50.0f+30.0f);
}

+ (CGSize)calculateCellSizeWithArticleDetail:(TSWArticleDetail *)articleDetail containerWidth:(CGFloat)containerWidth
{
    CGFloat width = containerWidth;
    CGFloat height = margin+(width-2*margin)*17/30+2*contentMargin+15.0f+5.0f+15.0f+gap+webViewHeight+50.0f+14.0f+30.0f;
    return CGSizeMake(containerWidth, height);
}

@end
