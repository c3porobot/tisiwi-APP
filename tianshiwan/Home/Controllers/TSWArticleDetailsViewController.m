//
//  TSWArticleDetailsViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/21.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWArticleDetailsViewController.h"
#import "TSWArticleDetail.h"
#import "TSWArticleDetailCell.h"
#import "TSWRating.h"
#import "CXImageLoader.h"

static const CGFloat margin = 10.0f;
static const CGFloat contentMargin = 16.0f;
static const CGFloat gap = 20.0f;

@interface TSWArticleDetailsViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *labelView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *ratingView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) TSWArticleDetail *articleDetail;
@property (nonatomic, strong) TSWRating *rating;
@property (nonatomic) BOOL isPresent;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic) CGSize titleSize;
@end

@implementation TSWArticleDetailsViewController

- (void)dealloc
{
    [_articleDetail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_rating removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (instancetype)initWithArticleId:(NSString *)articleId {
    self = [super init];
    if (self) {
        self.sid = articleId;
        
        self.articleDetail = [[TSWArticleDetail alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[ARTICLE_DETAIL stringByAppendingString:@"/"] stringByAppendingString:self.sid]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [self.articleDetail addObserver:self
                             forKeyPath:kResourceLoadingStatusKeyPath
                                options:NSKeyValueObservingOptionNew
                                context:nil];
    }
    return self;
}
- (instancetype)initWithArticleId:(NSString *)articleId withPresent:(BOOL)isPresent{
    self = [super init];
    _isPresent = isPresent;
    if (self) {
        self.sid = articleId;
        
        self.articleDetail = [[TSWArticleDetail alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[ARTICLE_DETAIL stringByAppendingString:@"/"] stringByAppendingString:self.sid]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [self.articleDetail addObserver:self
                             forKeyPath:kResourceLoadingStatusKeyPath
                                options:NSKeyValueObservingOptionNew
                                context:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    self.navigationBar.title = @"文章详情";
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, CGRectGetHeight(self.view.bounds)-self.navigationBarHeight)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    if(_isPresent){
        if ([self.navigationController.viewControllers indexOfObject:self] == 0) {
            CGRect dismissButtonFrame = CGRectMake(00.0f, 0.0f, 21.0f, 44.0f);
            
            UIButton *dismissButton = [[UIButton alloc] initWithFrame:dismissButtonFrame];
            dismissButton.backgroundColor = [UIColor clearColor];
            [dismissButton setImage:[UIImage imageNamed:@"back_icon_normal"] forState:UIControlStateNormal];
            [dismissButton setImage:[UIImage imageNamed:@"back_icon_normal"] forState:UIControlStateHighlighted];
            [dismissButton setImageEdgeInsets:UIEdgeInsetsMake(0,10.0f,0,0)];
            [dismissButton setTitle:@" " forState:UIControlStateNormal];
            [dismissButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [dismissButton setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
            [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            
            self.navigationBar.leftButton = dismissButton;
        }

    }
    
    //头部 (文章详情上边的图片)
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, width-2*margin, (width-2*margin)*17/30)];
    self.imageView.image = [UIImage imageNamed:@"banner_default"];
    [_scrollView addSubview:self.imageView];
    
    //下边所有的文字都是在这个视图上的
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, margin+(width-2*margin)*17/30, width - 2*margin, 1100.0f)];
    //self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0,0, width - 2*margin, 1100.0f)];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, 0, width - 2*margin, 15.0f)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor blackColor];
    //标题大小
    self.titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = @"";
    [self.mainView addSubview:self.titleLabel];
    
//    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(margin, contentMargin+15.0f+5.0f, width - 2*margin, 0.5f)];
//    self.lineView.backgroundColor = RGB(206, 206, 206);
    [self.mainView addSubview:self.lineView];
    
    self.labelView = [[UILabel alloc]initWithFrame:CGRectMake(12.0f, margin, 148.0f, 12.0f)];
    [self.mainView addSubview:self.labelView];
    
    self.authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(160.0f, CGRectGetMinY(self.labelView.frame), 296.0f, 14.0f)];
    self.authorLabel.textAlignment = NSTextAlignmentRight;
    self.authorLabel.textColor = RGB(150, 150, 150);
    self.authorLabel.font = [UIFont systemFontOfSize:10.0f];
    self.authorLabel.backgroundColor = [UIColor clearColor];
    self.authorLabel.text = @"";
    [self.mainView addSubview:self.authorLabel];
    
    /**
     *WEBView
     */
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(margin,  contentMargin+15.0f + gap + 50, width - 2*margin, 100.0f)];
    // _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    _webView.delegate = self;
    UIScrollView *scrollView = (UIScrollView *)[[_webView subviews] objectAtIndex:0];
    scrollView.bounces = NO;
    [_webView setScalesPageToFit:NO];
    [self.mainView addSubview:self.webView];
    
    self.ratingView = [[UILabel alloc]initWithFrame:CGRectMake(12.0f, contentMargin+15.0f+gap+100.0f+50.0f, width - 24.0f, 14.0f)];
    UILabel *ratingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 14.0f)];
    ratingLabel.textAlignment = NSTextAlignmentLeft;
    ratingLabel.textColor = RGB(150, 150, 150);
    ratingLabel.font = [UIFont systemFontOfSize:12.0f];
    ratingLabel.backgroundColor = [UIColor clearColor];
    ratingLabel.text = @"评分";
    ratingLabel.backgroundColor = [UIColor whiteColor];
    [self.ratingView addSubview:ratingLabel];
    [self.mainView addSubview:self.ratingView];
    [self.mainView setUserInteractionEnabled:YES];
    [self.ratingView setUserInteractionEnabled:YES];
    self.mainView.exclusiveTouch = YES;
    self.ratingView.exclusiveTouch = YES;
    
    [_scrollView addSubview:self.mainView];
    [self.view addSubview:_scrollView];
    
    self.rating = [[TSWRating alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[RATING stringByAppendingString:self.sid] stringByAppendingString:@"/rate"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self.rating addObserver:self
                         forKeyPath:kResourceLoadingStatusKeyPath
                            options:NSKeyValueObservingOptionNew
                            context:nil];
    
    [self refreshData];
    
}

-(void)dismiss{
    //    [[self getAppdelegate] removeTrackingArrayLastObject];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) refreshData{
    [self.articleDetail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if (object == _articleDetail) {
            if (_articleDetail.isLoaded) {
                [self setDetail:_articleDetail];
            }
            else if (_articleDetail.error) {
                
            }
            else if (_articleDetail.error) {
                [self showErrorMessage:[_articleDetail.error localizedFailureReason]];
            }
        }else if(object == _rating){
            [self hideLoadingView];
            
            if (_rating.isLoaded) {
                _articleDetail.rating = _rating.rating;
                
                // info已评分（而不是alert），尽量避免刷新页面。
                [self refreshData];
            }
            else if (_rating.error) {
                [self showErrorMessage:[_rating.error localizedFailureReason]];
            }
        }
    }
}

- (void)setDetail:(TSWArticleDetail *)articleDetail{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    _articleDetail = articleDetail;
    
    // 设置所有控件的值
    if(articleDetail.imgUrl_3x){
        [[CXImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:articleDetail.imgUrl_3x] image:^(UIImage *image, NSError *error) {
            _imageView.image = image;
        }];
    }
    
    NSString *titleContent = articleDetail.title;
    _titleLabel.text = titleContent;
    _titleLabel.numberOfLines = 0;
    
    
    //文章标题大小
    
    
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width - (margin*2), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]} context:nil].size;
    self.titleSize = titleSize;
    //重新定义标题frame
    _titleLabel.frame = CGRectMake(margin, margin, titleSize.width, titleSize.height);
    
