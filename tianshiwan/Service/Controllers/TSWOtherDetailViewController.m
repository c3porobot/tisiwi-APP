//
//  TSWOtherDetailViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/10/1.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWOtherDetailViewController.h"
#import "TSWOtherDetail.h"
#import "TSWSendZan.h"
#import "TSWSendEmail.h"
#import "CXImageLoader.h"
#import "LHBPicBrowser.h" //放大图片类
@interface TSWOtherDetailViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) TSWOtherDetail *otherDetail;
@property (nonatomic, strong) TSWSendZan *sendZan;
@property (nonatomic, strong) TSWSendEmail *sendEmail;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *zanLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *personContent;
@property (nonatomic, strong) UILabel *fieldContent;
@property (nonatomic, strong) UILabel *stepContent;
@property (nonatomic, strong) UILabel *sampleContent;
@property (nonatomic, strong) UILabel *wayContent;
@property (nonatomic, strong) UILabel *refererContent;

@property (nonatomic, strong) UIImageView *zanImageView;
@property (nonatomic, strong) UIImageView *mapImageView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *fieldLabel;
@property (nonatomic, strong) UILabel *stepLabel;
@property (nonatomic, strong) UILabel *sampleLabel;
@property (nonatomic, strong) UILabel *wayLabel;
@property (nonatomic, strong) UILabel *refererLabel;
@property (nonatomic, strong) UIImageView *faceImageView; //名片图片

@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UIButton *emailBtn;
@property (nonatomic, strong) UIButton *wechatBtn;

@property (nonatomic, strong) NSString *namex;
@end

