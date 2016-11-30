//
//  TSWEditMineViewController.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/1/22.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//
#define kInterSpace 15 //间距
#define kLabelHight 50
#import "TSWEditMineViewController.h"
#import "ZButton.h"
#import "TSWProfile.h"
#import "TSWSendProfile.h"
#import "ZHAreaPickerView.h"
#import "UIImageView+WebCache.h"
@interface TSWEditMineViewController ()<UIActionSheetDelegate,UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZHAreaPickerDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *avatarView; //头像视图
@property (nonatomic, strong) UIImageView *avatarImage; //头像
@property (nonatomic, strong) UITextField *nameLabel;
@property (nonatomic, strong) UITextField *commpanyLabel;
@property (nonatomic, strong) UITextField *positionLabel;
@property (nonatomic, strong) UILabel *cityLabel; //城市选择器
@property (nonatomic, strong) UITextField *addressLabel; //自适应
@property (nonatomic, strong) UILabel *addressL;
@property (nonatomic, strong) UIView *addressView; //地址视图(用于自适应)

@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UILabel *phoneL;
@property (nonatomic, strong) UITextField *phoneLabel;
@property (nonatomic, strong) UIView *wechatView;
@property (nonatomic, strong) UILabel *wechatL;
@property (nonatomic, strong) UITextField *wechatLabel;
@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UILabel *emailL;
@property (nonatomic, strong) UITextField *emailLabel;
@property (nonatomic, strong) UIView *projectView;
@property (nonatomic, strong) UILabel *projectL;
@property (nonatomic, strong) UITextField *projectLabel;
@property (nonatomic, strong) UIView *introductionView;
@property (nonatomic, strong) UILabel *introductionL;
@property (nonatomic, strong) UITextField *introductionLabel;

@property (nonatomic, strong) TSWProfile *profile;
@property (nonatomic, strong) TSWSendProfile *sendProfile;
@property (nonatomic, strong) ZHAreaPickerView *locatePicker; //采集器
@property (nonatomic, strong) NSString *selectedCityCode;
@property (nonatomic, strong) UITextView *addressTextView; // 地址输入栏
@property (nonatomic, strong) UITextView *introductionTextView; // 简介输入栏

@property (nonatomic, strong) UIView *grayView;
@end

static NSInteger num = 0;
@implementation TSWEditMineViewController

