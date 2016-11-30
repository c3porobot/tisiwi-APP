//
//  TSWNewAddTalentViewController.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/4.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWNewAddTalentViewController.h"
#import "RDVTabBarController.h"
#import "TSWTalentPosition.h"
#import "TSWGetPosition.h"
#import "ZHAreaPickerView.h"
#import "TSWSendTalent.h"
@interface TSWNewAddTalentViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ZHAreaPickerDelegate, UITextViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) UIButton *commitBtn; //提交按钮
@property (nonatomic, strong) UILabel *changeStation; //选择工作岗位
@property (nonatomic, strong) UILabel *changeCity; //选择城市
@property (nonatomic, strong) UITextField *personCount; //人数
@property (nonatomic, strong) UITextField *salaryMin; //最小月薪值
@property (nonatomic, strong) UITextField *salaryMax; //最大月薪值
@property (nonatomic, strong) UITextField *contactHR; //HR联系人
@property (nonatomic, strong) UITextField *emailHR; //HR email
@property (nonatomic, strong) UITextView *requestJob; //任职要求

@property (nonatomic, strong) UITextField *pickerViewTextField; //工作岗位选择器
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *positionData;
@property (nonatomic, copy) NSString *selectedPosition;
@property (nonatomic, strong) TSWGetPosition *getPosition;

@property (strong, nonatomic) ZHAreaPickerView *locatePicker;
@property (strong, nonatomic) NSString *selectedCityCode;

@property (nonatomic, strong) UITableView *mineTableView;

@property (nonatomic, strong) TSWSendTalent *sendTalent;
@property (nonatomic, strong) UITextView *dutyView;


@end

@implementation TSWNewAddTalentViewController
- (void)dealloc
{
    [_getPosition removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_sendTalent removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.title = @"新增人才需求";
    self.view.backgroundColor = [UIColor whiteColor];
    self.grayView = [[UIView alloc] initWithFrame:self.view.frame];
    _grayView.backgroundColor = [UIColor grayColor];
    _grayView.alpha = 0.3;
    _grayView.userInteractionEnabled = YES;
    
    _selectedCityCode = @"110000";
    _dutyView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _dutyView.text = @"111111111111111";
    [self navigationRightButton];
    [self configureTbaleView];
    self.locatePicker = [[ZHAreaPickerView alloc] initWithDelegate:self withAll:YES];
    self.locatePicker.frame = CGRectMake(0, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.width, 200);
    [self.view addSubview:self.locatePicker];
    
    self.getPosition = [[TSWGetPosition alloc] initWithBaseURL:TSW_API_BASE_URL path:GET_POSITION];
    [self.getPosition addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    
    self.sendTalent = [[TSWSendTalent alloc] initWithBaseURL:TSW_API_BASE_URL path:SEND_TALENT];
    [self.sendTalent addObserver:self
                      forKeyPath:kResourceLoadingStatusKeyPath
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    [self refreshData];
    
   }

- (void)navigationRightButton {
    self.commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 50, 36.5, 48, 12)];
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.commitBtn.titleLabel.font = [UIFont systemFontOfSize:14.5f];
    [self.commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.commitBtn addTarget:self action:@selector(rightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightButton:self.commitBtn];
}

- (void)configureTbaleView {
    self.mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    [_mineTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _mineTableView.delegate = self;
    _mineTableView.dataSource = self;
    [self.view addSubview:_mineTableView];
    self.pickerViewTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    
    [_mineTableView addSubview:self.pickerViewTextField];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 230);
    self.pickerViewTextField.inputView = self.pickerView;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicker)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];

}