//    self.lineView.frame = CGRectMake(margin, contentMargin+titleSize.height+5.0f, width - 2*margin, 0.5f);
    
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
    //设置标签的frame
    //self.labelView.frame = CGRectMake(12.0f, contentMargin+titleSize.height+5.0f, 148.0f, 12.0f);
    self.labelView.frame = CGRectMake(margin, CGRectGetMaxY(self.titleLabel.frame) + 5, 148, 12);
    
    // 根据星级显示五角星
    for (int i=0; i<5; i++) {
        if(i<[articleDetail.rating intValue] && [articleDetail.rating intValue]>=0){
            UIImageView *highStar = [[UIImageView alloc]initWithFrame:CGRectMake(30.0f+i*(11.0f+3.0f), 2.0f, 11.0f, 10.0f)];
            [highStar setImage:[UIImage imageNamed:@"star_highlighted"]];
            highStar.tag = i+1;
            [highStar setUserInteractionEnabled:YES];
            highStar.exclusiveTouch = YES;
            UITapGestureRecognizer *starGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rating:)];
            [highStar addGestureRecognizer:starGesture];
            [self.ratingView addSubview:highStar];
        }else{
            UIImageView *normalStar = [[UIImageView alloc]init];
            normalStar.frame = CGRectMake(30.0f+i*(11.0f+3.0f), 2.0f, 11.0f, 10.0f);
            normalStar.tag = i+1;
            [normalStar setImage:[UIImage imageNamed:@"star_normal"]];
            [normalStar setUserInteractionEnabled:YES];
            normalStar.exclusiveTouch = YES;
            UITapGestureRecognizer *starGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rating:)];
            [normalStar addGestureRecognizer:starGesture];
            [self.ratingView addSubview:normalStar];
        }
    }
    self.ratingView.frame = CGRectMake(12.0f, contentMargin+titleSize.height+5.0f+15.0f+gap+100.0f+50.0f, width - 24.0f, 14.0f);
    
    /**
     * 时间计算
     */
    // 根据时间算出来几小时前
    NSDate *oldDate = [NSDate dateWithTimeIntervalSince1970:[articleDetail.time doubleValue]];
    //获取randomDate和当前时间的时间差
    NSTimeInterval time = [oldDate timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha=now-time;
    /**
     文章详情时间
     */
    if(cha <60){
//        _authorLabel.text = [[NSString alloc]initWithFormat:@"%@ 刚刚",articleDetail.author];
        _authorLabel.text = [[NSString alloc]initWithFormat:@" 刚刚"];

    }else if (cha<3600){
        int minute = cha/60;
        //        NSLog(@"%d分钟前",minute);
//        _authorLabel.text = [[NSString alloc]initWithFormat:@"%@ %d分钟前",articleDetail.author, minute];
        _authorLabel.text = [[NSString alloc]initWithFormat:@" %d分钟前", minute];

    }else if (cha<3600*24){
        int hour = cha/3600;
        //        NSLog(@"%d小时前",hour);
//        _authorLabel.text = [[NSString alloc]initWithFormat:@"%@ %d小时前",articleDetail.author, hour];
                _authorLabel.text = [[NSString alloc]initWithFormat:@" %d小时前", hour];

    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:oldDate];
//        _authorLabel.text = [[NSString alloc]initWithFormat:@"%@ %@",articleDetail.author, currentDateStr];
        _authorLabel.text = [[NSString alloc] initWithFormat:@"%@", currentDateStr];
    }
    
    self.authorLabel.frame = CGRectMake(12.0f, CGRectGetMinY(self.labelView.frame) , 296.0f, 14.0f);
    
    // 显示html片段
    NSString *HTMLData = articleDetail.content;
    [self.webView loadHTMLString:HTMLData baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView { //webview 自适应高度
    CGFloat width = CGRectGetWidth(self.view.bounds);
    NSString *bodyWidth= [webView stringByEvaluatingJavaScriptFromString: @"document.documentElement.clientWidth"];
    int pageWidth = [bodyWidth intValue];
    CGFloat initialScale = webView.bounds.size.width/pageWidth;
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%d, initial-scale=%f, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", (int)webView.bounds.size.width,initialScale];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    //拦截网页图片  并修改图片大小
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=%f;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.height = myimg.height * (maxwidth/oldwidth);"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);",webView.bounds.size.width]];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    // 自适应高度
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.documentElement.clientHeight"];
    float height = [clientheight_str floatValue];
    //设置到WebView上
    //webView.frame = CGRectMake(margin,  2*contentMargin+self.titleSize.height+5.0f+15.0f+gap, webView.bounds.size.width, height);
    webView.frame = CGRectMake(margin,1.5*contentMargin+self.titleSize.height + 12, webView.bounds.size.width, height);
        // 做一些布局的调整
    self.ratingView.frame = CGRectMake(12.0f, 2*contentMargin+self.titleSize.height+height+50.0f, width - 24.0f, 14.0f);
    //self.mainView.frame = CGRectMake(0.0f, margin+(width-2*margin)*17/30, width, 2*contentMargin+15.0f+5.0f+15.0f+gap+height+50.0f+100.0f);
    self.mainView.frame = CGRectMake(0.0f, margin+(width-2*margin)*17/30, width, 1.5*contentMargin+height+50.0f+100.0f);

//    self.scrollView.contentSize = CGSizeMake(width,margin+(width-2*margin)*17/30+2*contentMargin+15.0f+5.0f+15.0f+gap+height+50.0f+100.0f);
    self.scrollView.contentSize = CGSizeMake(width,margin+(width-2*margin)*17/30+2*contentMargin+height+50.0f+100.0f);

}

-(void)rating:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *view = tap.view;
    NSInteger rating = (NSInteger)view.tag;
    [self.rating loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"id":self.sid, @"rating":[NSString stringWithFormat:@"%ld",(long)rating]}];
    [self showLoadingView];
}


@end

