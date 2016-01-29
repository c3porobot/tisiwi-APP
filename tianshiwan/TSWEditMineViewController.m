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
@interface TSWEditMineViewController ()<UIActionSheetDelegate,UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *avatarView; //头像视图
@property (nonatomic, strong) UIImageView *avatarImage; //头像
@property (nonatomic, strong) UITextField *nameLabel;
@property (nonatomic, strong) UILabel *commpanyLabel;
@property (nonatomic, strong) UITextField *positionLabel;
@property (nonatomic, strong) UITextField *cityLabel;
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
    [self addRightNavigatorButton];
    [self layoutScrollView];
}
- (void)addRightNavigatorButton
{
    //使用UIButton的子类
    UIButton *rightButton=[[UIButton alloc] initWithFrame : CGRectMake (0, 31, 100, 44)];
    [rightButton setTitle : @"保存" forState : UIControlStateNormal];
    //[rightButton setImage :[ UIImage imageNamed:@"arrow"] forState : UIControlStateNormal];
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
    self.avatarImage.backgroundColor = [UIColor yellowColor];
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
    
    UIView *companyView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameView.frame) + 1, width, kLabelHight)];
    companyView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:companyView];
    UILabel *companyL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    companyL.text = @"公司";
    companyL.font = [UIFont systemFontOfSize:17];
    [companyView addSubview:companyL];
    
    UIView *positionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(companyView.frame) + 1, width, kLabelHight)];
    positionView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:positionView];
    UILabel *positionL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    positionL.text = @"职位";
    positionL.font = [UIFont systemFontOfSize:17];
    [positionView addSubview:positionL];
    
    UIView *cityView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(positionView.frame) + 1, width, kLabelHight)];
    cityView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:cityView];
    UILabel *cityL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    cityL.text = @"城市";
    cityL.font = [UIFont systemFontOfSize:17];
    [cityView addSubview:cityL];
    
    self.addressView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cityView.frame) + 1, width, kLabelHight)];
    _addressView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:_addressView];
    self.addressL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    _addressL.text = @"地址";
    _addressL.font = [UIFont systemFontOfSize:17];
    [_addressView addSubview:_addressL];
    
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
    
    self.wechatView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.phoneView.frame) + 1, width, kLabelHight)];
    _wechatView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_wechatView];
    self.wechatL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    _wechatL.text = @"微信";
    _wechatL.font = [UIFont systemFontOfSize:17];
    [_wechatView addSubview:_wechatL];
    
    self.emailView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.wechatView.frame) + 1, width, kLabelHight)];
    _emailView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_emailView];
    self.emailL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    _emailL.text = @"邮箱";
    _emailL.font = [UIFont systemFontOfSize:17];
    [_emailView addSubview:_emailL];
    
    self.projectView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emailView.frame) + kInterSpace, width, kLabelHight)];
    _projectView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_projectView];
    self.projectL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    _projectL.text = @"项目";
    _projectL.font = [UIFont systemFontOfSize:17];
    [_projectView addSubview:_projectL];
    
    self.introductionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.projectView.frame) + 1, width, kLabelHight)];
    _introductionView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_introductionView];
    self.introductionL = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 40, 17)];
    _introductionL.text = @"简介";
    _introductionL.font = [UIFont systemFontOfSize:17];
    [_introductionView addSubview:_introductionL];
    
    self.scrollView.contentSize = CGSizeMake(width, CGRectGetHeight(self.avatarView.frame) + CGRectGetHeight(nameView.frame) + CGRectGetHeight(companyView.frame) + CGRectGetHeight(positionView.frame) + CGRectGetHeight(cityView.frame) + CGRectGetHeight(self.addressView.frame) + CGRectGetHeight(self.phoneView.frame) + CGRectGetHeight(self.wechatView.frame) + CGRectGetHeight(self.emailView.frame) + CGRectGetHeight(self.projectView.frame) + CGRectGetHeight(self.introductionView.frame) + 100);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 按钮点击事件
//保存按钮
- (void)rightButtonTapped:(UIButton *)sender {
    num = 1;
    [self.delegate passImageValue:self.avatarImage.image];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)handlePOP:(UIButton *)sender {
    if (num == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未保存的修改将丢失,是否确认取消" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
    }
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
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
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
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            
        }
        imagePicker.allowsEditing=YES;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
