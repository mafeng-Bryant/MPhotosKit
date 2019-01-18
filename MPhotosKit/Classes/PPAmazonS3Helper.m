//
//  PPAmazonS3Helper.m
//  PatPat
//
//  Created by patpat on 16/4/9.
//  Copyright © 2016年 http://www.patpat.com. All rights reserved.
//

#import "PPAmazonS3Helper.h"

AWSRegionType const CognitoRegionType = AWSRegionUSEast1;
AWSRegionType const DefaultServiceRegionType = AWSRegionUSWest2;

#define kAS3CognitoIdentityPoolId        @"us-east-1:73dabc49-ef5e-4ad2-a293-d18f7801bae7"
#define kAS3S3BucketName                 @"patpatwebstatic"

static NSString *uploadFolderName = @"upload";
static NSString *s3UserFolderName = @"origin/user";
static NSString *s3SnsFolderName = @"origin/sns";

@implementation PPAmazonS3Helper

+ (void)initAmazonS3 {
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:CognitoRegionType
                                                                                                    identityPoolId:kAS3CognitoIdentityPoolId];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:DefaultServiceRegionType
                                                                         credentialsProvider:credentialsProvider];
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    NSError *error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:uploadFolderName]
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error]) {
        NSLog(@"reating 'upload' directory failed: [%@]", error);
    }
}

+ (NSArray<AWSS3TransferManagerUploadRequest *> *)uploadImages:(NSArray<UIImage *> *)images
                                               uploadImageType:(PPS3UploadImageType)uploadImageType
                                               completionBlock:(PPCompletionBlock)completionBlock
                                                  progressTask:(void(^)(CGFloat progress))progressTask {
    
    NSMutableArray *uploadRequestArray = [NSMutableArray array];
    NSMutableArray *resultArray = [NSMutableArray array];
    NSMutableArray *progressArray = [NSMutableArray array];
    for (int i = 0; i<images.count; i++) {
        UIImage *image = images[i];
        [progressArray addObject:@(0)];
        AWSS3TransferManagerUploadRequest *uploadRequest = [self uploadImage:image index:i uploadImageType:uploadImageType completionBlock:^(id result, NSError *error) {
            if (error) {
                completionBlock(nil,error);
            } else if([result isKindOfClass:[NSString class]]) {
                  [resultArray addObject:result];
                if (resultArray.count == images.count) {
                    completionBlock(resultArray,nil);
                }
            }
        } progressTask:^(CGFloat progress) {
            [progressArray replaceObjectAtIndex:i withObject:@(progress)];
            float totalBytesSent = 0;
            for (NSNumber *progress in progressArray) {
                totalBytesSent += [progress floatValue];
            }
            CGFloat totalProgress = (float)((double) totalBytesSent / images.count);
            progressTask(totalProgress);
        }];
        [uploadRequestArray addObject:uploadRequest];
    }
    return uploadRequestArray;
}

+ (AWSS3TransferManagerUploadRequest *)uploadImage:(UIImage *)image
                                             index:(NSInteger)index
                                   uploadImageType:(PPS3UploadImageType)uploadImageType
                                   completionBlock:(PPCompletionBlock)completionBlock
                                      progressTask:(void(^)(CGFloat progress))progressTask
{
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [self uploadRequestWithImage:image index:index uploadImageType:uploadImageType];
    [self upload:uploadRequest completionBlock:completionBlock];
    if (progressTask) {
        uploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            CGFloat progress = (float)((double) totalBytesSent / totalBytesExpectedToSend);
            progressTask(progress);
        };
    }
    return uploadRequest;
}

+ (AWSS3TransferManagerUploadRequest *)uploadRequestWithImage:(UIImage *)image index:(NSInteger)index uploadImageType:(PPS3UploadImageType)uploadImageType {
    NSString *fileName = [self fileNameWithUploadImageType:uploadImageType];
    NSString *filePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:uploadFolderName] stringByAppendingPathComponent:fileName];
    NSData *imageData = [UIImage compressHandleMaxSize:CGSizeMake(1200, 1200) maxDataLength:500*1024 originImage:image];
    BOOL success = [imageData writeToFile:filePath atomically:YES];
    if (!success) {
        NSLog(@"Write to file failed");
    }
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = [NSURL fileURLWithPath:filePath];
    uploadRequest.key = [self s3AppFolderPath:uploadImageType fileName:fileName];
    uploadRequest.bucket = kAS3S3BucketName;
    uploadRequest.contentType = @"image/jpg";
    uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;//设置为公开
    return uploadRequest;
}

+ (NSString *)fileNameWithUploadImageType:(PPS3UploadImageType)uploadImageType {
    NSString *type = @"";
    switch (uploadImageType) {
        case PPS3UploadImageTypeAvatar:
            type = @"avatar";
            break;
        case PPS3UploadImageTypeComment:
            type = @"comment";
            break;
        case PPS3UploadImageTypeShare:
            type = @"share";
            break;
        case PPS3UploadImageTypeLife:
            type = @"life";
            break;
        default:
            break;
    }
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timeStamp = [[NSNumber numberWithDouble:time].stringValue stringByReplacingOccurrencesOfString:@"." withString:@""];
    return [[NSString stringWithFormat:@"patpat_%@_%@",type, timeStamp] stringByAppendingString:@".jpg"];
}

+ (NSString *)s3AppFolderPath:(PPS3UploadImageType)uploadImageType fileName:(NSString *)fileName{
    NSString *folderPath = @"";
    //TODO: 若增加 PPS3UploadImageType 需要在此处增加 folderPath 生成的 case
    switch (uploadImageType) {
        case PPS3UploadImageTypeAvatar:
            folderPath = [NSString stringWithFormat:@"%@/%@/%@", s3UserFolderName,s3AvatarFolderName,fileName];
            break;
        case PPS3UploadImageTypeComment:
            folderPath = [NSString stringWithFormat:@"%@/%@/%@", s3SnsFolderName,s3CommentFolderName,fileName];
            break;
        case PPS3UploadImageTypeShare:
            folderPath =  [NSString stringWithFormat:@"%@/%@/%@",s3SnsFolderName,s3OtherFolderName,fileName];
            break;
        case PPS3UploadImageTypeLife:
            folderPath =  [NSString stringWithFormat:@"%@/%@/%@",s3SnsFolderName,s3LifeFolderName,fileName];
            break;
        default:
            folderPath = fileName;
            break;
    }
    return folderPath;
}

+ (void)upload:(AWSS3TransferManagerUploadRequest *)uploadRequest completionBlock:(PPCompletionBlock)completionBlock {
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    [[transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            completionBlock(nil, task.error);
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                        break;
                    case AWSS3TransferManagerErrorPaused:
                        break;
                    default:
                        NSLog(@"Upload failed: [%@]", task.error);
                        break;
                }
            } else {
                NSLog(@"Upload failed: [%@]", task.error);
            }
        }
        if (task.result) {
            NSString *imageUrl = [NSString stringWithFormat:@"https://%@.%@/%@",uploadRequest.bucket, amazonS3Host, uploadRequest.key];
            completionBlock(imageUrl,nil);
        }
        [[NSFileManager defaultManager] removeItemAtURL:uploadRequest.body error:nil];
        return nil;
    }];
}

@end