@implementation TSWOtherDetailViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)dealloc
{
    [_otherDetail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_sendZan removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_sendEmail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (instancetype)initWithType:(NSString *)type OtherId:(NSString *)otherId withName:(NSString *)name{
    self = [super init];
    if (self) {
        self.sid = otherId;
        self.type = type;
        _namex = name;
        
        self.otherDetail = [[TSWOtherDetail alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[OTHER_DETAIL stringByAppendingString:type] stringByAppendingString:@"/"] stringByAppendingString:self.sid]];
        
        [self.otherDetail addObserver:self
                             forKeyPath:kResourceLoadingStatusKeyPath
                                options:NSKeyValueObservingOptionNew
                                context:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.navigationBar.title = _namex;
    self.view.backgroundColor = RGB(234, 234, 234);
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height-self.navigationBarHeight-20.0f)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    //头部
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(15.0f, 22.0f, width-2*15.0f, 14.0f)];
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, (width-2*15.0f)/2, 14.0f)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = RGB(32, 158, 217);
    _nameLabel.font = [UIFont systemFontOfSize:14.0f];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.text = @"";
    [_headerView addSubview:_nameLabel];
    
    _zanLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-15.0f, 2.0f, width/2-15.0f, 12.0f)];
    _zanLabel.textAlignment = NSTextAlignmentRight;
    _zanLabel.textColor = RGB(127, 127, 127);
    _zanLabel.font = [UIFont systemFontOfSize:12.0f];
    _zanLabel.backgroundColor = [UIColor clearColor];
    _zanLabel.text = @"";
    CGSize size2 = [_zanLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
    [_headerView addSubview:_zanLabel];
    _zanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 15.0f - size2.width - 2.0f - 15.0f - 15.0f - 3.0f, 0.0f, 15.0f, 15.0f)];
    _zanImageView.image = [UIImage imageNamed:@"agree"];
    _zanImageView.backgroundColor = [UIColor clearColor];
    [_zanImageView setUserInteractionEnabled:YES];
    _zanImageView.exclusiveTouch = YES;
    UITapGestureRecognizer *zanGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zan)];
    [_zanImageView addGestureRecognizer:zanGesture];
    [_headerView addSubview:_zanImageView];
    
    _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(60.0f+15.0f, 2.0f, width-60.0f-15.0f-(15.0f + size2.width + 2.0f + 15.0f + 15.0f+15.0f), 12.0f)];
    _locationLabel.textAlignment = NSTextAlignmentRight;
    _locationLabel.textColor = RGB(127, 127, 127);
    _locationLabel.font = [UIFont systemFontOfSize:12.0f];
    _locationLabel.backgroundColor = [UIColor clearColor];
    _locationLabel.text = @"";
    CGSize size = [_locationLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
    [_headerView addSubview:_locationLabel];
    _mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - (15.0f + size2.width + 2.0f + 15.0f + 15.0f+15.0f) - size.width - 3.0f - 11.0f, 2.0f, 11.0f, 15.0f)];
    _mapImageView.image = [UIImage imageNamed:@"location"];
    _mapImageView.backgroundColor = [UIColor clearColor];
    
    [_headerView addSubview:_mapImageView];
    
    [_scrollView addSubview:_headerView];
    
    _positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 22.0f+14.0f+8.0f, width - 2*15.0f, 12.0f)];
    _positionLabel.textAlignment = NSTextAlignmentLeft;
    _positionLabel.textColor = RGB(105, 105, 105);
    _positionLabel.font = [UIFont systemFontOfSize:12.0f];
    _positionLabel.backgroundColor = [UIColor clearColor];
    _positionLabel.text = @"";
    [_scrollView addSubview:_positionLabel];
    
    
    // 分层次介绍
    UILabel *personInfo = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f, width-2*15.0f, 12.0f)];
    personInfo.textAlignment = NSTextAlignmentLeft;
    personInfo.textColor = RGB(127, 127, 127);
    personInfo.font = [UIFont systemFontOfSize:12.0f];
    personInfo.backgroundColor = [UIColor clearColor];
    personInfo.text = @"公司介绍:";
    [_scrollView addSubview:personInfo];
    _personContent = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+12.0f+5.0f, width-2*20.0f, 12.0f)];
    _personContent.textAlignment = NSTextAlignmentLeft;
    _personContent.textColor = RGB(155, 155, 155);
    _personContent.font = [UIFont systemFontOfSize:12.0f];
    _personContent.backgroundColor = [UIColor clearColor];
    NSString *titleContent = @"";
    _personContent.text = titleContent;
    _personContent.numberOfLines = 0;
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _personContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+12.0f+5.0f, titleSize.width, titleSize.height);
    [_scrollView addSubview:_personContent];
    
    _fieldLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+(12.0f+5.0f)+titleSize.height+15.0f, width-2*15.0f, 12.0f)];
    _fieldLabel.textAlignment = NSTextAlignmentLeft;
    _fieldLabel.textColor = RGB(127, 127, 127);
    _fieldLabel.font = [UIFont systemFontOfSize:12.0f];
    _fieldLabel.backgroundColor = [UIColor clearColor];
    _fieldLabel.text = @"服务介绍:";
    [_scrollView addSubview:_fieldLabel];
    
    _fieldContent = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+2*(12.0f+5.0f)+titleSize.height+15.0f, width-2*20.0f, 12.0f)];
    _fieldContent.textAlignment = NSTextAlignmentLeft;
    _fieldContent.textColor = RGB(155, 155, 155);
    _fieldContent.font = [UIFont systemFontOfSize:12.0f];
    _fieldContent.backgroundColor = [UIColor clearColor];
    NSString *titleContent2 = @"";
    _fieldContent.text = titleContent2;
    _fieldContent.numberOfLines = 0;
    CGSize titleSize2 = [titleContent2 boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _fieldContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+2*(12.0f+5.0f)+titleSize.height+15.0f, titleSize2.width, titleSize2.height);
    [_scrollView addSubview:_fieldContent];
    
    _wayLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+2*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f, width-2*15.0f, 12.0f)];
    _wayLabel.textAlignment = NSTextAlignmentLeft;
    _wayLabel.textColor = RGB(127, 127, 127);
    _wayLabel.font = [UIFont systemFontOfSize:12.0f];
    _wayLabel.backgroundColor = [UIColor clearColor];
    _wayLabel.text = @"申请方式:";
   // [_scrollView addSubview:_wayLabel];
    
    _wayContent = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+3*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f, width-2*20.0f, 12.0f)];
    _wayContent.textAlignment = NSTextAlignmentLeft;
    _wayContent.textColor = RGB(155, 155, 155);
    _wayContent.font = [UIFont systemFontOfSize:12.0f];
    _wayContent.backgroundColor = [UIColor clearColor];
    NSString *titleContent5 = @"";
    _wayContent.text = titleContent5;
    _wayContent.numberOfLines = 0;
    CGSize titleSize5 = [titleContent5 boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _wayContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+3*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f, titleSize5.width, titleSize5.height);
    //[_scrollView addSubview:_wayContent];
    
    _refererLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+3*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize5.height+15.0f, width-2*15.0f, 12.0f)];
    _refererLabel.textAlignment = NSTextAlignmentLeft;
    _refererLabel.textColor = RGB(127, 127, 127);
    _refererLabel.font = [UIFont systemFontOfSize:12.0f];
    _refererLabel.backgroundColor = [UIColor clearColor];
    _refererLabel.text = @"天使湾熟络人:";
    [_scrollView addSubview:_refererLabel];
    
    _refererContent = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+4*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize5.height+15.0f, width-2*20.0f, 12.0f)];
    _refererContent.textAlignment = NSTextAlignmentLeft;
    _refererContent.textColor = RGB(155, 155, 155);
    _refererContent.font = [UIFont systemFontOfSize:12.0f];
    _refererContent.backgroundColor = [UIColor clearColor];
    NSString *titleContent6 = @"";
    _refererContent.text = titleContent6;
    _refererContent.numberOfLines = 0;
    CGSize titleSize6 = [titleContent6 boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _refererContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame) + 28.0f + 18.0f + 5 * (12.0f + 5.0f) + titleSize.height + 15.0f + titleSize2.height + 15.0f + titleSize5.height + 15.0f + titleSize5.height + 15.0f, titleSize6.width, titleSize6.height);
    [_scrollView addSubview:_refererContent];
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+4*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize5.height+15.0f+titleSize6.height, width - 2*15.0f, (width - 2*15.0f)*9/16)];
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.userInteractionEnabled = YES; //打开图片的交互响应
    [_faceImageView setImage:[UIImage imageNamed:@"profile_default"]];
    /**
     *点击进入图片详情界面
     */
