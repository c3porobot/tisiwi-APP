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
@interface TSWFinanceDetailViewController ()
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

@property (nonatomic, strong) UILabel *wechatLabel; //微信
@property (nonatomic, strong) UILabel *phoneLabel;  //手机
@property (nonatomic, strong) UILabel *emailLabel;  //邮箱

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
@end

@implementation TSWFinanceDetailViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)dealloc
{
    [_financeDetail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_sendZan removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_sendEmail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (instancetype)initWithFinanceId:(NSString *)financeId {
    self = [super init];
    if (self) {
        self.sid = financeId;
        
        self.financeDetail = [[TSWFinanceDetail alloc] initWithBaseURL:TSW_API_BASE_URL path:[[FINANCE_DETAIL stringByAppendingString:@"/"] stringByAppendingString:self.sid]];
        
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
    
    
    /**
     *添加联系人信息代码
     */
    UILabel *contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,  22.0f+CGRectGetHeight(_headerView.frame)+28.0f + 15, width-2*15.0f, 12)];
    contactLabel.textAlignment = NSTextAlignmentLeft;
    contactLabel.textColor = RGB(127, 127, 127);
    contactLabel.font = [UIFont systemFontOfSize:12.0f];
    contactLabel.backgroundColor = [UIColor clearColor];
    contactLabel.text = @"联系方式:";
    [_scrollView addSubview:contactLabel];
    
    self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(contactLabel.frame) + 5, width-2*20.0f, 12)];
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    _phoneLabel.textColor = RGB(155, 155, 155);
    _phoneLabel.font = [UIFont systemFontOfSize:12.0f];
    _phoneLabel.backgroundColor = [UIColor clearColor];
    _phoneLabel.text = @"手机:";
    _phoneLabel.numberOfLines = 0;
    [_scrollView addSubview:_phoneLabel];
    
    //self.wechatLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(contactLabel.frame) + 5, width-2*20.0f, 12)];
    self.wechatLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.phoneLabel.frame) + 5, width-2*20.0f, 12)];
    _wechatLabel.textAlignment = NSTextAlignmentLeft;
    _wechatLabel.textColor = RGB(155, 155, 155);
    _wechatLabel.font = [UIFont systemFontOfSize:12.0f];
    _wechatLabel.backgroundColor = [UIColor clearColor];
    _wechatLabel.text = @"微信:";
    _wechatLabel.numberOfLines = 0;
    [_scrollView addSubview:_wechatLabel];
    
    
    self.emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.wechatLabel.frame) + 5, width-2*20.0f, 12)];
    _emailLabel.textAlignment = NSTextAlignmentLeft;
    _emailLabel.textColor = RGB(155, 155, 155);
    _emailLabel.font = [UIFont systemFontOfSize:12.0f];
    _emailLabel.backgroundColor = [UIColor clearColor];
    _emailLabel.text = @"邮箱";
    _emailLabel.numberOfLines = 0;
    [_scrollView addSubview:_emailLabel];
    
    // 分层次介绍
    UILabel *personInfo = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f + 72, width-2*15.0f, 12.0f)];
    personInfo.textAlignment = NSTextAlignmentLeft;
    personInfo.textColor = RGB(127, 127, 127);
    personInfo.font = [UIFont systemFontOfSize:12.0f];
    personInfo.backgroundColor = [UIColor clearColor];
    personInfo.text = @"个人介绍";
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
    
    _fieldLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+(12.0f+5.0f)+titleSize.height+15.0f + 67, width-2*15.0f, 12.0f)];
    _fieldLabel.textAlignment = NSTextAlignmentLeft;
    _fieldLabel.textColor = RGB(127, 127, 127);
    _fieldLabel.font = [UIFont systemFontOfSize:12.0f];
    _fieldLabel.backgroundColor = [UIColor clearColor];
    _fieldLabel.text = @"投资领域";
    [_scrollView addSubview:_fieldLabel];
    
    _fieldContent = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+2*(12.0f+5.0f)+titleSize.height+15.0f + 67, width-2*20.0f, 12.0f)];
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
    
    _stepLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+2*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f + 67, width-2*15.0f, 12.0f)];
    _stepLabel.textAlignment = NSTextAlignmentLeft;
    _stepLabel.textColor = RGB(127, 127, 127);
    _stepLabel.font = [UIFont systemFontOfSize:12.0f];
    _stepLabel.backgroundColor = [UIColor clearColor];
    _stepLabel.text = @"投资阶段";
    [_scrollView addSubview:_stepLabel];
    
    _stepContent = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+3*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f + 67, width-2*20.0f, 12.0f)];
    _stepContent.textAlignment = NSTextAlignmentLeft;
    _stepContent.textColor = RGB(155, 155, 155);
    _stepContent.font = [UIFont systemFontOfSize:12.0f];
    _stepContent.backgroundColor = [UIColor clearColor];
    NSString *titleContent3 = @"";
    _stepContent.text = titleContent3;
    _stepContent.numberOfLines = 0;
    CGSize titleSize3 = [titleContent3 boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _stepContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+3*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f + 67, titleSize3.width, titleSize3.height);
    [_scrollView addSubview:_stepContent];
    
    _sampleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+3*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0f + 67, width-2*15.0f, 12.0f)];
    _sampleLabel.textAlignment = NSTextAlignmentLeft;
    _sampleLabel.textColor = RGB(127, 127, 127);
    _sampleLabel.font = [UIFont systemFontOfSize:12.0f];
    _sampleLabel.backgroundColor = [UIColor clearColor];
    _sampleLabel.text = @"投资案例";
    [_scrollView addSubview:_sampleLabel];
    
    _sampleContent = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+12.0f+4*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F + 67, width-2*20.0f, 12.0f)];
    _sampleContent.textAlignment = NSTextAlignmentLeft;
    _sampleContent.textColor = RGB(155, 155, 155);
    _sampleContent.font = [UIFont systemFontOfSize:12.0f];
    _sampleContent.backgroundColor = [UIColor clearColor];
    NSString *titleContent4 = @"";
    _sampleContent.text = titleContent4;
    _sampleContent.numberOfLines = 0;
    CGSize titleSize4 = [titleContent4 boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _sampleContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+4*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F + 67, titleSize4.width, titleSize4.height);
    [_scrollView addSubview:_sampleContent];
    
    _wayLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+4*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f + 67, width-2*15.0f, 12.0f)];
    _wayLabel.textAlignment = NSTextAlignmentLeft;
    _wayLabel.textColor = RGB(127, 127, 127);
    _wayLabel.font = [UIFont systemFontOfSize:12.0f];
    _wayLabel.backgroundColor = [UIColor clearColor];
    _wayLabel.text = @"申请方式";
    //[_scrollView addSubview:_wayLabel];
    
    _wayContent = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+5*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f + 67, width-2*20.0f, 12.0f)];
    _wayContent.textAlignment = NSTextAlignmentLeft;
    _wayContent.textColor = RGB(155, 155, 155);
    _wayContent.font = [UIFont systemFontOfSize:12.0f];
    _wayContent.backgroundColor = [UIColor clearColor];
    NSString *titleContent5 = @"";
    _wayContent.text = titleContent5;
    _wayContent.numberOfLines = 0;
    CGSize titleSize5 = [titleContent5 boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _wayContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+5*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f + 67, titleSize5.width, titleSize5.height);
    [_scrollView addSubview:_wayContent];
    
    _refererLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+6*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f + 67, width-2*15.0f, 12.0f)];
    _refererLabel.textAlignment = NSTextAlignmentLeft;
    _refererLabel.textColor = RGB(127, 127, 127);
    _refererLabel.font = [UIFont systemFontOfSize:12.0f];
    _refererLabel.backgroundColor = [UIColor clearColor];
    _refererLabel.text = @"天使湾熟络人";
    [_scrollView addSubview:_refererLabel];
    
    _refererContent = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+7*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f + 67, width-2*20.0f, 12.0f)];
    _refererContent.textAlignment = NSTextAlignmentLeft;
    _refererContent.textColor = RGB(155, 155, 155);
    _refererContent.font = [UIFont systemFontOfSize:12.0f];
    _refererContent.backgroundColor = [UIColor clearColor];
    NSString *titleContent6 = @"";
    _refererContent.text = titleContent6;
    _refererContent.numberOfLines = 0;
    CGSize titleSize6 = [titleContent6 boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _refererContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+5*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f+titleSize5.height+15.0f + 67, titleSize6.width, titleSize6.height);
    [_scrollView addSubview:_refererContent];
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+5*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f+titleSize5.height+15.0f+titleSize6.height, width - 2*15.0f, (width - 2*15.0f)*9/16)];
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.userInteractionEnabled = YES; //打开用户交互
    [_faceImageView setImage:[UIImage imageNamed:@"profile_default"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoFaceImageDetail:)];
    [_faceImageView addGestureRecognizer:tap];
    [_scrollView addSubview:_faceImageView];
    
    UIView *btnsView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, height-60.0f, width, 60.0f)];
    btnsView.backgroundColor = RGB(255, 255, 255);
    _phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width / 2, 60.0f)];
    _phoneBtn.backgroundColor = RGB(234, 234, 234);
    [_phoneBtn setImage:[UIImage imageNamed:@"btn_phone_disale"] forState:UIControlStateNormal];
    
    [btnsView addSubview:_phoneBtn];
    _emailBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneBtn.frame), 0.0f, [UIScreen mainScreen].bounds.size.width / 2, 60.0f)];
    _emailBtn.backgroundColor = RGB(234, 234, 234);
    [_emailBtn setImage:[UIImage imageNamed:@"btn_mail_disable"] forState:UIControlStateNormal];
    //[btnsView addSubview:_emailBtn];
    
    _wechatBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneBtn.frame), 0.0f, [UIScreen mainScreen].bounds.size.width / 2, 60.0f)];
    _wechatBtn.backgroundColor = RGB(234, 234, 234);
    [_wechatBtn setImage:[UIImage imageNamed:@"btn_wechat_disable"] forState:UIControlStateNormal];
    [btnsView addSubview:_wechatBtn];
    [self.view addSubview:btnsView];
    
    _scrollView.contentSize = CGSizeMake(width, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+5*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f+titleSize5.height+15.0f+(width-2*15.0f)*9/16+60.0f);
    
    self.sendZan = [[TSWSendZan alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[[ZAN stringByAppendingString:@"financing"] stringByAppendingString:@"/"] stringByAppendingString:self.sid] stringByAppendingString:@"/like"]];
    
    [self.sendZan addObserver:self
                         forKeyPath:kResourceLoadingStatusKeyPath
                            options:NSKeyValueObservingOptionNew
                            context:nil];
    
    self.sendEmail = [[TSWSendEmail alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[[EMAIL stringByAppendingString:@"financing"] stringByAppendingString:@"/"] stringByAppendingString:self.sid] stringByAppendingString:@"/mail_attachment"]];
    
    [self.sendEmail addObserver:self
                   forKeyPath:kResourceLoadingStatusKeyPath
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    [self refreshData];
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
}

