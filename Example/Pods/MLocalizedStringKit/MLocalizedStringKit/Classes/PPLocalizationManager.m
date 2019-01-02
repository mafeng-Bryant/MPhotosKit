//
//  PPLocalizationManager.m
//  PatPat
//
//  Created by Shawenlx on 2018/6/20.
//  Copyright © 2018年 http://www.patpat.com. All rights reserved.
//

#import "PPLocalizationManager.h"
#import <objc/runtime.h>

NSString *const kLocalizableSetting = @"kLocalizableSetting";

@implementation PPLocalizationManager

@synthesize localizableNames = _localizableNames;
@synthesize languageArray    = _languageArray;

#pragma mark - init methods
+ (instancetype)shareLocalizable
{
    static PPLocalizationManager *localizable;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localizable = [[PPLocalizationManager alloc] init];
        [localizable getlocalizableNames];
        [localizable settingParment];
    });
    return localizable;
}

#pragma mark - interface methods
- (NSString *)ppLocalizedString:(NSString *)translationKey
{
    NSString *path = [[NSBundle mainBundle] pathForResource:self.normalLocalizable ofType:@"lproj"];
    NSBundle *languageBundle = [NSBundle bundleWithPath:path];
    NSString *str = [languageBundle localizedStringForKey:translationKey value:@"" table:nil];
    return str;
}

- (NSString *)currentLanguageName
{
    NSString *languageName = @"English";
    for (NSInteger i = 0; i < self.languageArray.count; i++) {
        NSString *languegeCode = self.languageArray[i][2];
        if ([languegeCode isEqualToString:self.normalLocalizable]) {
            languageName = self.languageArray[i][1];
            break;
        }
    }
    return languageName;
}

#pragma mark - private methods

//判断是否存在app设置的语言
- (BOOL)isExitLocalLocalizable
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:kLocalizableSetting] ? YES : NO;
}

- (void)getlocalizableNames
{
    NSArray *array = [[NSBundle mainBundle]pathsForResourcesOfType:@"lproj" inDirectory:nil];
    NSMutableArray *filltArray = [NSMutableArray array];
    NSString *systemLanguage;
    if ([NSLocale preferredLanguages].count > 0) {
        systemLanguage = [[[NSLocale preferredLanguages] objectAtIndex:0] substringToIndex:2];
    } else {
        systemLanguage = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    }
    __block BOOL isExist = NO;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj = [obj stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/", [NSBundle mainBundle].resourcePath] withString:@""];
        obj = [obj stringByReplacingOccurrencesOfString:@".lproj" withString:@""];
        if ([obj isEqualToString:systemLanguage]) {
            isExist = YES;
        }
        [filltArray addObject:obj];
    }];
    if (![self isExitLocalLocalizable]) {
        if (isExist) {
            _normalLocalizable = systemLanguage;
        } else {
            _normalLocalizable = @"en";
        }
    }
    _localizableNames = filltArray;
}

- (void)settingParment
{
    if ([self isExitLocalLocalizable]) {
        // 以APP设置的优先
        _normalLocalizable = [[NSUserDefaults standardUserDefaults] objectForKey:kLocalizableSetting];
    }
}

#pragma mark - setter
- (void)setNormalLocalizable:(NSString *)normalLocalizable
{
    _normalLocalizable = normalLocalizable;
    self.languageArray = nil;
    [[NSUserDefaults standardUserDefaults] setObject:normalLocalizable forKey:kLocalizableSetting];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setLanguageArray:(NSArray *)languageArray {
    _languageArray = languageArray;
}

#pragma mark - getter
- (NSArray *)languageArray {
    if (!_languageArray) {
        _languageArray = @[ @[@"English", @"English", @"en"],
                            @[@"Español", @"Español", @"es"],
                            @[@"Français", @"Français", @"fr"],
                            @[@"Deutsch", @"Deutsch", @"de"],
                            @[@"Italiano", @"Italiano", @"it"],
                            ];
    }
    return _languageArray;
}

@end