- (void)viewWillDisappear:(BOOL)animated {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    num = 0;
    // Do any additional setup after loading the view.
    self.navigationBar.title = @"编辑个人资料";
    self.view.backgroundColor = RGB(234, 234, 234);
    //_selectedCityCode = @"";
    [self addRightNavigatorButton];
    [self layoutScrollView];
}
- (void)addRightNavigatorButton
{
    //使用UIButton的子类
    UIButton *rightButton=[[UIButton alloc] initWithFrame :CGRectMake(CGRectGetWidth(self.view.bounds) - 50, 36.5, 48, 12)];
    [rightButton setTitle : @"保存" forState : UIControlStateNormal];
    //[rightButton setImage :[ UIImage imageNamed:@"arrow"] forState : UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14.5f];
    [rightButton setTitleColor :[ UIColor whiteColor ] forState : UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 23)];

    //    [self.navigationBar addSubview :rightButton];
    [self.navigationBar setRightButton:rightButton];
    CGRect backButtonFrame = CGRectMake(0, 0.0f, 21.0f+30.0, 44);
    UIButton *leftButton = [[UIButton alloc] initWithFrame:backButtonFrame];
    [leftButton setImage:[UIImage imageNamed:@"back_icon_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"back_icon_highlighted"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(handlePOP:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 23)];
    self.navigationBar.leftButton.frame = CGRectZero;
    [self.navigationBar setLeftButton:leftButton];
}

- (void)layoutScrollView {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height-self.navigationBarHeight)];
    _scrollView.backgroundColor = RGB(234, 234, 234);
    [self.view addSubview:_scrollView];
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 15, width, 0.5)];
    lineView1.backgroundColor = RGB(228, 228, 228); //线的颜色
    [self.scrollView addSubview:lineView1];
    self.avatarView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView1.frame), width, 100)];
    self.avatarView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:_avatarView];
    
    self.avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(width/2 - 40, 10, 80, 80)];
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.layer.cornerRadius = 40;
    _avatarImage.userInteractionEnabled = YES;//打开用户交互
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]; //轻拍手势
    tap.delegate = self;
    [self.avatarImage addGestureRecognizer:tap];
    
    [self.avatarView addSubview:_avatarImage];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.avatarView.frame) + kInterSpace, width, 0.5)];
    lineView2.backgroundColor = RGB(228, 228, 228); //线的颜色
    [self.scrollView addSubview:lineView2];
    
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView2.frame), width,kLabelHight)];
    nameView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:nameView];
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    nameL.text = @"姓名";
    nameL.font = [UIFont systemFontOfSize:17];
    [nameView addSubview:nameL];
    
    self.nameLabel = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameL.frame) + 5, CGRectGetMinY(nameL.frame), width - CGRectGetWidth(nameL.frame), CGRectGetHeight(nameL.frame))];
    //self.nameLabel.delegate = self;
    self.nameLabel.backgroundColor = [UIColor whiteColor];
    self.nameLabel.textColor = RGB(150, 150, 150);
    [nameView addSubview:self.nameLabel];
    
    UIView *companyView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameView.frame) + 1, width, kLabelHight)];
    companyView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:companyView];
    UILabel *companyL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    companyL.text = @"公司";
    companyL.font = [UIFont systemFontOfSize:17];
    [companyView addSubview:companyL];
    
    self.commpanyLabel = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(companyL.frame) + 5, CGRectGetMinY(companyL.frame), width - CGRectGetWidth(companyL.frame), CGRectGetHeight(companyL.frame))];
    self.commpanyLabel.backgroundColor = [UIColor whiteColor];
    self.commpanyLabel.textColor = RGB(150, 150, 150);
    //self.commpanyLabel.delegate = self;
    [companyView addSubview:self.commpanyLabel];
    
    UIView *positionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(companyView.frame) + 1, width, kLabelHight)];
    positionView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:positionView];
    UILabel *positionL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    positionL.text = @"职位";
    positionL.font = [UIFont systemFontOfSize:17];
    [positionView addSubview:positionL];
    
    self.positionLabel = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(positionL.frame) + 5, CGRectGetMinY(positionL.frame), width - CGRectGetWidth(positionL.frame), CGRectGetHeight(positionL.frame))];
    self.positionLabel.backgroundColor = [UIColor whiteColor];
    self.positionLabel.textColor = RGB(150, 150, 150);
    //self.positionLabel.delegate = self;
    [positionView addSubview:self.positionLabel];
    
    UIView *cityView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(positionView.frame) + 1, width, kLabelHight)];
    cityView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:cityView];
    UILabel *cityL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    cityL.text = @"城市";
    cityL.font = [UIFont systemFontOfSize:17];
    [cityView addSubview:cityL];
    
    self.cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityL.frame) + 5, CGRectGetMinY(cityL.frame), width - CGRectGetWidth(cityL.frame), CGRectGetHeight(cityL.frame))];
    self.cityLabel.backgroundColor = [UIColor clearColor];
    self.cityLabel.textAlignment = NSTextAlignmentLeft;
    self.cityLabel.textColor = RGB(150, 150, 150);
    self.cityLabel.text = @"";
    [cityView addSubview:self.cityLabel];
    
    UITapGestureRecognizer *tapCity = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cityBtnTouched:)];
    tapCity.delegate = self;
    [cityView addGestureRecognizer:tapCity];
    
    
    self.addressView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cityView.frame) + 1, width, kLabelHight + 10)];
    _addressView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:_addressView];
    self.addressL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    _addressL.text = @"地址";
    _addressL.font = [UIFont systemFontOfSize:17];
    //self.addressTextView.delegate = self; // 此代理暂时无用
    [_addressView addSubview:_addressL];
    
