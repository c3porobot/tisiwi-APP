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
#import "LHBCopyLabel.h"

@interface TSWOtherDetailViewController () <MFMailComposeViewControllerDelegate>
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
@property (nonatomic, strong) UILabel *weixinLabel;
@property (nonatomic, strong) UILabel *weixinContent;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *phoneContent;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *emailContent;
@property (nonatomic, strong) UILabel *lineOne;
@property (nonatomic, strong) UILabel *lineTwo;
@property (nonatomic, strong) UILabel *refererContent;
@property (nonatomic, strong) UILabel *lineThree;

@property (nonatomic, strong) UILabel *sucessfulCase; //成功案例
@property (nonatomic, strong) UILabel *sucessfulContent;
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

@property (nonatomic, strong) UILabel *personInfo;
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
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height-self.navigationBarHeight)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    //头部
    //_headerView = [[UIView alloc]initWithFrame:CGRectMake(15.0f, 22.0f, width-2*15.0f, 22.0f)];
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 22, (width-2*15.0f)/2, 22.0f)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = RGB(90, 90, 90);
    _nameLabel.font = [UIFont systemFontOfSize:22.0f];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.text = @"";
    [_scrollView addSubview:_nameLabel];

    _positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 15, width, 15)];
    _positionLabel.textAlignment = NSTextAlignmentLeft;
    _positionLabel.textColor = RGB(127, 127, 127);
    _positionLabel.font = [UIFont systemFontOfSize:15];
    _positionLabel.backgroundColor = [UIColor clearColor];
    _positionLabel.text = @"";
    [_scrollView addSubview:_positionLabel];
    
    _locationLabel = [[UILabel alloc] init];
    
    /**
     * 联系人界面
     */
    self.weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.positionLabel.frame) + 30, 50, 20)];
    _weixinLabel.textAlignment = NSTextAlignmentLeft;
    _weixinLabel.textColor = RGB(90, 90, 90);
    _weixinLabel.font = [UIFont systemFontOfSize:16.0f];
    _weixinLabel.backgroundColor = [UIColor clearColor];
    _weixinLabel.text = @"微信";
    [_scrollView addSubview:_weixinLabel];
    
    _weixinContent = [[LHBCopyLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.weixinLabel.frame), CGRectGetMinY(self.weixinLabel.frame), width - CGRectGetWidth(self.weixinLabel.frame) - 80, 20)];
    _weixinContent.textAlignment = NSTextAlignmentLeft;
    _weixinContent.textColor = RGB(155, 155, 155);
    _weixinContent.font = [UIFont systemFontOfSize:15.0f];
    _weixinContent.backgroundColor = [UIColor clearColor];
    _weixinContent.text = @"";
    [_scrollView addSubview:_weixinContent];
    
    self.wechatBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.weixinContent.frame), CGRectGetMinY(self.weixinContent.frame) - 10, 40, 40)];
    _wechatBtn.backgroundColor = [UIColor clearColor];
    [_wechatBtn setImage:[UIImage imageNamed:@"btn_copy"] forState:UIControlStateNormal];
    [_wechatBtn addTarget:self action:@selector(wechat:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_wechatBtn];
    
    
    self.lineOne = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.weixinLabel.frame) + 15, width - 30, 0.5)];
    _lineOne.backgroundColor = RGB(155, 155, 155);
    [_scrollView addSubview:_lineOne];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.weixinLabel.frame), CGRectGetMaxY(_lineOne.frame) + 15, 50, 20)];
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    _phoneLabel.textColor = RGB(90, 90, 90);
    _phoneLabel.font = [UIFont systemFontOfSize:16.0f];
    _phoneLabel.backgroundColor = [UIColor clearColor];
    _phoneLabel.text = @"手机";
    [_scrollView addSubview:_phoneLabel];
    
    _phoneContent = [[LHBCopyLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneLabel.frame), CGRectGetMinY(self.phoneLabel.frame), width - CGRectGetWidth(self.phoneLabel.frame) - 80, 20)];
    _phoneContent.textAlignment = NSTextAlignmentLeft;
    _phoneContent.textColor = RGB(155, 155, 155);
    _phoneContent.font = [UIFont systemFontOfSize:15.0f];
    _phoneContent.backgroundColor = [UIColor clearColor];
    _phoneContent.text = @"";
    [_scrollView addSubview:_phoneContent];
    
    self.phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneContent.frame), CGRectGetMinY(self.phoneContent.frame) - 10, 40, 40)];
    _phoneBtn.backgroundColor = [UIColor clearColor];
    [_phoneBtn setImage:[UIImage imageNamed:@"btn_phone"] forState:UIControlStateNormal];
    [_phoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_phoneBtn];
    
    self.lineTwo = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.phoneLabel.frame) + 15, width - 30, 0.5)];
    _lineTwo.backgroundColor = RGB(155, 155, 155);
    [_scrollView addSubview:_lineTwo];
    
    _emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.phoneLabel.frame), CGRectGetMaxY(_lineTwo.frame) + 15, 50, 20)];
    _emailLabel.textAlignment = NSTextAlignmentLeft;
    _emailLabel.textColor = RGB(90, 90, 90);
    _emailLabel.font = [UIFont systemFontOfSize:16.0f];
    _emailLabel.backgroundColor = [UIColor clearColor];
    _emailLabel.text = @"邮箱";
    [_scrollView addSubview:_emailLabel];
    
    _emailContent = [[LHBCopyLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.emailLabel.frame), CGRectGetMinY(self.emailLabel.frame), width - CGRectGetWidth(self.emailLabel.frame) - 80, 20)];
    _emailContent.textAlignment = NSTextAlignmentLeft;
    _emailContent.textColor = RGB(155, 155, 155);
    _emailContent.font = [UIFont systemFontOfSize:15.0f];
    _emailContent.backgroundColor = [UIColor clearColor];
    _emailContent.text = @"";
    [_scrollView addSubview:_emailContent];
    
    self.emailBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.emailContent.frame), CGRectGetMinY(self.emailContent.frame) - 10, 40, 40)];
    _emailBtn.backgroundColor = [UIColor clearColor];
    [_emailBtn setImage:[UIImage imageNamed:@"btn_mail"] forState:UIControlStateNormal];
    [_emailBtn addTarget:self action:@selector(email) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_emailBtn];

    self.lineThree = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.emailLabel.frame) + 15, width - 30, 0.5)];
    _lineThree.backgroundColor = RGB(155, 155, 155);
    [_scrollView addSubview:_lineThree];
    
    /**
     * 天使湾熟络人
     */
    _refererLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.emailLabel.frame), CGRectGetMaxY(self.lineThree.frame) + 15, 110, 15.0f)];
    _refererLabel.textAlignment = NSTextAlignmentLeft;
    _refererLabel.textColor = RGB(90, 90, 90);
    _refererLabel.font = [UIFont systemFontOfSize:16];
    _refererLabel.backgroundColor = [UIColor clearColor];
    _refererLabel.text = @"天使湾熟络人";
    [_scrollView addSubview:_refererLabel];
    
    _refererContent = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.refererLabel.frame), CGRectGetMinY(self.refererLabel.frame), 150, 15)];
    _refererContent.textAlignment = NSTextAlignmentLeft;
    //_refererContent.textColor = [UIColor colorWithRed:33.0f/255.0f green:159.0f/255.0f blue:218.0f/255.0f alpha:1.0f];
    _refererContent.font = [UIFont systemFontOfSize:15];
    _refererContent.textColor = RGB(127, 127, 127);
    _refererContent.text = @"";
    [_scrollView addSubview:_refererContent];
    
    /**
     * 服务地区
     */
    _stepLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.refererLabel.frame), CGRectGetMaxY(self.refererLabel.frame) + 30, 90, 15.0f)];
    _stepLabel.textAlignment = NSTextAlignmentLeft;
    _stepLabel.textColor = RGB(90, 90, 90);
    _stepLabel.font = [UIFont systemFontOfSize:15.0f];
    _stepLabel.backgroundColor = [UIColor clearColor];
    _stepLabel.text = @"服务创业者:";
    [_scrollView addSubview:_stepLabel];
    
    self.stepContent = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.stepLabel.frame), CGRectGetMinY(self.stepLabel.frame), width - CGRectGetMaxX(self.stepLabel.frame), 15.0f)];
    _stepContent.textAlignment = NSTextAlignmentLeft;
    _stepContent.textColor = RGB(127, 127, 127);
    _stepContent.font = [UIFont systemFontOfSize:15.0f];
    _stepContent.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_stepContent];
    
    /**
     * 成功案例
     */
    self.sucessfulCase = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.stepLabel.frame), CGRectGetMaxY(self.stepLabel.frame) + 10, 80, 15)];
    _sucessfulCase.textAlignment = NSTextAlignmentLeft;
    _sucessfulCase.textColor = RGB(90, 90, 90);
    _sucessfulCase.font = [UIFont systemFontOfSize:15.0f];
    _sucessfulCase.backgroundColor = [UIColor clearColor];
    _sucessfulCase.text = @"成功案例:";
    [_scrollView addSubview:_sucessfulCase];
    
    self.sucessfulContent = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.sucessfulCase.frame), CGRectGetMinY(self.sucessfulCase.frame), width - CGRectGetMaxX(self.sucessfulCase.frame), 15)];
    _sucessfulContent.textAlignment = NSTextAlignmentLeft;
    _sucessfulContent.textColor = RGB(127, 127, 127);
    _sucessfulContent.font = [UIFont systemFontOfSize:15.0f];
    _sucessfulContent.backgroundColor = [UIColor clearColor];
    _sucessfulContent.text = @"";
    [_scrollView addSubview:_sucessfulContent];
    
    /**
     *服务标签
     */
    _sampleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.sucessfulCase.frame), CGRectGetMaxY(self.sucessfulCase.frame) + 10, 80, 15.0f)];
    _sampleLabel.textAlignment = NSTextAlignmentLeft;
    _sampleLabel.textColor = RGB(90, 90, 90);
    _sampleLabel.font = [UIFont systemFontOfSize:15.0f];
    _sampleLabel.backgroundColor = [UIColor clearColor];
    _sampleLabel.text = @"服务标签:";
    [_scrollView addSubview:_sampleLabel];
    
    self.sampleContent = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.sampleLabel.frame), CGRectGetMinY(self.sampleLabel.frame), width, 15.0f)];
    _sampleContent.textAlignment = NSTextAlignmentLeft;
    _sampleContent.textColor = RGB(127, 127, 127);
    _sampleContent.font = [UIFont systemFontOfSize:15.0f];
    _sampleContent.backgroundColor = [UIColor clearColor];
    _sampleContent.text = @"";
    [_scrollView addSubview:_sampleContent];
    
    /**
     * 服务介绍
     */
    _fieldLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.sampleLabel.frame), CGRectGetMaxY(self.sampleLabel.frame) + 30, 80, 15.0f)];
    _fieldLabel.textAlignment = NSTextAlignmentLeft;
    _fieldLabel.textColor = RGB(90, 90, 90);
    _fieldLabel.font = [UIFont systemFontOfSize:15.0f];
    _fieldLabel.backgroundColor = [UIColor clearColor];
    _fieldLabel.text = @"服务介绍";
    [_scrollView addSubview:_fieldLabel];
    
    _fieldContent = [[UILabel alloc]initWithFrame:CGRectZero];
    _fieldContent.textAlignment = NSTextAlignmentLeft;
    _fieldContent.textColor = RGB(127, 127, 127);
    _fieldContent.font = [UIFont systemFontOfSize:15.0f];
    _fieldContent.backgroundColor = [UIColor clearColor];
    NSString *titleContent2 = @"";
    _fieldContent.text = titleContent2;
    _fieldContent.numberOfLines = 0;
    [_scrollView addSubview:_fieldContent];
    
    /**
     *  公司介绍
     */
    
    self.personInfo = [[UILabel alloc]initWithFrame:CGRectZero];
    _personInfo.textAlignment = NSTextAlignmentLeft;
    _personInfo.textColor = RGB(90, 90, 90);
    _personInfo.font = [UIFont systemFontOfSize:15.0f];
    _personInfo.backgroundColor = [UIColor clearColor];
    _personInfo.text = @"公司介绍";
    [_scrollView addSubview:_personInfo];
    
    _personContent = [[UILabel alloc]initWithFrame:CGRectZero];
    _personContent.textAlignment = NSTextAlignmentLeft;
    _personContent.textColor = RGB(127, 127, 127);
    _personContent.font = [UIFont systemFontOfSize:15.0f];
    _personContent.backgroundColor = [UIColor clearColor];
    NSString *titleContent = @"";
    _personContent.text = titleContent;
    _personContent.numberOfLines = 0;
    [_scrollView addSubview:_personContent];
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.view.frame), width - 2*15.0f, (width - 2*15.0f)*9/16)];
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.userInteractionEnabled = YES; //打开图片的交互响应
    _faceImageView.backgroundColor = [UIColor clearColor];
