//
//  TSWNewAddFinanceViewController.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/8.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWNewAddFinanceViewController.h"
#import "TSWSendFinance.h"
@interface TSWNewAddFinanceViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UITableView *mineTableView;
@property (nonatomic, strong) UISwitch *financeSwitch;
@property (nonatomic, strong) UISwitch *FASwitch;
@property (nonatomic, strong) UITextField *valuationTF; //投后估值
@property (nonatomic, strong) UITextField *financeTF; //融资金额
@property (nonatomic, strong) UITextField *yearTF; //年份
@property (nonatomic, strong) UITextView *companyStatus; //公司现状

@property (nonatomic, strong) TSWSendFinance *sendFinance;
@property (nonatomic, strong) NSString *selectedCurrency;
@property (nonatomic, strong) NSString *selectedValueCurrency;
@property (nonatomic, strong) NSString *value;
@end

@implementation TSWNewAddFinanceViewController

- (void)dealloc {
    [_sendFinance removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _selectedCurrency = @"rmb";
    _selectedValueCurrency = @"dollar";
    // Do any additional setup after loading the view.
    self.navigationBar.title = @"新增融资需求";
    [self navigationRightButton];
    [self configureTbaleView];
    self.sendFinance = [[TSWSendFinance alloc] initWithBaseURL:TSW_API_BASE_URL path:SEND_FINANCE];
    [self.sendFinance addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if(object == _sendFinance){
            if (_sendFinance.isLoaded) {
                [self hideLoadingView];
                [self showSuccessMessage:@"发布成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (_sendFinance.error) {
                [self showErrorMessage:[_sendFinance.error localizedFailureReason]];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicker)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)hidePicker {
    [self.financeTF resignFirstResponder];
    [self.valuationTF resignFirstResponder];
    [self.yearTF resignFirstResponder];
    [self.companyStatus resignFirstResponder];
}
#pragma mark -- Commit Button
- (void)rightButtonTapped:(UIButton *)sender {
    NSString *NUM = @"^[0-9]*$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NUM];
    if(_valuationTF.text.length > 0){
        if([regextestmobile evaluateWithObject:_valuationTF.text] == YES){
            if(_financeTF.text.length > 0){
                if([regextestmobile evaluateWithObject:_financeTF.text] == YES){
                    if(_yearTF.text.length>0){
                        if(_yearTF.text.length<=256){
                            if(_companyStatus.text.length > 0 && _companyStatus.text.length<=1024){
                                [self showLoadingViewWithText:@"提交中..."];
                                int fa = 0;
                                if(_FASwitch.on){
                                    fa = 1;
                                }else{
                                    fa = 0;
                                }
                                NSString *fi = @"";
                                if (_financeSwitch.on) {
                                    fi = _selectedValueCurrency;
                                    self.value = [[_valuationTF.text stringByAppendingString:@"万"] stringByAppendingString:@"美元"];
                                } else {
                                    fi = _selectedCurrency;
                                    self.value = [[_valuationTF.text stringByAppendingString:@"万"] stringByAppendingString:@"人民币"];

                                }
                                [self.sendFinance loadDataWithRequestMethodType:kHttpRequestMethodTypePost parameters:@{@"valuation":_value,@"amount":_financeTF.text,@"amountType":fi,@"start":_yearTF.text,@"fa":[NSString stringWithFormat:@"%d",fa],@"projectStatus":_companyStatus.text}];
                            }else if(_companyStatus.text.length>1024){
                            }
                        }else{
                        }
                    }else{
                                            }
                }else{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"融资金额请填写数字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                }
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请填写融资金额" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"目前估值请填写数字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请填写目前估值" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }

    
    
    

}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = CGRectGetWidth(self.view.frame);
    //CGFloat height = CGRectGetHeight(self.view.frame);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UILabel *financeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
        financeLabel.text = @"融美元?";
        [cell addSubview:financeLabel];
        self.financeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(financeLabel.frame) + 20, CGRectGetMinY(financeLabel.frame), 0, 0)];
        _financeSwitch.on = YES;
        [_financeSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:_financeSwitch];
        
    } else if (indexPath.row == 1) {
        
        UILabel *FALabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
        FALabel.text = @"接受FA?";
        [cell addSubview:FALabel];
        self.FASwitch = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(FALabel.frame) + 20, CGRectGetMinY(FALabel.frame), 0, 0)];
        _FASwitch.on = YES;
        [_FASwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:_FASwitch];
        
    } else if (indexPath.row == 2) {
        UILabel *pepCount = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
        pepCount.text = @"投后估值";
        [cell addSubview:pepCount];
        self.valuationTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pepCount.frame) + 20, CGRectGetMinY(pepCount.frame), width - CGRectGetMaxX(pepCount.frame) - 20 - 50, CGRectGetHeight(pepCount.frame))];
        //_personCount.placeholder = @"[输入拟招人数]";
        UIColor *color = RGB(150, 150, 150);
        _valuationTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"[请输入投后估值]" attributes:@{NSForegroundColorAttributeName:color}];
        _valuationTF.tag = 101;
        [cell addSubview:_valuationTF];
        UILabel *wanLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.valuationTF.frame), CGRectGetMinY(pepCount.frame), 50, CGRectGetHeight(pepCount.frame))];
        wanLabel.text = @"万";
        [cell addSubview:wanLabel];
    } else if (indexPath.row == 3) {
        UILabel *salaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
        salaryLabel.text = @"融资金额";
        [cell addSubview:salaryLabel];
        self.financeTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(salaryLabel.frame) + 20, CGRectGetMinY(salaryLabel.frame), width - CGRectGetMaxX(salaryLabel.frame) - 20 - 50, CGRectGetHeight(salaryLabel.frame))];
        //_personCount.placeholder = @"[输入拟招人数]";
        UIColor *color = RGB(150, 150, 150);
        _financeTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"[请输入融资金额]" attributes:@{NSForegroundColorAttributeName:color}];
        _financeTF.tag = 102;
        [cell addSubview:_financeTF];
        UILabel *wanLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.financeTF.frame), CGRectGetMinY(salaryLabel.frame), 50, CGRectGetHeight(salaryLabel.frame))];
        wanLabel.text = @"万";
        [cell addSubview:wanLabel];
    } else if (indexPath.row == 4) {
        UILabel *contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
        contactLabel.text = @"启动时间";
        [cell addSubview:contactLabel];
        self.yearTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contactLabel.frame) + 20, CGRectGetMinY(contactLabel.frame), width, CGRectGetHeight(contactLabel.frame))];
        //_personCount.placeholder = @"[输入拟招人数]";
        UIColor *color = RGB(150, 150, 150);
        _yearTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"[请输入年-月-日]" attributes:@{NSForegroundColorAttributeName:color}];
        _yearTF.tag = 103;
        [cell addSubview:_yearTF];
    }
     else if (indexPath.row == 5) {
        UILabel *requestLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
        requestLabel.text = @"公司现状";
        [cell addSubview:requestLabel];
        self.companyStatus = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(requestLabel.frame) + 20, CGRectGetMinY(requestLabel.frame) - 5, width - CGRectGetMaxX(requestLabel.frame) - 30, 80)];
        self.companyStatus.font = [UIFont systemFontOfSize:17];
        _companyStatus.delegate = self;
        [cell addSubview:_companyStatus];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (5 == indexPath.row) {
        return 90;
    }
    return 50;
}

- (void)switchAction:(UISwitch *)financeSwitch {

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSString *NUM = @"^[0-9]*$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NUM];
    switch (textField.tag) {
        case 101:
            if(_valuationTF.text.length <= 0){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请填写目前估值" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }else if([regextestmobile evaluateWithObject:_valuationTF.text] == NO){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"目前估值请填写数字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
            break;
        case 102:
            if(_financeTF.text.length <= 0){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请填写融资金额" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }else if([regextestmobile evaluateWithObject:_financeTF.text] == NO){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"融资金额请填写数字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
            break;
        case 103:
            if(_yearTF.text.length>0){
                if(_yearTF.text.length<=256){

                }else{

                }
            }else{
                //_timeVeri.text = @"请填写融资时间";
            }
            
            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    switch (textView.tag) {
        case 4:
            if(_companyStatus.text.length>0){
                if(_companyStatus.text.length<=1024){
                }else{
                }
            }
            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGFloat offset = self.view.frame.size.height - (textView.frame.origin.y+textView.frame.size.height+216+50);
    if(offset <= 0){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y+textField.frame.size.height+216+50);
    if(offset <= 0){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
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