//    self.addressLabel = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_addressL.frame), CGRectGetMinY(_addressL.frame), width - CGRectGetWidth(_addressL.frame), CGRectGetHeight(_addressL.frame))];
//    self.addressLabel.backgroundColor = [UIColor whiteColor];
//    self.addressLabel.textColor = RGB(150, 150, 150);
//    [self.addressView addSubview:self.addressLabel];
    self.addressTextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_addressL.frame), CGRectGetMinY(_addressL.frame) - 10, width - CGRectGetWidth(_addressL.frame) - 10, CGRectGetHeight(_addressL.frame) + 50)];
    self.addressTextView.textColor = RGB(150, 150, 150);
    self.addressTextView.font = [UIFont systemFontOfSize:17];
    self.addressTextView.backgroundColor = [UIColor clearColor];
    //self.addressTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [self.addressView addSubview:self.addressTextView];
    
    /**
     * 联系方式
     */
    
    self.phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addressView.frame) + kInterSpace, width, kLabelHight)];
    _phoneView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_phoneView];
    self.phoneL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    _phoneL.text = @"手机";
    _phoneL.font = [UIFont systemFontOfSize:17];
    [_phoneView addSubview:_phoneL];
    
    self.phoneLabel = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneL.frame) + 5, CGRectGetMinY(self.phoneL.frame), width - CGRectGetWidth(self.phoneL.frame), CGRectGetHeight(self.phoneL.frame))];
    self.phoneLabel.backgroundColor = [UIColor whiteColor];
    self.phoneLabel.textColor = RGB(150, 150, 150);
    self.phoneLabel.delegate = self;
    [self.phoneView addSubview:self.phoneLabel];
    
    self.wechatView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.phoneView.frame) + 1, width, kLabelHight)];
    _wechatView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_wechatView];
    self.wechatL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    _wechatL.text = @"微信";
    _wechatL.font = [UIFont systemFontOfSize:17];
    [_wechatView addSubview:_wechatL];
    
    self.wechatLabel = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.wechatL.frame) + 5, CGRectGetMinY(self.wechatL.frame), width - CGRectGetWidth(self.wechatL.frame), CGRectGetHeight(self.wechatL.frame))];
    self.wechatLabel.backgroundColor = [UIColor whiteColor];
    self.wechatLabel.textColor = RGB(150, 150, 150);
    self.wechatLabel.delegate = self;
    [self.wechatView addSubview:self.wechatLabel];
    
    self.emailView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.wechatView.frame) + 1, width, kLabelHight)];
    _emailView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_emailView];
    self.emailL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    _emailL.text = @"邮箱";
    _emailL.font = [UIFont systemFontOfSize:17];
    [_emailView addSubview:_emailL];
    
    self.emailLabel = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.emailL.frame) + 5, CGRectGetMinY(self.emailL.frame), width - CGRectGetWidth(self.emailL.frame), CGRectGetHeight(self.emailL.frame))];
    self.emailLabel.backgroundColor = [UIColor whiteColor];
    self.emailLabel.textColor = RGB(150, 150, 150);
    self.emailLabel.delegate = self;
    [self.emailView addSubview:self.emailLabel];
    
    self.projectView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emailView.frame) + kInterSpace, width, kLabelHight)];
    _projectView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_projectView];
    self.projectL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    _projectL.text = @"项目";
    _projectL.font = [UIFont systemFontOfSize:17];
    [_projectView addSubview:_projectL];
    
    self.projectLabel = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.projectL.frame) + 5, CGRectGetMinY(self.projectL.frame), width - CGRectGetWidth(self.projectL.frame), CGRectGetHeight(self.projectL.frame))];
    self.projectLabel.backgroundColor = [UIColor whiteColor];
    self.projectLabel.textColor = RGB(150, 150, 150);
    self.projectLabel.delegate = self;
    [self.projectView addSubview:self.projectLabel];
    
    self.introductionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.projectView.frame) + 1, width, kLabelHight + 50)];
    _introductionView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_introductionView];
    self.introductionL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    _introductionL.text = @"简介";
    _introductionL.font = [UIFont systemFontOfSize:17];
    [_introductionView addSubview:_introductionL];
    
