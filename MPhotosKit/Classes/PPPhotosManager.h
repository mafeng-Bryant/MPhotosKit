//
//  PPPhotosManager.h
//  PatPat
//
//  Created by patpat on 16/5/17.
//  Copyright © 2016年 http://www.patpat.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>
#import "PPAlbumModel.h"
#import "PPLocalizedStringHeader.h"

@interface PPPhotosManager : NSObject
@property (nonatomic, strong) NSMutableArray *tmpSelectDatas;

/**
 *  初始化PPPhotosManager
 */
+ (PPPhotosManager *)sharedPPPhotosManager;

/**
 *  重置临时数据
 */
- (void)resetTmpDatas;

/**
 *  是否有权限获取相册
 *
 *  @return bool
 */
- (BOOL)haveAccessToPhotos;

/**
 *  获取所有图片
 *
 *  @param mediaType 类型
 *
 *  @return DIAlbumModel的实例
 */
- (PPAlbumModel *)getAllPhotosWithType:(PHAssetMediaType)mediaType;

/**
 *  获取相机胶卷相册
 *
 *  @param mediaType 类型
 *
 *  @return DIAlbumModel的实例
 */
- (PPAlbumModel *)getCameraRollWithType:(PHAssetMediaType)mediaType;

/**
 *  获取相册
 *
 *  @param completion 回调
 */
- (void)getAlbumsWithCompletion:(void (^)(BOOL ret, id obj))completion;

/**
 *  获取相册封面
 *
 *  @param album      相册
 *  @param completion 回调
 */
- (void)getPosterImageForAlbumObj:(PPAlbumModel *)album
                       completion:(void (^)(BOOL ret, id obj))completion;

/**
 *  根据PHAsset获取图片
 *
 *  @param asset      PHAsset实例
 *  @param size       图片的尺寸
 *  @param completion 回调
 */
- (void)getImageForPHAsset:(PHAsset *)asset
                  withSize:(CGSize)size
                completion:(void (^)(BOOL ret, UIImage *image))completion;

/**
 *  根据PHAsset获取图片
 *
 *  @param asset      PHAsset实例
 *  @param size       图片的尺寸
 *  @param options    配置获取图片的参数
 *  @param completion 回调
 */
- (void)getImageForPHAsset:(PHAsset *)asset
                  withSize:(CGSize)size
                   options: (PHImageRequestOptions *)options
                completion:(void (^)(BOOL ret, UIImage *image))completion;

/**
 *  根据PHAsset获取图片，取的图片最大尺寸为1024
 *
 *  @param asset      PHAsset实例
 *  @param completion 回调
 */
- (void)getImageForPHAsset:(PHAsset *)asset
                completion:(void (^)(BOOL ret, UIImage *image))completion;

/**
 *  获取相册里的图片集合
 *
 *  @param album      相册
 *  @param completion 回调
 */
- (void)getPhotosWithAlbumObj:(PPAlbumModel *)album
                   completion:(void (^)(BOOL ret, id obj))completion;


/**
 *  获取图片NSData数据
 *
 *  @param asset      asset
 *  @param completion 回调
 */
- (void)getImageDataForPHAsset:(PHAsset *)asset
                    completion:(void (^)(BOOL ret, NSData *data))completion;

/**
 *  获取asset的URL
 *
 *  @param asset      asset
 *  @param completion 回调
 */
- (void)getURLForPHAsset:(PHAsset *)asset
              completion:(void (^)(BOOL ret, NSURL *URL))completion;

    
/**
 *  获取图片 通过视图
 *
 *  @param asset      view
*/
+ (UIImage*)getCaptureImage:(UIView*)view;

/**
 * 判断是否能访问图片
 *
 */
- (BOOL)canUsePhoto;

/**
 * 判断是否能拍摄照片
 *
 */
- (BOOL)canTakePhoto;

/**
 * 判断权限获取照片，防止崩溃
 *
 */
- (void)requestPhotoLibraryAuthorizationBlock:(void (^) (BOOL flag))block;

@end
