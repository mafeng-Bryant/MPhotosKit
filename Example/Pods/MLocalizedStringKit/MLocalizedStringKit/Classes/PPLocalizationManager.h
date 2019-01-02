//
//  PPLocalizationManager.h
//  PatPat
//
//  Created by Shawenlx on 2018/6/20.
//  Copyright © 2018年 http://www.patpat.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef  PPLocalizationString
#define PPLocalizationString(key,comment) [[PPLocalizationManager shareLocalizable] ppLocalizedString:key]

@interface PPLocalizationManager : NSObject
@property (nonatomic,strong,readonly)    NSArray     *localizableNames;  //获取工程支持的多语言的数组
@property (nonatomic,strong,readonly)    NSArray     *languageArray;     //支持的语言列表集合
@property (nonatomic,copy)               NSString    *normalLocalizable; //默认为英语

/*
 * 初始化单例
 *
 * return self
 */
+ (instancetype)shareLocalizable;

/*
 *  PPLocalizationString宏进行调用国际化
 *
 *  @param translationKey
 *
 *  @return string
 */
- (NSString *)ppLocalizedString:(NSString *)translationKey;

/*
 * 当前 APP使用的语言，默认为英语
 *
 *  @return string
 */
- (NSString *)currentLanguageName;

@end