//    self.introductionLabel = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.introductionL.frame), CGRectGetMinY(self.introductionL.frame), width - CGRectGetWidth(self.introductionL.frame), CGRectGetHeight(self.introductionL.frame))];
//    self.introductionLabel.backgroundColor = [UIColor whiteColor];
//    self.introductionLabel.textColor = RGB(150, 150, 150);
//    [self.introductionView addSubview:self.introductionLabel];
    
    self.introductionTextView = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.introductionL.frame) + 5, CGRectGetMinY(self.introductionL.frame) - 10, width - CGRectGetWidth(self.introductionL.frame) - 10, CGRectGetHeight(self.introductionL.frame) + 50)];
    self.introductionTextView.textColor = RGB(150, 150, 150);
    self.introductionTextView.font = [UIFont systemFontOfSize:17];
    self.introductionTextView.backgroundColor = [UIColor clearColor];
    //self.addressTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    self.introductionTextView.delegate = self; // 此代理有用
    [self.introductionView addSubview:self.introductionTextView];
    
    
    self.scrollView.contentSize = CGSizeMake(width, CGRectGetHeight(self.avatarView.frame) + CGRectGetHeight(nameView.frame) + CGRectGetHeight(companyView.frame) + CGRectGetHeight(positionView.frame) + CGRectGetHeight(cityView.frame) + CGRectGetHeight(self.addressView.frame) + CGRectGetHeight(self.phoneView.frame) + CGRectGetHeight(self.wechatView.frame) + CGRectGetHeight(self.emailView.frame) + CGRectGetHeight(self.projectView.frame) + CGRectGetHeight(self.introductionView.frame) + 100);
    
    //发送个人资料
    self.sendProfile = [[TSWSendProfile alloc] initWithBaseURL:TSW_API_BASE_URL path:SEND_PROFILE];
    [self.sendProfile addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    //接受个人资料
    self.profile = [[TSWProfile alloc] initWithBaseURL:TSW_API_BASE_URL path:PROFILE];
    [self.profile addObserver:self
                   forKeyPath:kResourceLoadingStatusKeyPath
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    self.grayView = [[UIView alloc] initWithFrame:self.view.frame];
    _grayView.backgroundColor = [UIColor grayColor];
    _grayView.alpha = 0.3;
    _grayView.userInteractionEnabled = YES;
    //添加手势,点击空白区域,采集器消失
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicker)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self refreshData];
    
}

#pragma mark -- UITextFieldDelegate, UITextViewDelegate 关于弹出键盘视图上移
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
        CGFloat offset = -200;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
        CGFloat offset = -200;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 按钮点击事件
//保存按钮
- (void)rightButtonTapped:(UIButton *)sender {
    //num = 1;
   // [self.delegate passImageValue:self.avatarImage.image];
    if(self.avatarImage.image != nil) {
        if(self.nameLabel.text.length > 0){
            if(self.nameLabel.text.length <= 32){
                if(self.positionLabel.text.length > 0){
                    if(self.positionLabel.text.length <= 64){
                        if(self.commpanyLabel.text.length>0){
                            if(self.commpanyLabel.text.length <= 128){
                                if(self.emailLabel.text.length>0){
                                    if(self.emailLabel.text.length <= 128 && [self.emailLabel.text containsString:@"@"]){
                                        if(self.wechatLabel.text.length <= 128){
                                            if(self.addressTextView.text.length <= 256){
                                                [self.sendProfile loadDataWithRequestMethodType:kHttpRequestMethodTypePost parameters:@{@"name":self.nameLabel.text,@"title":self.positionLabel.text,@"company":self.commpanyLabel.text,@"cityCode":self.selectedCityCode,@"address":self.addressTextView.text,@"email":self.emailLabel.text,@"wechat":self.wechatLabel.text,@"avatar":self.avatarImage.image,@"phone":self.phoneLabel.text, @"projectName":self.projectLabel.text, @"projectSummary":self.introductionTextView.text} dataType:kHttpRequestDataTypeMultipart];
                                                [self showLoadingViewWithText:@"提交中..."];
                                            }else if(self.addressTextView.text.length>256){
                                                
                                            }
                                        }else if(self.wechatLabel.text.length>128){
                                        }
                                    }else{
                                    }
                                }else{
                                    self.emailLabel.text = @"请填写有效邮箱";
                                }
                            }else{
                            }
                        }else{
                            self.commpanyLabel.text = @"请填写有效公司名";
                        }
                    }else{
                    }
                }else{
                    self.positionLabel.text = @"请填写个人职位";
                }
            }else{
            }
        }else{
            self.nameLabel.text = @"请填写有效姓名";
        }
    } else {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请设置头像" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerView show];
    }

}
- (void)handlePOP:(UIButton *)sender {
    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未保存的修改将丢失,是否确认取消" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
    
    //[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
    
    }
}