//    [_faceImageView setImage:[UIImage imageNamed:@"profile_default"]];
    /**
     *点击进入图片详情界面
     */
//    UITapGestureRecognizer *tapFaceImage1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoFaceImageDetail:)];
//    [_faceImageView addGestureRecognizer:tapFaceImage1];
    [_scrollView addSubview:_faceImageView];
    
    /**
     * 下边三个按钮
     */
    _scrollView.contentSize = CGSizeMake(width, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+5*(12.0f+5.0f)+15.0f+15.0f+15.0f+60.0f);
//    
//    self.sendEmail = [[TSWSendEmail alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[[EMAIL stringByAppendingString:self.type] stringByAppendingString:@"/"] stringByAppendingString:self.sid] stringByAppendingString:@"/mail_attachment"]];
//    
//    [self.sendEmail addObserver:self
//                     forKeyPath:kResourceLoadingStatusKeyPath
//                        options:NSKeyValueObservingOptionNew
//                        context:nil];
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
    _weixinContent.text = [NSString stringWithFormat:@"%@", otherDetal.wechat];
    _phoneContent.text = [NSString stringWithFormat:@"%@", otherDetal.tel];
    _emailContent.text = [NSString stringWithFormat:@"%@", otherDetal.email];
    _nameLabel.text = otherDetal.name;

    
    NSString *cityName = @"";
    NSArray *provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    for (int i=0; i<[provinces count]; i++) {
        NSArray *cities = [[provinces objectAtIndex:i] objectForKey:@"cities"];
        for(int j=0; j<[cities count];j++){
            NSString *code = [[cities objectAtIndex:j] objectForKey:@"code"];
            if([code isEqualToString: otherDetal.cityCode]){
                _locationLabel.text = [[cities objectAtIndex:j] objectForKey:@"CityName"];
                
                _positionLabel.text = [NSString stringWithFormat:@"%@ · %@    %@", otherDetal.company,otherDetal.title, _locationLabel.text];
                _positionLabel.numberOfLines = 0;
                CGSize titleSize6 = [_positionLabel.text boundingRectWithSize:CGSizeMake(width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
                _positionLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 15, width - 30, titleSize6.height);
                cityName = [[cities objectAtIndex:j] objectForKey:@"CityName"];
                break;
            }
        }
    }
    
    if ([otherDetal.served_aera isEqualToString:@""] || [otherDetal.served_aera length] == 0) {
        _stepContent.text = @"暂无";
    } else {
        _stepContent.text = otherDetal.served_aera; //服务地区
        _stepContent.numberOfLines = 0;
        CGSize titleSize3 = [otherDetal.served_aera boundingRectWithSize:CGSizeMake(width - CGRectGetWidth(self.stepLabel.frame) - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        _stepContent.frame = CGRectMake(CGRectGetMaxX(self.stepLabel.frame), CGRectGetMinY(self.stepLabel.frame) - 2, titleSize3.width, titleSize3.height);
    }
    
    if ([otherDetal.cases isEqualToString:@""] || [otherDetal.cases length] == 0) {
        _sucessfulContent.text = @"暂无";
    } else {
        _sucessfulContent.text = otherDetal.cases;
        _sucessfulContent.numberOfLines = 0;
        self.sucessfulCase.frame = CGRectMake(CGRectGetMinX(self.stepLabel.frame), CGRectGetMaxY(self.stepLabel.frame) + 10, 80, 15);
        CGSize titleSize5 = [otherDetal.cases boundingRectWithSize:CGSizeMake(width - CGRectGetWidth(self.sucessfulCase.frame) - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        _sucessfulContent.frame = CGRectMake(CGRectGetMaxX(self.sucessfulCase.frame), CGRectGetMinY(self.sucessfulCase.frame) - 2, titleSize5.width, titleSize5.height);
    }
    
    if ([otherDetal.tags isEqualToString:@""] || [otherDetal.tags length] == 0) {
        _sampleContent.text = @"暂无";
    } else {
        _sampleContent.text = otherDetal.tags; //标签
        _sampleContent.numberOfLines = 0;
        _sampleLabel.frame = CGRectMake(CGRectGetMinX(self.sucessfulCase.frame), CGRectGetMaxY(self.sucessfulCase.frame) + 10, 80, 15.0f);
        CGSize titleSize4 = [otherDetal.tags boundingRectWithSize:CGSizeMake(width - CGRectGetWidth(self.sampleLabel.frame) - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        _sampleContent.frame = CGRectMake(CGRectGetMaxX(self.sampleLabel.frame), CGRectGetMinY(self.sampleLabel.frame) - 2, titleSize4.width, titleSize4.height);
    }
    _refererContent.text = otherDetal.referrer;
    
   
    
    
    _fieldContent.text = otherDetal.introduction;
    _fieldContent.numberOfLines = 0;
    CGSize titleSize2 = [otherDetal.introduction boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _fieldContent.frame = CGRectMake(CGRectGetMinX(self.fieldLabel.frame), CGRectGetMaxY(self.fieldLabel.frame) + 10, titleSize2.width, titleSize2.height);
    
    self.personInfo.frame = CGRectMake(CGRectGetMinX(self.fieldLabel.frame), CGRectGetMaxY(self.fieldContent.frame) + 30, 80, 15.0f);
    _personContent.text = otherDetal.companyIntroduction;
    _personContent.numberOfLines = 0;
    CGSize titleSize = [otherDetal.companyIntroduction boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _personContent.frame = CGRectMake(CGRectGetMinX(self.personInfo.frame), CGRectGetMaxY(self.personInfo.frame) + 10, titleSize.width, titleSize.height);

    _scrollView.contentSize = CGSizeMake(width, 22.0f+CGRectGetHeight(_headerView.frame)+CGRectGetHeight(self.positionLabel.frame) + CGRectGetHeight(self.refererLabel.frame) + CGRectGetHeight(self.refererLabel.frame) + CGRectGetHeight(self.weixinLabel.frame) + CGRectGetHeight(self.phoneLabel.frame) + CGRectGetHeight(self.emailLabel.frame) + CGRectGetHeight(self.sucessfulCase.frame) + CGRectGetHeight(self.stepLabel.frame) + CGRectGetHeight(self.sampleLabel.frame) + CGRectGetHeight(self.faceImageView.frame) + CGRectGetHeight(self.personInfo.frame) + CGRectGetHeight(self.personContent.frame) + CGRectGetHeight(self.fieldLabel.frame) + CGRectGetHeight(self.fieldContent.frame) + 100);

    if ([otherDetal.wechat isEqualToString:@""] || otherDetal.wechat == nil) {
        _weixinContent.text = @"暂无";
        self.wechatBtn.userInteractionEnabled = NO;
        [self.wechatBtn setImage:[UIImage imageNamed:@"btn_copy_diasble"] forState:UIControlStateNormal];
//            _weixinLabel.frame = CGRectZero;
//            _wechatBtn.frame = CGRectZero;
//            _phoneLabel.frame = CGRectMake(CGRectGetMinX(self.faceImageView.frame), CGRectGetMaxY(self.headerView.frame) + 20, 50, 20);
//            _phoneContent.frame =CGRectMake(CGRectGetMaxX(self.phoneLabel.frame), CGRectGetMinY(self.phoneLabel.frame), width - CGRectGetWidth(self.phoneLabel.frame) - 80, 20);
//            _phoneBtn.frame = CGRectMake(CGRectGetMaxX(self.phoneContent.frame) - 10, CGRectGetMinY(self.phoneContent.frame) - 10, 40, 40);
//            _emailLabel.frame = CGRectMake(CGRectGetMinX(self.faceImageView.frame), CGRectGetMaxY(_lineOne.frame) + 15, 50, 20);
//            _emailContent.frame = CGRectMake(CGRectGetMaxX(self.emailLabel.frame), CGRectGetMinY(self.emailLabel.frame), width - CGRectGetWidth(self.emailLabel.frame) - 80, 20);
//            _emailBtn.frame = CGRectMake(CGRectGetMaxX(self.emailContent.frame) - 10, CGRectGetMinY(self.emailContent.frame) - 10, 40, 40);
//            _lineThree.frame = CGRectZero;
//            _refererLabel.frame = CGRectMake(CGRectGetMinX(self.faceImageView.frame), CGRectGetMaxY(_lineTwo.frame) + 15, 110, 15);
//            _refererContent.frame = CGRectMake(CGRectGetMaxX(self.refererLabel.frame), CGRectGetMinY(self.refererLabel.frame), 150, 15);
        
        }
    
    if ([otherDetal.email isEqualToString:@""] || otherDetal.email == nil) {
         _emailContent.text = @"暂无";
         self.emailBtn.userInteractionEnabled = NO;
        [self.emailBtn setImage:[UIImage imageNamed:@"btn_mail_diasble"] forState:UIControlStateNormal];
//        _emailLabel.frame = CGRectZero;
//        _emailBtn.frame = CGRectZero;
//        _emailContent.frame = CGRectZero;
//        _lineThree.frame = CGRectZero;
//        _refererLabel.frame = CGRectMake(CGRectGetMinX(self.faceImageView.frame), CGRectGetMaxY(_lineTwo.frame) + 15, 110, 15);
//        _refererContent.frame = CGRectMake(CGRectGetMaxX(self.refererLabel.frame), CGRectGetMinY(self.refererLabel.frame), 150, 15);
//        _stepLabel.frame = CGRectMake(CGRectGetMinX(self.refererLabel.frame), CGRectGetMaxY(self.refererLabel.frame) + 30, 80, 15.0f);
//        self.stepContent.frame = CGRectMake(CGRectGetMaxX(self.stepLabel.frame), CGRectGetMinY(self.stepLabel.frame), width - CGRectGetMaxX(self.stepLabel.frame), 15.0f);
//        self.sucessfulCase.frame = CGRectMake(CGRectGetMinX(self.stepLabel.frame), CGRectGetMaxY(self.stepLabel.frame) + 10, 80, 15);
//        self.sucessfulContent.frame = CGRectMake(CGRectGetMaxX(self.sucessfulCase.frame), CGRectGetMinY(self.sucessfulCase.frame), width - CGRectGetMaxX(self.sucessfulCase.frame), 15);
//        _sampleLabel.frame = CGRectMake(CGRectGetMinX(self.sucessfulCase.frame), CGRectGetMaxY(self.sucessfulCase.frame) + 10, 80, 15.0f);
//        self.sampleContent.frame = CGRectMake(CGRectGetMaxX(self.sampleLabel.frame), CGRectGetMinY(self.sampleLabel.frame), width, 15.0f);
//        _fieldLabel.frame = CGRectMake(CGRectGetMinX(self.sampleLabel.frame), CGRectGetMaxY(self.sampleLabel.frame) + 30, 80, 15.0f);
//        _fieldContent.text = otherDetal.introduction;
//        _fieldContent.numberOfLines = 0;
//        CGSize titleSize2 = [otherDetal.introduction boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
//        _fieldContent.frame = CGRectMake(CGRectGetMinX(self.fieldLabel.frame), CGRectGetMaxY(self.fieldLabel.frame) + 10, titleSize2.width, titleSize2.height);
//        self.personInfo.frame = CGRectMake(CGRectGetMinX(self.fieldLabel.frame), CGRectGetMaxY(self.fieldContent.frame) + 30, 80, 15.0f);
//        _personContent.text = otherDetal.companyIntroduction;
//        _personContent.numberOfLines = 0;
//        CGSize titleSize = [otherDetal.companyIntroduction boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
//        _personContent.frame = CGRectMake(CGRectGetMinX(self.personInfo.frame), CGRectGetMaxY(self.personInfo.frame) + 10, titleSize.width, titleSize.height);
//         _scrollView.contentSize = CGSizeMake(width, 22.0f+CGRectGetHeight(_headerView.frame)+CGRectGetHeight(self.positionLabel.frame) + CGRectGetHeight(self.refererLabel.frame) + CGRectGetHeight(self.refererLabel.frame) + CGRectGetHeight(self.weixinLabel.frame) + CGRectGetHeight(self.phoneLabel.frame) + CGRectGetHeight(self.emailLabel.frame) + CGRectGetHeight(self.sucessfulCase.frame) + CGRectGetHeight(self.stepLabel.frame) + CGRectGetHeight(self.sampleLabel.frame) + CGRectGetHeight(self.faceImageView.frame) + CGRectGetHeight(self.personInfo.frame) + CGRectGetHeight(self.personContent.frame) + CGRectGetHeight(self.fieldLabel.frame) + CGRectGetHeight(self.fieldContent.frame) + 100);
    }

    if ([otherDetal.tel isEqualToString:@""] || otherDetal.tel == nil) {
        self.phoneContent.text = @"暂无";
        self.phoneBtn.userInteractionEnabled = NO;
        [self.phoneBtn setImage:[UIImage imageNamed:@"btn_phone_diasble"] forState:UIControlStateNormal];
    }
    if(otherDetal.card){
        [[CXImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:otherDetal.card] image:^(UIImage *image, NSError *error) {
            _faceImageView.image = image;
        }];
        _faceImageView.frame = CGRectMake(15.0f, CGRectGetMaxY(self.personContent.frame) + 15, width - 2*15.0f, (width - 2*15.0f)*9/16);
        _scrollView.contentSize = CGSizeMake(width, 22.0f+CGRectGetHeight(_headerView.frame)+CGRectGetHeight(self.positionLabel.frame) + CGRectGetHeight(self.refererLabel.frame) + CGRectGetHeight(self.refererLabel.frame) + CGRectGetHeight(self.weixinLabel.frame) + CGRectGetHeight(self.phoneLabel.frame) + CGRectGetHeight(self.emailLabel.frame) + CGRectGetHeight(self.sucessfulCase.frame) + CGRectGetHeight(self.stepLabel.frame) + CGRectGetHeight(self.sampleLabel.frame) + CGRectGetHeight(self.faceImageView.frame) + CGRectGetHeight(self.personInfo.frame) + CGRectGetHeight(self.personContent.frame) + CGRectGetHeight(self.fieldLabel.frame) + CGRectGetHeight(self.fieldContent.frame) + 300);
        /**
         *点击进入图片详情界面
         */
        UITapGestureRecognizer *tapFaceImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoFaceImageDetail:)];
        [_faceImageView addGestureRecognizer:tapFaceImage];
        
    }
    

}
#pragma mark -- 按钮点击事件
-(void) call{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_otherDetail.tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void) email{
//    [self.sendEmail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"serviceType":self.type,@"sid":self.sid}];
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    if([MFMailComposeViewController canSendMail]){
        [controller setSubject:@" "];
        [controller setMessageBody:@" " isHTML:NO];
        NSArray *toRecipients = [NSArray arrayWithObject:_otherDetail.email];
        [controller setToRecipients: toRecipients];
//        [self presentModalViewController:controller animated:YES];
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"亲，您还没有设置邮件账户" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }

}

- (void) wechat:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已复制微信号" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.weixinContent.text;
    [alertView show];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
