//
//  TSWFinanceDetailViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWFinanceDetailViewController.h"
#import "TSWFinanceDetailCell.h"
#import "TSWFinanceDetail.h"
#import "TSWSendZan.h"
#import "TSWSendEmail.h"
#import "CXImageLoader.h"
#import "LHBPicBrowser.h"
#import "LHBCopyLabel.h"
#import "TSWFinanceFilterViewController.h"
#import "TSWCollectionList.h"
#import "GVUserDefaults+TSWProperties.h"
#import "TSWPassValue.h"
#import "RDVTabBarController.h"
@interface TSWFinanceDetailViewController () <MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) TSWFinanceDetail *financeDetail;
@property (nonatomic, strong) TSWSendZan *sendZan;
@property (nonatomic, strong) TSWSendEmail *sendEmail;

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

@property (nonatomic, strong) UILabel *weixinLabel;
@property (nonatomic, strong) LHBCopyLabel *weixinContent;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) LHBCopyLabel *phoneContent;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) LHBCopyLabel *emailContent;

@property (nonatomic, strong) UILabel *lineOne;
@property (nonatomic, strong) UILabel *lineTwo;
@property (nonatomic, strong) UILabel *lineThree;
@property (nonatomic, strong) UIImageView *zanImageView;
@property (nonatomic, strong) UIImageView *mapImageView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *fieldLabel;
@property (nonatomic, strong) UILabel *stepLabel;
@property (nonatomic, strong) UILabel *sampleLabel;
@property (nonatomic, strong) UILabel *wayLabel;
@property (nonatomic, strong) UILabel *refererLabel;
@property (nonatomic, strong) UIImageView *faceImageView;

@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UIButton *emailBtn;
@property (nonatomic, strong) UIButton *wechatBtn;

@property (nonatomic, strong) UIButton *collectionBtn;
@property (nonatomic, strong) TSWCollectionList *sendCollection;
@end