//点击头像
- (void)handleTap:(UITapGestureRecognizer *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从手机相册选择",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];

}
#pragma mark -- 代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@",info);
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    image = [TSWEditMineViewController imageWithImageSimple:image scaledToSize:CGSizeMake(440, 440)];
    [self reSizeImage:image toSize:CGSizeMake(80, 80)];
//    [self getImageByCuttingImage:image Rect:CGRectMake(1000, 1000, 1000, 1000)];
    self.avatarImage.image = image;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }
        imagePicker.allowsEditing = YES;
        //    [self.view addSubview:imagePicker.view];
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }else if(buttonIndex == 1) {
        UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        //    imagePicker.view.frame=s
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
            imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
        }
        imagePicker.allowsEditing=YES;
        //    [self.view addSubview:imagePicker.view];
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }else if(buttonIndex == 2) {
        
    }
    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
//图片大小
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}
//图片裁剪
- ( UIImage *)getImageByCuttingImage:(UIImage *)image Rect:( CGRect )rect{
    
    // 大图 bigImage
    // 定义 myImageRect ，截图的区域
    
    CGRect myImageRect = rect;
    
    UIImage * bigImage= image;
    
    CGImageRef imageRef = bigImage. CGImage ;
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect (imageRef, myImageRect);
    
    CGSize size;
    
    size. width = rect. size . width ;
    
    size. height = rect. size . height ;
    
    UIGraphicsBeginImageContext (size);
    
    CGContextRef context = UIGraphicsGetCurrentContext ();
    
    CGContextDrawImage (context, myImageRect, subImageRef);
    
    UIImage * smallImage = [ UIImage imageWithCGImage :subImageRef];
    
    UIGraphicsEndImageContext ();
    
    return smallImage;
    
}
-(void) refreshData{
    [self.profile loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}


-(void)setDetail:(TSWProfile *)profile{
    // 塞数据，布局
//    [_avatarImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profile.imgUrl_3x]]]];
    //AFNetworking 的第三方请求图片方法
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:profile.imgUrl_3x] placeholderImage:[UIImage imageNamed:@"default_face"]];
    self.nameLabel.text = profile.name;
    self.positionLabel.text = profile.title;
    self.commpanyLabel.text = profile.companyFullName;
    self.phoneLabel.text = profile.phone;
    self.emailLabel.text = profile.email;
    self.wechatLabel.text = profile.wechat;
    self.selectedCityCode = profile.companyCityCode;
    self.addressTextView.text = profile.companyAddress;
    self.projectLabel.text = profile.projectName;
    self.introductionTextView.text = profile.projectSummary;
    self.cityLabel.text = profile.companyCityName;
}



#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if(object == _sendProfile){
            if (_sendProfile.isLoaded) {
                [self hideLoadingView];
                // 回到profile详情页，TODO:并在profile详情页刷新
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (_sendProfile.error) {
                [self showErrorMessage:[_sendProfile.error localizedFailureReason]];
            }
            
        }else if(object == _profile){
            if (_profile.isLoaded) {
                [self setDetail:_profile];
            }
            else if (_profile.error) {
                [self showErrorMessage:[_profile.error localizedFailureReason]];
            }
        }
    }
}


- (void)dealloc
{
    [_sendProfile removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_profile removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- 城市选择器
- (void)cityBtnTouched:(UITapGestureRecognizer *)sender {
    _grayView.userInteractionEnabled = YES;
    [self.view addSubview:_grayView];
    self.locatePicker = [[ZHAreaPickerView alloc] initWithDelegate:self];
    [self.locatePicker showInView:self.view];
    
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(ZHAreaPickerView *)picker
{
    self.cityLabel.text = [NSString stringWithFormat:@"%@", picker.locate.city];
    self.selectedCityCode = picker.locate.cityCode;
}

-(void)hidePicker{
//    [self.locatePicker cancelPicker];
    [self.locatePicker removeFromSuperview];
    [self.view endEditing:YES];
    _grayView.userInteractionEnabled = NO;
    [_grayView removeFromSuperview];
}
@end