- (void)refreshData {
 [_getPosition loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}
//UITextField *personCount; //人数
// UITextField *salaryMin; //最小月薪值
// UITextField *salaryMax; //最大月薪值
// UITextField *contactHR; //HR联系人
// UITextField *emailHR; //HR email
//UITextView *requestJob; //任职要求
- (void)hidePicker{
    //灰色视图
    _grayView.userInteractionEnabled = NO;
    [_grayView removeFromSuperview];
    [_pickerView removeFromSuperview];
    [self.locatePicker removeFromSuperview];
    [self.personCount resignFirstResponder];
    [self.salaryMax resignFirstResponder];
    [self.salaryMin resignFirstResponder];
    [self.contactHR resignFirstResponder];
    [self.emailHR resignFirstResponder];
    [self.requestJob resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
    [self.requestJob resignFirstResponder];

    }

#pragma mark -- 按钮响应事件
- (void)rightButtonTapped:(UIButton *)sender {
        // 提交前校验
        NSString *NUM = @"^[0-9]*$";
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NUM];
        NSString * EMAIL = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";
        NSPredicate *regextestemail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL];
        if(_changeStation.text.length > 0){
            if(_changeStation.text.length<=128){
                if(_personCount.text.length>0){
                    if(_personCount.text.length<=8){
                        if([regextestmobile evaluateWithObject:_personCount.text] == YES){
                            if(_salaryMin.text.length > 0){
                                if([regextestmobile evaluateWithObject:_salaryMin.text] == YES){
                                    if(_salaryMax.text.length > 0){
                                        if([regextestmobile evaluateWithObject:_salaryMax.text] == YES){
                                            if(_contactHR.text.length>0){
                                                if(_contactHR.text.length<32){
                                                    if(_emailHR.text.length>0){
                                                        if(_emailHR.text.length<128){
                                                            if([regextestemail evaluateWithObject:_emailHR.text] == YES){
                                                            if(_requestJob.text.length > 0 && _requestJob.text.length<=1024){
                                                                            [self showLoadingViewWithText:@"提交中..."];
                                                                            NSString *askText = @"";
                                                                            if(_requestJob.text){
                                                            askText = _requestJob.text;
                                                                            }
                                                            [self.sendTalent loadDataWithRequestMethodType:kHttpRequestMethodTypePost parameters:@{@"name":_changeStation.text,@"cityCode":_selectedCityCode,@"amount":_personCount.text,@"salaryMin":[_salaryMin.text stringByAppendingString:@"000"] ,@"salaryMax":[_salaryMax.text stringByAppendingString:@"000"],@"hr":_contactHR.text,@"hrEmail":_emailHR.text,@"responsibility":_dutyView.text, @"requirements":askText}];
                                                                        }else if(_requestJob.text.length>1024){
                                                            }
                                                                        
                                                            }else{
                                                                //_hremailVeri.text = @"请填写正确的邮箱";
                                                            }
                                                        }else{
                                                        }
                                                    }else{
                                                        //_hremailVeri.text = @"请填写HR邮箱";
                                                    }
                                                }else{
                                                }
                                            }else{
                                                //_hrVeri.text = @"请填写HR联系人";
                                            }
                                        }else{
                                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"薪资范围请填写数字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                            [alertView show];
                                        }
                                    }else{
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请填写薪资范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                        [alertView show];
                                    }
                                }else{
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"薪资范围请填写数字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                    [alertView show];
                                }
                            }else{
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请填写薪资范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                [alertView show];
                            }
                        }else{
                            //_numVeri.text = @"请填写数字";
                        }
                    }else{
                    }
                }else{
                    //_numVeri.text = @"请填写人数需求";
                }
            }else{
            }
            
        }else{
            //_nameVeri.text = @"请填写岗位名称";
        }
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = CGRectGetWidth(self.view.frame);
    //CGFloat height = CGRectGetHeight(self.view.frame);
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UILabel *stationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
        stationLabel.text = @"工作岗位";
        [cell addSubview:stationLabel];
        self.changeStation = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(stationLabel.frame) + 20, CGRectGetMinY(stationLabel.frame), width, CGRectGetHeight(stationLabel.frame))];
        self.changeStation.text = @"[请选择工作岗位]";
        self.changeStation.textAlignment = NSTextAlignmentLeft; //左对齐
        self.changeStation.textColor = RGB(150, 150, 150);
        [self.personCount resignFirstResponder];
        [self.salaryMax resignFirstResponder];
        [self.salaryMin resignFirstResponder];
        [self.contactHR resignFirstResponder];
        [self.emailHR resignFirstResponder];
        [self.requestJob resignFirstResponder];
        [cell addSubview:_changeStation];
        
    } else if (indexPath.row == 1) {
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
        cityLabel.text = @"工作城市";
        [cell addSubview:cityLabel];
        self.changeCity = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cityLabel.frame) + 20, CGRectGetMinY(cityLabel.frame), width, CGRectGetHeight(cityLabel.frame))];
        self.changeCity.text = @"[请选择工作城市]";
        self.changeCity.textAlignment = NSTextAlignmentLeft; //左对齐
        self.changeCity.textColor = RGB(150, 150, 150);
        [cell addSubview:_changeCity];
    } else if (indexPath.row == 2) {
        UILabel *pepCount = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
        pepCount.text = @"拟招人数";
        [cell addSubview:pepCount];
        self.personCount = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pepCount.frame) + 20, CGRectGetMinY(pepCount.frame), width, CGRectGetHeight(pepCount.frame))];
        //_personCount.placeholder = @"[输入拟招人数]";
        UIColor *color = RGB(150, 150, 150);
        _personCount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"[请输入拟招人数]" attributes:@{NSForegroundColorAttributeName:color}];
        [self.personCount resignFirstResponder];
        [self.salaryMax resignFirstResponder];
        [self.salaryMin resignFirstResponder];
        [self.contactHR resignFirstResponder];
        [self.emailHR resignFirstResponder];
        [self.requestJob resignFirstResponder];
        [cell addSubview:_personCount];
    } else if (indexPath.row == 3) {
        UILabel *salaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
        salaryLabel.text = @"月薪范围";
        [cell addSubview:salaryLabel];
        self.salaryMin = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(salaryLabel.frame) + 20, CGRectGetMinY(salaryLabel.frame), 30, CGRectGetHeight(salaryLabel.frame))];
        UIColor *color = RGB(150, 150, 150);
        _salaryMin.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"K" attributes:@{NSForegroundColorAttributeName:color}];
        _salaryMin.tag = 101;
        [cell addSubview:_salaryMin];
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.salaryMin.frame) + 5, CGRectGetMinY(self.salaryMin.frame), 20, CGRectGetHeight(self.salaryMin.frame))];
        aLabel.text = @"至";
        [cell addSubview:aLabel];
        self.salaryMax = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(aLabel.frame) + 20, CGRectGetMinY(aLabel.frame), CGRectGetWidth(self.salaryMin.frame), CGRectGetHeight(self.salaryMin.frame))];
        _salaryMax.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"K" attributes:@{NSForegroundColorAttributeName:color}];
        _salaryMax.tag = 102;
        [cell addSubview:_salaryMax];
    } else if (indexPath.row == 4) {
        UILabel *contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
        contactLabel.text = @"HR姓名";
        [cell addSubview:contactLabel];
        self.contactHR = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contactLabel.frame) + 20, CGRectGetMinY(contactLabel.frame), width, CGRectGetHeight(contactLabel.frame))];
        //_personCount.placeholder = @"[输入拟招人数]";
        UIColor *color = RGB(150, 150, 150);
        _contactHR.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"[请输入HR姓名]" attributes:@{NSForegroundColorAttributeName:color}];
        _contactHR.tag = 103;
        [cell addSubview:_contactHR];
    } else if (indexPath.row == 5) {
        UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
        emailLabel.text = @"HR邮箱";
        [cell addSubview:emailLabel];
        self.emailHR = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(emailLabel.frame) + 20, CGRectGetMinY(emailLabel.frame), width, CGRectGetHeight(emailLabel.frame))];
        //_personCount.placeholder = @"[输入拟招人数]";
        UIColor *color = RGB(150, 150, 150);
        _emailHR.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"[请输入HR邮箱]" attributes:@{NSForegroundColorAttributeName:color}];
        [cell addSubview:_emailHR];
    } else if (indexPath.row == 6) {
        UILabel *requestLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
        requestLabel.text = @"任职要求";
        [cell addSubview:requestLabel];
        self.requestJob = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(requestLabel.frame) + 20, CGRectGetMinY(requestLabel.frame) - 5, width - CGRectGetMaxX(requestLabel.frame) - 30, 80)];
        self.requestJob.font = [UIFont systemFontOfSize:17];
        _requestJob.delegate = self;
        [cell addSubview:_requestJob];
    }
        return cell;
    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSLog(@"请选择工作岗位");
        _grayView.userInteractionEnabled = YES;
        [self.view addSubview:_grayView];
        [self.personCount resignFirstResponder];
        [self.salaryMax resignFirstResponder];
        [self.salaryMin resignFirstResponder];
        [self.contactHR resignFirstResponder];
        [self.emailHR resignFirstResponder];
        [self.requestJob resignFirstResponder];

        CGFloat width = CGRectGetWidth(self.view.bounds);
        CGFloat height = CGRectGetHeight(self.view.bounds);
        //打印动画块的位置
        //NSLog(@"动画执行之前的位置：%@",NSStringFromCGPoint(self.details.center));
        //首尾式动画
        [UIView beginAnimations:nil context:nil];
        //执行动画
        //设置动画执行时间
        [UIView setAnimationDuration:1];
        //设置代理
        [UIView setAnimationDelegate:self];
        //设置动画执行完毕调用的事件
        self.pickerView.center = CGPointMake(width / 2, height - 100);
        self.pickerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_pickerView];
        [UIView commitAnimations];

    } else if (indexPath.row == 1) {
        NSLog(@"请选择工作城市");
        _grayView.userInteractionEnabled = YES;
        [self.view addSubview:_grayView];
        [self.locatePicker showInView:self.view];
        
        [self.locatePicker becomeFirstResponder];
        //[self.view addSubview:self.locatePicker];
        //打印动画块的位置
        //首尾式动画
        [UIView beginAnimations:nil context:nil];
        //执行动画
        //设置动画执行时间
        [UIView setAnimationDuration:1];
        //设置代理
        [UIView setAnimationDelegate:self];
        //设置动画执行完毕调用的事件
        //动画弹出位置
        [UIView commitAnimations];
        // 出现编辑按钮 TODO:要先隐藏
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (6 == indexPath.row) {
        return 90;
    }
    return 50;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    } if ([touch.view isKindOfClass:[UIView class]]) {
        return YES;
    }
    return NO;
}
#pragma mark - 通知中心
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
        if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
          if(object == _getPosition){
            if (_getPosition.isLoaded) {
                self.positionData = [[NSMutableArray alloc]init];
                TSWTalentPosition *position = [[TSWTalentPosition alloc]init];
                position.sid = @"";
                position.title = @"[请选择工作岗位]";
                [self.positionData addObject:position];
                for(TSWTalentPosition *p in _getPosition.positions){
                    [self.positionData addObject:p];
                }
                [self.pickerView reloadAllComponents];
            }
            else if (_getPosition.error) {
                [self showErrorMessage:[_getPosition.error localizedFailureReason]];
            }
        }
    }
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if(object == _sendTalent){
            if (_sendTalent.isLoaded) {
                [self hideLoadingView];
                [self showSuccessMessage:@"发布成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (_sendTalent.error) {
                [self showErrorMessage:[_sendTalent.error localizedFailureReason]];
            }
        }
    }

}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(ZHAreaPickerView *)picker
{
    NSString *name = @"";
    if(picker.locate.city){
        name = picker.locate.city;
    }else{
        name = @"[请选择工作城市]";
    }
    self.changeCity.text = [NSString stringWithFormat:@"%@", name];
    self.selectedCityCode = picker.locate.cityCode;
    [self refreshData];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.positionData count];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    TSWTalentPosition *temp = (TSWTalentPosition *)[self.positionData objectAtIndex:row];
    NSString *item = temp.title;
    return item;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // perform some action
    TSWTalentPosition *temp = (TSWTalentPosition *)[self.positionData objectAtIndex:row];
    self.changeStation.text = temp.title;
    _selectedPosition = temp.sid;
    [self refreshData];
}
#pragma mark -- UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    CGFloat offset = -200;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = offset;
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSString *NUM = @"^[0-9]*$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NUM];
    NSString * EMAIL = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";
    NSPredicate *regextestemail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL];
    switch (textField.tag) {
        case 101:
            if(_salaryMin.text.length <= 0){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请填写薪资范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }else if([regextestmobile evaluateWithObject:_salaryMin.text] == NO){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"薪资范围请填写数字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
            break;
        case 102:
            if(_salaryMax.text.length <= 0){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请填写薪资范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }else if([regextestmobile evaluateWithObject:_salaryMax.text] == NO){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"薪资范围请填写数字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
            break;
        case 103:
            if(_emailHR.text.length>0){
                if(_emailHR.text.length<=128){
                    if([regextestemail evaluateWithObject:_emailHR.text] == YES){
                        
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的邮箱格式" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                        [alert show];
                        
                    }
                    
                }else{
                    
                }
            }else{
                
            }
            break;
        default:
            break;
    }
    return YES;

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