//    UITapGestureRecognizer *tapFaceImage1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoFaceImageDetail:)];
//    [_faceImageView addGestureRecognizer:tapFaceImage1];
    [_scrollView addSubview:_faceImageView];
    
    /**
     * 下边三个按钮
     */
    UIView *btnsView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, height-60.0f, width, 60.0f)];
    btnsView.backgroundColor = RGB(255, 255, 255);
    _phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, (width-4*2.0f)/3, 60.0f)];
    _phoneBtn.backgroundColor = RGB(234, 234, 234);
    [_phoneBtn setImage:[UIImage imageNamed:@"phone_disabled"] forState:UIControlStateNormal];
    
    [btnsView addSubview:_phoneBtn];
    _emailBtn = [[UIButton alloc]initWithFrame:CGRectMake((width-4*2.0f)/3+4.0f, 0.0f, (width-4*2.0f)/3, 60.0f)];
    _emailBtn.backgroundColor = RGB(234, 234, 234);
    [_emailBtn setImage:[UIImage imageNamed:@"download_disabled"] forState:UIControlStateNormal];
    
    [btnsView addSubview:_emailBtn];
    
    _wechatBtn = [[UIButton alloc]initWithFrame:CGRectMake(2*((width-4*2.0f)/3+4.0f), 0.0f, (width-4*2.0f)/3, 60.0f)];
    _wechatBtn.backgroundColor = RGB(234, 234, 234);
    [_wechatBtn setImage:[UIImage imageNamed:@"wechat_disabled"] forState:UIControlStateNormal];
    
    [btnsView addSubview:_wechatBtn];
    
    [self.view addSubview:btnsView];
    
    _scrollView.contentSize = CGSizeMake(width, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+5*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize5.height+15.0f+60.0f);
    
    self.sendZan = [[TSWSendZan alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[[ZAN stringByAppendingString:self.type] stringByAppendingString:@"/"] stringByAppendingString:self.sid] stringByAppendingString:@"/like"]];
    
    [self.sendZan addObserver:self
                   forKeyPath:kResourceLoadingStatusKeyPath
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    self.sendEmail = [[TSWSendEmail alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[[EMAIL stringByAppendingString:self.type] stringByAppendingString:@"/"] stringByAppendingString:self.sid] stringByAppendingString:@"/mail_attachment"]];
    
    [self.sendEmail addObserver:self
                     forKeyPath:kResourceLoadingStatusKeyPath
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    
    [self refreshData];
}

