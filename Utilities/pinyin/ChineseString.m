//
//  ChineseString.m
//  AiJia
//
//  Created by zhouhai on 15/4/1.
//  Copyright (c) 2015年 AiJia. All rights reserved.
//

#import "ChineseString.h"
#import "TSWContact.h"
#import "TSWContactList.h"

@interface ChineseString()
@end

@implementation ChineseString
@synthesize contact;
@synthesize pinYin;

#pragma mark - 返回tableview右方 indexArray
+(NSMutableArray*)IndexArray:(NSArray*)TSWContactsArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:TSWContactsArr];
    NSMutableArray *A_Result=[NSMutableArray array];
    NSString *tempString ;
    
    for (NSString* object in tempArray)
    {
        NSString *pinyin = [((ChineseString*)object).pinYin substringToIndex:1];
        //不同
        if(![tempString isEqualToString:pinyin])
        {
            [A_Result addObject:pinyin];
            tempString = pinyin;
        }
    }
    return A_Result;
}

#pragma mark - 返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)TSWContactsArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:TSWContactsArr];
    NSMutableArray *LetterResult=[NSMutableArray array];
//    NSString *tempString ;
    //拼音分组
    for (NSString* object in tempArray) {
        
        NSString *pinyin = [((ChineseString*)object).pinYin substringToIndex:1];
        TSWContact *contact = ((ChineseString*)object).contact;
        
        //不同
//        if(![tempString isEqualToString:pinyin])
//        {
        if([LetterResult count] > 0){
            //分组
            BOOL flag = NO;
            for(TSWContactList* obj in LetterResult){
                if([obj.pinYin isEqualToString:pinyin]){
                    flag = YES;
                    [obj.contacts addObject:contact];
                    break;
                }else{
                }
            }
            if(!flag){
                TSWContactList *item = [[TSWContactList alloc] init];
                item.contacts = [NSMutableArray array];
                [item.contacts addObject:contact];
                item.pinYin = pinyin;
                [LetterResult addObject:item];
            }
        }else{
            TSWContactList *item = [[TSWContactList alloc] init];
            item.contacts = [NSMutableArray array];
            [item.contacts addObject:contact];
            item.pinYin = pinyin;
            [LetterResult addObject:item];
        }
        
//            [item  addObject:contact];
        
            //遍历
//            tempString = pinyin;
//        }else//相同
//        {
////            [item  addObject:contact];
//            [item.contacts addObject:contact];
//        }
    }
    return LetterResult;
}




//过滤指定字符串   里面的指定字符根据自己的需要添加
+(NSString*)RemoveSpecialCharacter: (NSString *)str {
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @",.？、 ~￥#&<>《》()[]{}【】^@/￡&curren;|&sect;&uml;「」『』￠￢￣~@#&*（）——+|《》$_€"]];
    if (urgentRange.location != NSNotFound)
    {
        return [self RemoveSpecialCharacter:[str stringByReplacingCharactersInRange:urgentRange withString:@""]];
    }
    return str;
}

///////////////////
//
//返回排序好的字符拼音
//
///////////////////
+(NSMutableArray*)ReturnSortChineseArrar:(NSArray*)TSWContactsArr
{
    //获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[TSWContactsArr count];i++)
    {
        ChineseString *chineseString=[[ChineseString alloc]init];
        id object =[TSWContactsArr objectAtIndex:i];
        if ([object isKindOfClass:[TSWContact class]]){
            TSWContact *contact = [[TSWContact alloc] init];
            contact = (TSWContact *)object;
            chineseString.contact = [[TSWContact alloc] init];
            chineseString.contact = contact;
        }
        
        if(chineseString.contact.name==nil){
            chineseString.contact.name=@"";
        }
        //去除两端空格和回车
        chineseString.contact.name  = [chineseString.contact.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        //此方法存在一些问题 有些字符过滤不了
        //NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）&yen;「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
        //chineseString.string = [chineseString.string stringByTrimmingCharactersInSet:set];
        
        
        //这里我自己写了一个递归过滤指定字符串   RemoveSpecialCharacter
        chineseString.contact.name =[ChineseString RemoveSpecialCharacter:chineseString.contact.name];
        // NSLog(@"string====%@",chineseString.string);
        
        
        //判断首字符是否为字母
        NSString *regex = @"[A-Za-z]+";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        
        if ([predicate evaluateWithObject:chineseString.contact.name])
        {
            //首字母大写
            chineseString.pinYin = [chineseString.contact.name capitalizedString] ;
        }else{
            if(![chineseString.contact.name isEqualToString:@""]){
                NSString *pinYinResult=[NSString string];
                for(int j=0;j<chineseString.contact.name.length;j++){
                    NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.contact.name characterAtIndex:j])]uppercaseString];
                    
                    pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                chineseString.pinYin=pinYinResult;
            }else{
                chineseString.pinYin=@"";
            }
        }
        [chineseStringsArray addObject:chineseString];
    }
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    return chineseStringsArray;
}
@end