- (void) refreshData{
    [self.financeDetail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
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
    _wechatLabel.text = [NSString stringWithFormat:@"微信: %@", financeDetal.wechat];
    _emailLabel.text = [NSString stringWithFormat:@"邮箱: %@", financeDetal.email];
    _phoneLabel.text = [NSString stringWithFormat:@"手机: %@", financeDetal.tel];
    _financeDetail = financeDetal;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    // 布局，塞数据
    _nameLabel.text = financeDetal.name;
    _zanLabel.text = [NSString stringWithFormat:@"%ld",(long)financeDetal.like];
    CGSize size2 = [_zanLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
    _zanImageView.frame = CGRectMake(width - 15.0f - size2.width - 2.0f - 15.0f - 15.0f - 3.0f, 0.0f, 15.0f, 15.0f);
    
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
        }
    }
    
    CGSize size = [cityName sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
    _locationLabel.frame = CGRectMake(width - (15.0f + size2.width + 2.0f + 15.0f + 15.0f+15.0f+size.width), 2.0f, size.width, 12.0f);
    _mapImageView.frame = CGRectMake(width - (15.0f + size2.width + 2.0f + 15.0f + 15.0f+15.0f) - size.width - 3.0f - 11.0f, 2.0f, 11.0f, 15.0f);
    
    _positionLabel.text = [NSString stringWithFormat:@"%@  %@", financeDetal.title, financeDetal.company];
    _personContent.text = financeDetal.introduction;
    _personContent.numberOfLines = 0;
    CGSize titleSize = [financeDetal.introduction boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _personContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+12.0f+5.0f + 72, titleSize.width, titleSize.height);
    
    _fieldLabel.frame = CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+(12.0f+5.0f)+titleSize.height+15.0f + 67, width-2*15.0f, 12.0f);

    _fieldContent.text = financeDetal.domains;
    _fieldContent.numberOfLines = 0;
    CGSize titleSize2 = [financeDetal.domains boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _fieldContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+2*(12.0f+5.0f)+titleSize.height+15.0f + 67, titleSize2.width, titleSize2.height);
    
    _stepLabel.frame = CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+2*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f + 67, width-2*15.0f, 12.0f);
    
    _stepContent.text = financeDetal.rounds;
    _stepContent.numberOfLines = 0;
    CGSize titleSize3 = [financeDetal.rounds boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _stepContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+3*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f + 67, titleSize3.width, titleSize3.height);
    
    _sampleLabel.frame = CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+3*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0f + 67, width-2*15.0f, 12.0f);
    
    _sampleContent.text = financeDetal.cases;
    _sampleContent.numberOfLines = 0;
    CGSize titleSize4 = [financeDetal.cases boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _sampleContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+4*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F + 67, titleSize4.width, titleSize4.height);
    
    _wayLabel.frame = CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+4*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f + 67, width-2*15.0f, 12.0f);
    
    _wayContent.text = financeDetal.applyMethod;
    _wayContent.numberOfLines = 0;
    CGSize titleSize5 = [financeDetal.applyMethod boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _wayContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+5*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f + 67, titleSize5.width, titleSize5.height);
    /**
     *更改推荐高度
     */
    _refererLabel.frame = CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+5*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f+titleSize5.height+15.0f + 67 + 10, width-2*15.0f, 12.0f);
    
    _refererContent.text = financeDetal.referrer;
    _refererContent.numberOfLines = 0;
    CGSize titleSize6 = [financeDetal.referrer boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _refererContent.frame = CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+6*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f+titleSize5.height+15.0f + 67 + 10, titleSize6.width, titleSize6.height);
    
    if (financeDetal.card) {
        [[CXImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:financeDetal.card] image:^(UIImage *image, NSError *error) {
            _faceImageView.image = image;
        }];
        _faceImageView.frame = CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+6*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f+titleSize5.height+15.0f+titleSize6.height+15.0f + 30, width - 2*15.0f, (width - 2*15.0f)*9/16);
    }
    
     _scrollView.contentSize = CGSizeMake(width, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+18.0f+7*(12.0f+5.0f)+titleSize.height+15.0f+titleSize2.height+15.0f+titleSize3.height+15.0F+titleSize4.height+15.0f+titleSize5.height+15.0f+titleSize6.height+15.0f+(width-2*15.0f)*9/16+60.0f);
    
    if(_financeDetail.tel!=nil && ![_financeDetail.tel isEqualToString:@""]){
        [_phoneBtn setImage:[UIImage imageNamed:@"btn_phone_n"] forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    }
    if(_financeDetail.hasAttachment == 1){
        [_emailBtn setImage:[UIImage imageNamed:@"btn_mail_n"] forState:UIControlStateNormal];
        [_emailBtn addTarget:self action:@selector(email) forControlEvents:UIControlEventTouchUpInside];
    }
    if(_financeDetail.wechat!=nil && ![_financeDetail.wechat isEqualToString:@""]){
        [_wechatBtn setImage:[UIImage imageNamed:@"btn_wechat_n"] forState:UIControlStateNormal];
        [_wechatBtn addTarget:self action:@selector(wechat) forControlEvents:UIControlEventTouchUpInside];
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
    [self.sendEmail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"serviceType":@"financing",@"sid":self.sid}];
}

-(void) wechat{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，微信号:" message:_financeDetail.wechat delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

@end

