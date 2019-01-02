//
//  PPAlbumModel.h
//  PatPat
//
//  Created by patpat on 16/5/17.
//  Copyright © 2016年 http://www.patpat.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPAlbumModel : NSObject

@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) UIImage   *posterImage;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) id fetchResult;
@property (nonatomic, strong) id assetCollection;

@end
