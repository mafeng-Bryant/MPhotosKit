//
//  PPLocalizedString+PPModelLocalizedString.m
//  PatPat
//
//  Created by patpat on 15/6/3.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//

#import "PPModelLocalizedString.h"

@implementation PPLocalizedString (PPModelLocalizedString)


+ (NSString *)CANCELLED_STRING
{
    return PPLocalizationString(@"model.cancelled", nil);
}

+ (NSString *)ENDIN_STRING
{
    return PPLocalizationString(@"model.endsin", nil);
}

+ (NSString *)YOURSPEND
{
    return PPLocalizationString(@"model.yourspend", nil);
}

+ (NSString *)YOUREARNED
{
    return PPLocalizationString(@"model.yourearned", nil);
}

+ (NSString *)YOUREARNEDPROCESSING
{
    return PPLocalizationString(@"model.yourearnedprocessing", nil);
}

+ (NSString*)PHOTOS_VIDEO
{
    return PPLocalizationString(@"model.album.title", nil);
}

+ (NSString*)PHOTOS_CAMERA_ROLL
{
    return PPLocalizationString(@"model.album.title_camera", nil);
}

@end
