//
//  PPLocalizedString.h
//  PatPat
//
//  Created by Bruce He on 15/6/1.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//
//  结合genstrings命令生成Localized.string文件，命令 find . -name '*.m' |xargs genstrings -o en.lproj

#import <Foundation/Foundation.h>
#import "PPLocalizationManager.h"

#define PPString(KEY) [PPLocalizedString KEY]
#define kMainBundle [NSBundle mainBundle]

@interface PPLocalizedString : NSObject

+ (NSString *)OK_STRING;

+ (NSString *)CANCEL_STRING;

+ (NSString *)SUBMIT_STRING;

+ (NSString *)NO_STRING;

+ (NSString *)YES_STRING;

+ (NSString *)NOTHANKS_STRING;

+ (NSString *)UPDATENOW_STRING;

+ (NSString *)ENTERNUMBERDECIMALPOINT;

+ (NSString *)AUTHENTICATIONLOGINAGAIN;

+ (NSString *)NETWORKERROR;

+ (NSString *)DISCONNECTEDINTERNET;

+ (NSString *)REQUESTERROR;

+ (NSString *)SHAREFAILED;

+ (NSString *)SETEAMILACCOUNT;

+ (NSString *)SETIMESSAGEACCOUNT;

+ (NSString *)CONTANCTADMINISTRATORINFO;

+ (NSString *)INSTALLFACEBOOKTIPS;

+ (NSString *)INSTALLFACEBOOKMESSENGERTIPS;

+ (NSString *)INSTAGRMNOTFOUND;

+ (NSString *)INSTALLPINTEREST;

+ (NSString *)GIVEANDGETDETAILS;

+ (NSString *)INVITEFRIENDTIPS;

+ (NSString *)VIDEOURLERROR;

+ (NSString *)ADDRESSTIPS;

+ (NSString *)TIME_TO_SHOP_TITLE;

+ (NSString *)NO_TIPSSTRING;

+ (NSString *)CHANGERANOTHER;

+ (NSString *)PAYPALINFO;

+ (NSString *)APPLEPAYINFO;

+ (NSString *)YESEXIT;

+ (NSString *)NOSTAY;

+ (NSString *)ADDTOCART;

+ (NSString *)FAVORITES;

+ (NSString *)CART;

+ (NSString *)LIFE;

+ (NSString *)AllSTRING;

+ (NSString *)MORESTRING;

+ (NSString *)SORRY;

+ (NSString *)REPLY;

+ (NSString *)RESET;

+ (NSString *)JUSTNOW;

+ (NSString *)POINTS;

+ (NSString *)TODAY;

+ (NSString *)YESTERDAY;

+ (NSString *)TOMORROW;

+ (NSString *)A_MINUTE_AGO;

+ (NSString *)A_HOUR_AGO;

+ (NSString *)SECONDS_AGO;

+ (NSString *)MINUTES_AGO;

+ (NSString *)HOURS_AGO;

+ (NSString *)SORT;

+ (NSString *)ONLY_FLASHSALE;

+ (NSString *)SHOPALL;

+ (NSString *)POSTREVIEW;

+ (NSString *)CONFIRM;

+ (NSString *)QTY_STRING;

+ (NSString *)EMAIL_STRING;

+ (NSString *)SKIP_STRING;

+ (NSString *)SUCCESSFUL;

+ (NSString *)TODAY_CHECK;

+ (NSString *)SORTBY;

+ (NSString *)SALES;

+ (NSString *)BACK_STRING;

+ (NSString *)POST_YOUR_LIFE;

+ (NSString *)BACK_TO_CART;

+ (NSString *)VALIDITY;

+ (NSString *)POINTS_TO_REDEEM;

+ (NSString *)INVALID_REDEMPTION_CODE;

+ (NSString *)EDIT_STRING;

+ (NSString *)NO_POSTS_YET;

+ (NSString *)NO_LIKES_YET;

+ (NSString *)CHOOSE_YOUR_PRIME_ITEMS;

+ (NSString *)SELECT_1_PHOTO;

+ (NSString *)NO_SELECTED_PHOTO;

+ (NSString *)RECOMMENDED;

+ (NSString *)SHOPPING_SAFE_IN_PATPAT;

+ (NSString *)HELPFUL;

+ (NSString *)TAKE_A_PHOTO;

+ (NSString *)CHOOSE_FROM_ALBUM;

+ (NSString *)SELECT_PHOTO;

+ (NSString *)PLEASE_WAIT_MOMENT;

+ (NSString *)COMINGSOON_IS_ABOUT_TO_BEGIN;

+ (NSString *)HOW_TO_GET_MORE_POINTS;

+ (NSString *)CHECK_IN_DAILY;

+ (NSString *)POINTS_CHECKED;

+ (NSString *)LIMITED_OFFER;

+ (NSString *)ON_GOING_ENDS_IN;

+ (NSString *)COMMING_SOON;

+ (NSString *)ON_GOING;

+ (NSString *)CLICK_TO_DOWNLOAD_APP;

+ (NSString *)START_SHOWING_YOURS_NOW;

+ (NSString *)RECEIVE_FREE_GIFTS;

+ (NSString *)FOR_PURCHASE_OVER;

+ (NSString *)LESS_THAN;

+ (NSString *)SELECT_COLOR_SIZE_QUANTITY;

+ (NSString *)PLEASE_SELECT;

+ (NSString *)CHOOSE_ITEM_TO_REVIEW;

+ (NSString *)ADD_COMMENT;

+ (NSString *)MY_PATPOINTS;

+ (NSString *)COMMENT;

+ (NSString *)LEVEL_BENEFITS;

+ (NSString *)FULFILLED_BY_PATPAT;

+ (NSString *)HAVE_FREE_SHIPPING;

+ (NSString *)CANT_POST_TWITTER_TIPS;

+ (NSString *)BUY_STRING;

+ (NSString *)CHANGE_SUCCESSFUL;

+ (NSString *)ENTER_PROMO_CODE;

+ (NSString *)INSTAGRAM_TRY_AGAIN_TIPS;

+ (NSString *)UPDATE_TIME;

+ (NSString *)REMINDER_SETTING_SUCCESSFUL_TIPS;

+ (NSString *)ITEM_SAVED_LATER;

+ (NSString *)ITEM_REMOVED;

+ (NSString *)QUESTIONS_CALL_US_AT;

+ (NSString *)READ_STRING;

+ (NSString *)YOU_STRING;

+ (NSString *)WIN_STRING;

+ (NSString *)POINT_STRING;

+ (NSString *)PERCENT_CLAIMED;

+ (NSString *)NEW_MESSAGES;

+ (NSString *)LAST_CHANCE_TO_COME;

+ (NSString *)DELIVERY_STRING;

+ (NSString *)ESTIMATED_DELIVERY_TIPS;

+ (NSString *)PROCESSING;

+ (NSString *)SELECT_PHOTOS;

+ (NSString *)PLEASE_ENTER_COMMENT;

+ (NSString *)SAVED_EXTRA_MONEY_TIPS;

+ (NSString *)SHOP_MORE_TO_UPGRADE_TIPS;

+ (NSString *)AVAILABLE;

+ (NSString *)ADD_MORE_TO_GET_FREE;

+ (NSString *)PAYMENT_INFO_INCORRECT;

+ (NSString *)CONGRATULATIONS_UPGRADEDLV;

+ (NSString *)BY_PEOPLE;

+ (NSString *)PERCENT_OFF;

+ (NSString *)PRODUCTS_IN_CART_WERE_SOLD_OUT;

+ (NSString *)PRODUCTS_IN_CART_WAS_SOLD_OUT;

    
    
@end