@implementation TSWFinanceDetailViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)dealloc
{
    [_financeDetail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_sendZan removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_sendEmail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_sendCollection removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (instancetype)initWithFinanceId:(NSString *)financeId {
    self = [super init];
    if (self) {
        self.sid = financeId;
        
        self.financeDetail = [[TSWFinanceDetail alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[[FINANCE_DETAIL stringByAppendingString:@"/"] stringByAppendingString:self.sid] stringByAppendingString:@"/member/"] stringByAppendingString:[GVUserDefaults standardUserDefaults].member]];
        
        [self.financeDetail addObserver:self
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
    self.navigationBar.title = self.investorName;
    self.view.backgroundColor = RGB(234, 234, 234);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height-self.navigationBarHeight)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    self.collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 50, 20, 44, 44)];
    _collectionBtn.backgroundColor = [UIColor clearColor];
    [_collectionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_collectionBtn addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightButton = _collectionBtn;
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(15.0f, 22.0f, width-2*15.0f, 22.0f)];
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, (width-2*15.0f)/2, 22.0f)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = RGB(90, 90, 90);
    _nameLabel.font = [UIFont systemFontOfSize:22.0f];
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
   // [_headerView addSubview:_zanImageView];
    
    _positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.headerView.frame), CGRectGetMaxY(self.headerView.frame) + 15, width, 15)];
    _positionLabel.textAlignment = NSTextAlignmentLeft;
    _positionLabel.textColor = RGB(127, 127, 127);
    _positionLabel.font = [UIFont systemFontOfSize:15];
    _positionLabel.backgroundColor = [UIColor clearColor];
    _positionLabel.text = @"";
    [_scrollView addSubview:_positionLabel];
    
    _locationLabel = [[UILabel alloc] init];
    [_scrollView addSubview:_headerView];
    
    /**
     * 联系人界面
     */
    self.weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.headerView.frame), CGRectGetMaxY(self.positionLabel.frame) + 30, 50, 20)];
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
    
    _wechatBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.weixinContent.frame), CGRectGetMinY(self.weixinContent.frame) - 10, 40, 40)];
    _wechatBtn.backgroundColor = [UIColor clearColor];
    [_wechatBtn setImage:[UIImage imageNamed:@"btn_copy"] forState:UIControlStateNormal];
    [_wechatBtn addTarget:self action:@selector(wechat) forControlEvents:UIControlEventTouchUpInside];
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
    
    _phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneContent.frame), CGRectGetMinY(self.phoneContent.frame) - 10, 40, 40)];
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
    
    _emailBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.emailContent.frame), CGRectGetMinY(self.emailContent.frame) - 10, 40, 40)];
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
    _refererLabel.font = [UIFont systemFontOfSize:16.0f];
    _refererLabel.backgroundColor = [UIColor clearColor];
    _refererLabel.text = @"天使湾熟络人";
    [_scrollView addSubview:_refererLabel];
    
    _refererContent = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.refererLabel.frame), CGRectGetMinY(self.refererLabel.frame), 150, 15)];
    _refererContent.textAlignment = NSTextAlignmentLeft;
    //_refererContent.textColor = [UIColor colorWithRed:33.0f/255.0f green:159.0f/255.0f blue:218.0f/255.0f alpha:1.0f];
    _refererContent.textColor = RGB(127, 127, 127);
    _refererContent.font = [UIFont systemFontOfSize:15.0f];
    _refererContent.backgroundColor = [UIColor clearColor];
    _refererContent.text = @"";
    [_scrollView addSubview:_refererContent];
    
     /**
     * 投资阶段
     */
    self.stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.refererLabel.frame), CGRectGetMaxY(self.refererLabel.frame) + 30, 80, 15)];
    _stepLabel.textAlignment = NSTextAlignmentLeft;
    _stepLabel.textColor = RGB(90, 90, 90);
    _stepLabel.font = [UIFont systemFontOfSize:15.0f];
    _stepLabel.backgroundColor = [UIColor clearColor];
    _stepLabel.text = @"投资阶段:";
    [_scrollView addSubview:_stepLabel];
    
    self.stepContent = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.stepLabel.frame), CGRectGetMinY(self.stepLabel.frame), width - CGRectGetMaxX(self.stepLabel.frame), 15)];
    _stepContent.textAlignment = NSTextAlignmentLeft;
    _stepContent.textColor = RGB(127, 127, 127);
    _stepContent.font = [UIFont systemFontOfSize:15.0f];
    _stepContent.backgroundColor = [UIColor clearColor];
    _stepContent.text = @"";
    [_scrollView addSubview:_stepContent];
    
    /**
     * 投资领域
     */
    self.fieldLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.stepLabel.frame), CGRectGetMaxY(self.stepLabel.frame) + 15, 80, 15.0f)];
    _fieldLabel.textAlignment = NSTextAlignmentLeft;
    _fieldLabel.textColor = RGB(90, 90, 90);
    _fieldLabel.font = [UIFont systemFontOfSize:15.0f];
    _fieldLabel.backgroundColor = [UIColor clearColor];
    _fieldLabel.text = @"投资领域:";
    [_scrollView addSubview:_fieldLabel];
    
    self.fieldContent = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.stepLabel.frame), CGRectGetMinY(self.fieldLabel.frame), width, 15.0f)];
    _fieldContent.textAlignment = NSTextAlignmentLeft;
    _fieldContent.textColor = RGB(127, 127, 127);
    _fieldContent.font = [UIFont systemFontOfSize:15.0f];
    _fieldContent.backgroundColor = [UIColor clearColor];
    _fieldContent.text = @"";
    [_scrollView addSubview:_fieldContent];
    
    /**
     * 投资案例
     */
    self.sampleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.stepLabel.frame), CGRectGetMaxY(self.fieldLabel.frame) + 15, 80, 15.0f)];
    _sampleLabel.textAlignment = NSTextAlignmentLeft;
    _sampleLabel.textColor = RGB(90, 90, 90);
    _sampleLabel.font = [UIFont systemFontOfSize:15.0f];
    _sampleLabel.backgroundColor = [UIColor clearColor];
    _sampleLabel.text = @"投资案例:";
    [_scrollView addSubview:_sampleLabel];
    
    _sampleContent = [[UILabel alloc]initWithFrame:CGRectZero];
    _sampleContent.textAlignment = NSTextAlignmentLeft;
    _sampleContent.textColor = RGB(127, 127, 127);
    _sampleContent.font = [UIFont systemFontOfSize:15.0f];
    _sampleContent.backgroundColor = [UIColor clearColor];
    NSString *titleContent2 = @"";
    _sampleContent.text = titleContent2;
    _sampleContent.numberOfLines = 0;
    [_scrollView addSubview:_sampleContent];
    
    /**
     *  个人介绍
     */
    
    _personContent = [[UILabel alloc]initWithFrame:CGRectZero];
    _personContent.textAlignment = NSTextAlignmentLeft;
    _personContent.textColor = RGB(127, 127, 127);
    _personContent.font = [UIFont systemFontOfSize:15.0f];
    _personContent.backgroundColor = [UIColor clearColor];
    NSString *titleContent = @"";
    _personContent.text = titleContent;
    _personContent.numberOfLines = 0;
    [_scrollView addSubview:_personContent];
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.emailLabel.frame), CGRectGetMaxY(self.personContent.frame) + 30, width - 2*15.0f, (width - 2*15.0f)*9/16)];
    //_faceImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.userInteractionEnabled = YES; //打开图片的交互响应
    [_faceImageView setImage:[UIImage imageNamed:@"profile_default"]];
    /**
     *点击进入图片详情界面
     */
    [_scrollView addSubview:_faceImageView];
    
    /**
     * 下边三个按钮
     */
    _scrollView.contentSize = CGSizeMake(width, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+5*(12.0f+5.0f)+15.0f+15.0f+15.0f+60.0f);

    
    self.sendEmail = [[TSWSendEmail alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[[EMAIL stringByAppendingString:@"financing"] stringByAppendingString:@"/"] stringByAppendingString:self.sid] stringByAppendingString:@"/mail_attachment"]];
    
    [self.sendEmail addObserver:self
                   forKeyPath:kResourceLoadingStatusKeyPath
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    self.sendCollection = [[TSWCollectionList alloc] initWithBaseURL:TSW_API_BASE_URL path:SEND_COLLECTIONLIST];
    [self.sendCollection addObserver:self forKeyPath:kResourceLoadingStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [self refreshData];
}


#pragma mark -- 收藏按钮
- (void)collection:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
//        [sender setTitle:@"已收藏" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"Favorites_btnp"] forState:UIControlStateNormal];
        [_sendCollection loadDataWithRequestMethodType:kHttpRequestMethodTypePost parameters:@{@"memberid":[GVUserDefaults standardUserDefaults].member, @"type": @"investor", @"storeid": self.sid}];
        [self showSuccessMessage:@"收藏成功"];
    } else {
//        [sender setTitle:@"收藏" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"Favorites_btn"] forState:UIControlStateNormal];
        [_sendCollection loadDataWithRequestMethodType:kHttpRequestMethodTypePost parameters:@{@"memberid":[GVUserDefaults standardUserDefaults].member, @"type": @"investor", @"storeid": self.sid}];
        [self showSuccessMessage:@"取消收藏"];
        
    }
    
}