#pragma mark -- 跳转进入图片放大界面
- (void)gotoFaceImageDetail:(UIGestureRecognizer *)sender {
    [LHBPicBrowser showImage:self.faceImageView];//调用方法
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    if (!self.contactDetail.isLoaded) {
    //        [self.contactDetail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
    //    }
}

- (void) refreshData{
    [self.otherDetail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if (object == _otherDetail) {
            if (_otherDetail.isLoaded) {
                [self setDetail:_otherDetail];
            }
            else if (_otherDetail.error) {
                [self showErrorMessage:[_otherDetail.error localizedFailureReason]];
            }
        }else if(object == _sendZan){
            if(_sendZan.isLoaded){
                
                // 客户端直接操作还是刷新页面
                [self refreshData];
            }else if(_sendZan.error){
                [self showErrorMessage:[_sendZan.error localizedFailureReason]];
            }
        }else if(object == _sendEmail){
            if(_sendEmail.isLoaded){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，附件已发送到您的邮箱，请查收" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }else if(_sendEmail.error){
                [self showErrorMessage:[_sendEmail.error localizedFailureReason]];
            }
        }
    }
}

-(void) setDetail:(TSWOtherDetail *)otherDetal{
    _otherDetail = otherDetal;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    // 布局，塞数据
    _nameLabel.text = otherDetal.name;
    _zanLabel.text = [NSString stringWithFormat:@"%ld",(long)otherDetal.like];
    CGSize size2 = [_zanLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
    _zanImageView.frame = CGRectMake(width - 15.0f - size2.width - 2.0f - 15.0f - 15.0f - 3.0f, 0.0f, 15.0f, 15.0f);
    
    NSString *cityName = @"";
    NSArray *provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    for (int i=0; i<[provinces count]; i++) {
        NSArray *cities = [[provinces objectAtIndex:i] objectForKey:@"cities"];
        for(int j=0; j<[cities count];j++){
            NSString *code = [[cities objectAtIndex:j] objectForKey:@"code"];
            if([code isEqualToString: otherDetal.cityCode]){
                _locationLabel.text = [[cities objectAtIndex:j] objectForKey:@"CityName"];
                cityName = [[cities objectAtIndex:j] objectForKey:@"CityName"];
                break;
            }
        }
    }
//    _locationLabel.text = otherDetal.cityName;
    CGSize size = [cityName sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
    _locationLabel.frame = CGRectMake(width - (15.0f + size2.width + 2.0f + 15.0f + 15.0f+15.0f+size.width), 2.0f, size.width, 12.0f);
    _mapImageView.frame = CGRectMake(width - (15.0f + size2.width + 2.0f + 15.0f + 15.0f+15.0f) - size.width - 3.0f - 11.0f, 2.0f, 11.0f, 15.0f);
    
    _positionLabel.text = [NSString stringWithFormat:@"%@  %@", otherDetal.title, otherDetal.company];
    _personContent.text = otherDetal.companyIntroduction;
    _personContent.numberOfLines = 0;
    CGSize titleSize = [otherDetal.companyIntroduction boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _personContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+12.0f+5.0f, titleSize.width, titleSize.height);
    
    _fieldLabel.frame = CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+(12.0f+5.0f)+titleSize.height+15.0f, width-2*15.0f, 12.0f);
    
    _fieldContent.text = otherDetal.introduction;
    _fieldContent.numberOfLines = 0;
    CGSize titleSize2 = [otherDetal.introduction boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _fieldContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+2*(12.0f+5.0f)+titleSize.height+15.0f, titleSize2.width, titleSize2.height);
    
    
    _wayLabel.frame = CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+2*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f, width-2*15.0f, 12.0f);
    _wayContent.text = otherDetal.applyMethod;
    _wayContent.numberOfLines = 0;
    CGSize titleSize5 = [otherDetal.applyMethod boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _wayContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+3*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f, titleSize5.width, titleSize5.height);
    
    _refererLabel.frame = CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+3*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize5.height+15.0f, width-2*15.0f, 12.0f);
    
    _refererContent.text = otherDetal.referrer;
    _refererContent.numberOfLines = 0;
    CGSize titleSize6 = [otherDetal.referrer boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _refererContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+4*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize5.height+15.0f, titleSize6.width, titleSize6.height);
    
    if(otherDetal.card){
        [[CXImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:otherDetal.card] image:^(UIImage *image, NSError *error) {
            _faceImageView.image = image;
        }];
        _faceImageView.frame = CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+4*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize5.height+15.0f+titleSize6.height+15.0f, width - 2*15.0f, (width - 2*15.0f)*9/16);
        /**
         *点击进入图片详情界面
         */
        UITapGestureRecognizer *tapFaceImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoFaceImageDetail:)];
        [_faceImageView addGestureRecognizer:tapFaceImage];
    }
    
    _scrollView.contentSize = CGSizeMake(width, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+5*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize5.height+15.0f+titleSize6.height+(width-2*15.0f)*9/16+15.0f+60.0f);
    
    if(_otherDetail.tel!=nil && ![_otherDetail.tel isEqualToString:@""]){
        [_phoneBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    }
    if(_otherDetail.hasAttachment == 1){
        [_emailBtn setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
        [_emailBtn addTarget:self action:@selector(email) forControlEvents:UIControlEventTouchUpInside];
    }
    if(_otherDetail.wechat!=nil && ![_otherDetail.wechat isEqualToString:@""]){
        [_wechatBtn setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
        [_wechatBtn addTarget:self action:@selector(wechat) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void) call{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_otherDetail.tel];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void) email{
    [self.sendEmail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"serviceType":self.type,@"sid":self.sid}];
}

-(void) wechat{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，微信号:" message:_otherDetail.wechat delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void) zan{
    NSLog(@"zan");
    [self.sendZan loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"serviceType":self.type,@"sid":self.sid}];
}

@end
