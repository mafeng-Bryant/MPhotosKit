//
//  PPAmazonS3Helper.h
//  PatPat
//
//  Created by patpat on 16/4/9.
//  Copyright © 2016年 http://www.patpat.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSS3/AWSS3.h>

typedef void (^PPCompletionBlock)(id result, NSError *error);

typedef NS_ENUM(NSInteger, PPS3UploadImageType) { //上传图片分类
    PPS3UploadImageTypeAvatar,      //头像图片
    PPS3UploadImageTypeComment,      //评论图片
    PPS3UploadImageTypeShare,
    PPS3UploadImageTypeLife,        //社区图片
};//若要增加类型需要增加下面的FolderName,根据不同类型创建对应文件夹,上传到S3服务器上的文件按照分类存放

static NSString const *s3AvatarFolderName = @"avatar";
static NSString const *s3CommentFolderName = @"comment";
static NSString const *s3LifeFolderName = @"post";
static NSString const *s3OtherFolderName = @"other";
static NSString * const amazonS3Host = @"s3.us-west-2.amazonaws.com";

@interface PPAmazonS3Helper : NSObject

/**
 *  初始化AmazonS3
 */
+ (void)initAmazonS3;

/**
 *  上传多个图片
 *
 *  @param images          图片数组
 *  @param uploadImageType 上传图片类型
 *  @param completionBlock 上传成功回调--(id result, NSError *error) result<NSArray>:@[图片webUrl,...]
 *  @param progressTask    图片上传总进度
 *
 *  @return 数组 class :AWSS3TransferManagerUploadRequest
 */
+ (NSArray<AWSS3TransferManagerUploadRequest *> *)uploadImages:(NSArray<UIImage *> *)images
                                               uploadImageType:(PPS3UploadImageType)uploadImageType
                                               completionBlock:(PPCompletionBlock)completionBlock
                                                  progressTask:(void(^)(CGFloat progress))progressTask;
/**
 *  上传单个图片
 *
 *  @param image           UIImage
 *  @param index           标识图片下标
 *  @param uploadImageType 上传图片类型
 *  @param completionBlock 上传成功回调--(id result, NSError *error) result<NSString>:图片webUrl
 *  @param progressTask    图片上传总进度
 *
 *  @return AWSS3TransferManagerUploadRequest
 */
+ (AWSS3TransferManagerUploadRequest *)uploadImage:(UIImage *)image
                                             index:(NSInteger)index
                                   uploadImageType:(PPS3UploadImageType)uploadImageType
                                   completionBlock:(PPCompletionBlock)completionBlock
                                      progressTask:(void(^)(CGFloat progress))progressTask;


@end