#pragma mark -- 轻拍手势操作
- (void)gotoFaceImageDetail:(UITapGestureRecognizer *)gesture {
    [LHBPicBrowser showImage:_faceImageView];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    if (!self.contactDetail.isLoaded) {
    //        [self.contactDetail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
    //    }
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
}

- (void) refreshData{
    [self.financeDetail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TSWPassValue sharedValue].serviceValue = 0;

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
        if (object == _financeDetail) {
            if (_financeDetail.isLoaded) {
                [self setDetail:_financeDetail];
            }
            else if (_financeDetail.error) {
                [self showErrorMessage:[_financeDetail.error localizedFailureReason]];
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

-(void) setDetail:(TSWFinanceDetail *)financeDetal{
    _weixinContent.text = [NSString stringWithFormat:@"%@", financeDetal.wechat];
    _emailContent.text = [NSString stringWithFormat:@"%@", financeDetal.email];
    _phoneContent.text = [NSString stringWithFormat:@"%@", financeDetal.tel];
    _financeDetail = financeDetal;
    
    if ([financeDetal.storestatus isEqualToString:@"ok"]) {
//        [self.collectionBtn setTitle:@"已收藏" forState:UIControlStateNormal];
        [self.collectionBtn setImage:[UIImage imageNamed:@"Favorites_btnp"] forState:UIControlStateNormal];
        self.collectionBtn.selected = YES;
    } else if ([financeDetal.storestatus isEqualToString:@"no"]) {
//        [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [self.collectionBtn setImage:[UIImage imageNamed:@"Favorites_btn"] forState:UIControlStateNormal];
        self.collectionBtn.selected = NO;
        
    }
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    // 布局，塞数据
    _nameLabel.text = financeDetal.name;
    
    NSString *cityName = @"";
    NSArray *provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    for (int i=0; i<[provinces count]; i++) {
        NSArray *cities = [[provinces objectAtIndex:i] objectForKey:@"cities"];
        for(int j=0; j<[cities count];j++){
            NSString *code = [[cities objectAtIndex:j] objectForKey:@"code"];
            if([code isEqualToString: financeDetal.cityCode]){
                _locationLabel.text = [[cities objectAtIndex:j] objectForKey:@"CityName"];
                cityName = [[cities objectAtIndex:j] objectForKey:@"CityName"];
                break;
            }
            _positionLabel.text = [NSString stringWithFormat:@"%@ · %@    %@",  financeDetal.company,financeDetal.title, _locationLabel.text];
        }
    }
    
    
    _personContent.text = financeDetal.introduction;
    _personContent.numberOfLines = 0;
        _fieldContent.text = financeDetal.fields; //投资领域
        _fieldContent.numberOfLines = 0;
    _fieldLabel.frame = CGRectMake(CGRectGetMinX(self.stepLabel.frame) ,CGRectGetMaxY(self.stepContent.frame) + 15, 80, 15.0f); //领域新布局
        CGSize titleSize2 = [financeDetal.fields boundingRectWithSize:CGSizeMake(width - 20*2 - CGRectGetWidth(self.fieldLabel.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        _fieldContent.frame = CGRectMake(CGRectGetMaxX(self.fieldLabel.frame), CGRectGetMinY(self.fieldLabel.frame) - 2, titleSize2.width, titleSize2.height);
    /**
     *  布局判断
     */
    
    if ([_financeDetail.domains isEqualToString:@""] || [_financeDetail.domains length] == 0) {
       // _stepLabel.frame = CGRectMake(CGRectGetMinX(self.fieldLabel.frame) ,CGRectGetMaxY(self.fieldLabel.frame) + 15, 80, 15.0f);
    } else {
//        _stepLabel.frame = CGRectMake(CGRectGetMinX(self.fieldLabel.frame) ,CGRectGetMaxY(self.fieldContent.frame) + 15, 80, 15.0f);
    }
        _stepContent.text = financeDetal.rounds;
        _stepContent.numberOfLines = 0;
        CGSize titleSize3 = [financeDetal.rounds boundingRectWithSize:CGSizeMake(width - 20*2- CGRectGetWidth(self.stepLabel.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        _stepContent.frame = CGRectMake(CGRectGetMaxX(self.stepLabel.frame), CGRectGetMinY(self.stepLabel.frame) - 2, titleSize3.width, titleSize3.height);
    if ([_financeDetail.rounds isEqualToString:@""] || [_financeDetail.rounds length] == 0) {
        _sampleLabel.frame = CGRectMake(CGRectGetMinX(self.fieldLabel.frame), CGRectGetMaxY(self.fieldLabel.frame) + 15, 80, 15.0f);
    } else {
        _sampleLabel.frame = CGRectMake(CGRectGetMinX(self.fieldLabel.frame), CGRectGetMaxY(self.fieldContent.frame) + 15, 80, 15.0f);
    }
        _sampleContent.text = financeDetal.cases;
        _sampleContent.numberOfLines = 0;
        CGSize titleSize4 = [financeDetal.cases boundingRectWithSize:CGSizeMake(width - 20*2 - CGRectGetWidth(self.sampleLabel.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        _sampleContent.frame = CGRectMake(CGRectGetMaxX(self.sampleLabel.frame), CGRectGetMinY(self.sampleLabel.frame) - 2, titleSize4.width, titleSize4.height);
    
    if ([_financeDetail.fields isEqualToString:@""] || [_financeDetail.fields length] == 0) {
        _fieldContent.text = @"暂无";
         self.fieldContent.frame = CGRectMake(CGRectGetMaxX(self.fieldLabel.frame), CGRectGetMinY(self.fieldLabel.frame), width - CGRectGetMaxX(self.fieldLabel.frame), 15);
    }
    
    if ([_financeDetail.rounds isEqualToString:@""] || [_financeDetail.rounds length] == 0) {
        _stepContent.text = @"暂无";
        self.stepContent.frame = CGRectMake(CGRectGetMaxX(self.stepLabel.frame), CGRectGetMinY(self.stepLabel.frame), width, 15.0f);
    }
    
    if ([_financeDetail.cases isEqualToString:@""] || [_financeDetail.cases length] == 0) {
        _sampleContent.text = @"暂无";
        _sampleContent.frame = CGRectMake(CGRectGetMaxX(self.sampleLabel.frame), CGRectGetMinY(self.sampleLabel.frame), width, 15);
    }

    /**
     *更改推荐高度
     */
    _refererContent.text = financeDetal.referrer;
    _refererContent.numberOfLines = 0;
    CGSize titleSize = [financeDetal.introduction boundingRectWithSize:CGSizeMake(width - 20 * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _personContent.frame = CGRectMake(CGRectGetMinX(self.sampleLabel.frame), CGRectGetMaxY(self.sampleContent.frame) + 15, titleSize.width, titleSize.height + 30);
    
//    if (financeDetal.card) {
//        [[CXImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:financeDetal.card] image:^(UIImage *image, NSError *error) {
//            _faceImageView.image = image;
//        }];
//       _faceImageView.frame = CGRectMake(15.0f, CGRectGetMaxY(self.personContent.frame) + 15, width - 2*15.0f, (width - 2*15.0f)*9/16);
//        /**
//         *点击进入图片详情界面
//         */
//        UITapGestureRecognizer *tapFaceImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoFaceImageDetail:)];
//        [_faceImageView addGestureRecognizer:tapFaceImage];
//        [self refreshData];
//    }
    if ((![financeDetal.email isEqualToString:@""] || financeDetal.email != nil )&&
        !financeDetal.card) {
        
        _scrollView.contentSize = CGSizeMake(width, CGRectGetHeight(self.nameLabel.frame) + CGRectGetHeight(self.positionLabel.frame) + CGRectGetHeight(self.fieldLabel.frame) + CGRectGetHeight(self.sampleLabel.frame) + CGRectGetHeight(self.refererLabel.frame) + CGRectGetHeight(self.stepLabel.frame) + CGRectGetHeight(self.personContent.frame) + CGRectGetHeight(self.faceImageView.frame) + 100);
    }
    
    if ([financeDetal.wechat isEqualToString:@""] || financeDetal.wechat == nil) {
        _weixinContent.text = @"暂无";
        self.wechatBtn.userInteractionEnabled = NO;
        [self.wechatBtn setImage:[UIImage imageNamed:@"btn_copy_disable"] forState:UIControlStateNormal];
//        _weixinLabel.frame = CGRectZero;
//        _wechatBtn.frame = CGRectZero;
//        _phoneLabel.frame = CGRectMake(CGRectGetMinX(self.headerView.frame), CGRectGetMaxY(self.headerView.frame) + 55, 50, 20);
//        _phoneContent.frame =CGRectMake(CGRectGetMaxX(self.phoneLabel.frame), CGRectGetMinY(self.phoneLabel.frame), width - CGRectGetWidth(self.phoneLabel.frame) - 80, 20);
//        _phoneBtn.frame = CGRectMake(CGRectGetMaxX(self.phoneContent.frame) - 10, CGRectGetMinY(self.phoneContent.frame) - 10, 40, 40);
//        _emailLabel.frame = CGRectMake(CGRectGetMinX(self.faceImageView.frame), CGRectGetMaxY(_lineOne.frame) + 15, 50, 20);
//        _emailContent.frame = CGRectMake(CGRectGetMaxX(self.emailLabel.frame), CGRectGetMinY(self.emailLabel.frame), width - CGRectGetWidth(self.emailLabel.frame) - 80, 20);
//        _emailBtn.frame = CGRectMake(CGRectGetMaxX(self.emailContent.frame) - 10, CGRectGetMinY(self.emailContent.frame) - 10, 40, 40);
//        _lineThree.frame = CGRectZero;
//        _refererLabel.frame = CGRectMake(CGRectGetMinX(self.faceImageView.frame), CGRectGetMaxY(_lineTwo.frame) + 15, 110, 15);
//        _refererContent.frame = CGRectMake(CGRectGetMaxX(self.refererLabel.frame), CGRectGetMinY(self.refererLabel.frame), 150, 15);
//        _fieldLabel.frame = CGRectMake(CGRectGetMinX(self.refererLabel.frame), CGRectGetMaxY(self.refererLabel.frame) + 30, 80, 15.0f);
//        self.fieldContent.frame = CGRectMake(CGRectGetMaxX(self.stepLabel.frame), CGRectGetMinY(self.fieldLabel.frame), width - CGRectGetMaxX(self.fieldLabel.frame), 15.0f);
//        self.stepLabel.frame = CGRectMake(CGRectGetMinX(self.fieldLabel.frame), CGRectGetMaxY(self.fieldLabel.frame) + 10, 80, 15);
//        self.stepContent.frame = CGRectMake(CGRectGetMaxX(self.stepLabel.frame), CGRectGetMinY(self.stepLabel.frame), width - CGRectGetMaxX(self.stepLabel.frame), 15);
//        _sampleLabel.frame = CGRectMake(CGRectGetMinX(self.stepLabel.frame), CGRectGetMaxY(self.stepLabel.frame) + 10, 80, 15.0f);
//        self.sampleContent.frame = CGRectMake(CGRectGetMaxX(self.sampleLabel.frame), CGRectGetMinY(self.sampleLabel.frame), width, 15.0f);
//        
//        _personContent.text = financeDetal.introduction;
//        _personContent.numberOfLines = 0;
//        CGSize titleSize2 = [financeDetal.introduction boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
//        _personContent.frame = CGRectMake(CGRectGetMinX(self.fieldLabel.frame), CGRectGetMaxY(self.sampleContent.frame) + 30, titleSize2.width, titleSize2.height);
//        
//        _scrollView.contentSize = CGSizeMake(width, CGRectGetHeight(self.nameLabel.frame) + CGRectGetHeight(self.positionLabel.frame) + CGRectGetHeight(self.fieldLabel.frame) + CGRectGetHeight(self.sampleLabel.frame) + CGRectGetHeight(self.refererLabel.frame) + CGRectGetHeight(self.stepLabel.frame) + CGRectGetHeight(self.personContent.frame) + CGRectGetHeight(self.faceImageView.frame) + 100);

        
    }
    
    if ([financeDetal.email isEqualToString:@""] || financeDetal.email == nil) {
        _emailContent.text = @"暂无";
        self.emailBtn.userInteractionEnabled = NO;
        [self.emailBtn setImage:[UIImage imageNamed:@"btn_mail_diasble"] forState:UIControlStateNormal];
//        _emailLabel.frame = CGRectZero;
//        _emailBtn.frame = CGRectZero;
//        _emailContent.frame = CGRectZero;
//        _lineThree.frame = CGRectZero;
//        _refererLabel.frame = CGRectMake(CGRectGetMinX(self.faceImageView.frame), CGRectGetMaxY(_lineTwo.frame) + 15, 110, 15);
//        _refererContent.frame = CGRectMake(CGRectGetMaxX(self.refererLabel.frame), CGRectGetMinY(self.refererLabel.frame), 150, 15);
//        _fieldLabel.frame = CGRectMake(CGRectGetMinX(self.refererLabel.frame), CGRectGetMaxY(self.refererLabel.frame) + 30, 80, 15.0f);
//        self.fieldContent.frame = CGRectMake(CGRectGetMaxX(self.stepLabel.frame), CGRectGetMinY(self.fieldLabel.frame), width - CGRectGetMaxX(self.fieldLabel.frame), 15.0f);
//        self.stepLabel.frame = CGRectMake(CGRectGetMinX(self.fieldLabel.frame), CGRectGetMaxY(self.fieldLabel.frame) + 10, 80, 15);
//        self.stepContent.frame = CGRectMake(CGRectGetMaxX(self.stepLabel.frame), CGRectGetMinY(self.stepLabel.frame), width - CGRectGetMaxX(self.stepLabel.frame), 15);
//        _sampleLabel.frame = CGRectMake(CGRectGetMinX(self.stepLabel.frame), CGRectGetMaxY(self.stepLabel.frame) + 10, 80, 15.0f);
//        self.sampleContent.frame = CGRectMake(CGRectGetMaxX(self.sampleLabel.frame), CGRectGetMinY(self.sampleLabel.frame), width, 15.0f);
//
//        _personContent.text = financeDetal.introduction;
//        _personContent.numberOfLines = 0;
//        CGSize titleSize2 = [financeDetal.introduction boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
//        _personContent.frame = CGRectMake(CGRectGetMinX(self.fieldLabel.frame), CGRectGetMaxY(self.sampleContent.frame) + 30, titleSize2.width, titleSize2.height);
//        
//        _scrollView.contentSize = CGSizeMake(width, CGRectGetHeight(self.nameLabel.frame) + CGRectGetHeight(self.positionLabel.frame) + CGRectGetHeight(self.fieldLabel.frame) + CGRectGetHeight(self.sampleLabel.frame) + CGRectGetHeight(self.refererLabel.frame) + CGRectGetHeight(self.stepLabel.frame) + CGRectGetHeight(self.personContent.frame) + CGRectGetHeight(self.faceImageView.frame) + 100);
    }
    if ([_financeDetail.tel isEqualToString:@""] || financeDetal.tel == nil) {
        _phoneContent.text = @"暂无";
        self.phoneBtn.userInteractionEnabled = NO;
        [self.phoneBtn setImage:[UIImage imageNamed:@"btn_phone_disable"] forState:UIControlStateNormal];
    }
    
    if(financeDetal.card){
        [[CXImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:financeDetal.card] image:^(UIImage *image, NSError *error) {
            _faceImageView.image = image;
        }];
        _faceImageView.frame = CGRectMake(15.0f, CGRectGetMaxY(self.personContent.frame) + 15, width - 2*15.0f, (width - 2*15.0f)*9/16);
        _scrollView.contentSize = CGSizeMake(width, CGRectGetHeight(self.nameLabel.frame) + CGRectGetHeight(self.positionLabel.frame) + CGRectGetHeight(self.fieldLabel.frame) + CGRectGetHeight(self.sampleLabel.frame) + CGRectGetHeight(self.refererLabel.frame) + CGRectGetHeight(self.stepLabel.frame) + titleSize.height + titleSize2.height+ titleSize3.height + titleSize4.height +CGRectGetHeight(self.faceImageView.frame) + 300);
        /**
         *点击进入图片详情界面
         */
        UITapGestureRecognizer *tapFaceImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoFaceImageDetail:)];
        [_faceImageView addGestureRecognizer:tapFaceImage];
        
    }
    


}


-(void) zan{
    NSLog(@"zan");
    [self.sendZan loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"serviceType":@"financing",@"sid":self.sid}];
}

-(void) call{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_financeDetail.tel];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void) email{
    //[self.sendEmail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"serviceType":@"financing",@"sid":self.sid}];
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    if([MFMailComposeViewController canSendMail]){
        [controller setSubject:@" "];
        [controller setMessageBody:@" " isHTML:NO];
        NSArray *toRecipients = [NSArray arrayWithObject: _financeDetail.email];
        [controller setToRecipients: toRecipients];
        [self presentModalViewController:controller animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"亲，您还没有设置邮件账户" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }

}
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
-(void) wechat{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已复制微信号" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.weixinContent.text;
    [alertView show];
}

@end

