//
//  PPPhotosManager.m
//  PatPat
//
//  Created by patpat on 16/5/17.
//  Copyright © 2016年 http://www.patpat.com. All rights reserved.
//

#import "PPPhotosManager.h"

@implementation PPPhotosManager

+ (instancetype)sharedPPPhotosManager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self){
        self.tmpSelectDatas = [NSMutableArray array];
    }
    return self;
}

- (void)resetTmpDatas
{
    [self.tmpSelectDatas removeAllObjects];
}

- (BOOL)haveAccessToPhotos
{
    return ( [PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusRestricted &&
            [PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusDenied );
}

- (PPAlbumModel *)getAllPhotosWithType:(PHAssetMediaType)mediaType
{
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    allPhotosOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", mediaType];
//    allPhotosOptions.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    PPAlbumModel *obj = [[PPAlbumModel alloc] init];
    obj.name = (mediaType == PHAssetMediaTypeVideo)?PPString(PHOTOS_VIDEO):PPString(PHOTOS_CAMERA_ROLL);
    obj.count = allPhotos.count;
    obj.fetchResult  = allPhotos;
    obj.assetCollection = nil;
    return obj;
}

- (PPAlbumModel *)getCameraRollWithType:(PHAssetMediaType)mediaType
{
    //fetch camera roll album(相机胶卷), only get image ,set options with fetch ablums
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", mediaType];
    fetchOptions.sortDescriptors   = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult  *cameraRo = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                        subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                        options:nil];
    PHAssetCollection *colt  = [cameraRo lastObject];
    PHFetchResult *fetchR    = [PHAsset fetchAssetsInAssetCollection:colt
                                                             options:fetchOptions];
    PPAlbumModel *obj = [[PPAlbumModel alloc] init];
    obj.name = PPString(PHOTOS_CAMERA_ROLL);
    obj.count = fetchR.count;
    obj.fetchResult  = fetchR;
    obj.assetCollection = colt;
    return obj;
}

- (void)getAlbumsWithCompletion:(void (^)(BOOL ret, id obj))completion
{
    NSMutableArray *tmpResult = [NSMutableArray array];
    PPAlbumModel *obj = [self getAllPhotosWithType:PHAssetMediaTypeImage];
    [tmpResult addObject:obj];
    
    //fetch custom albums
    
    PHAssetCollectionSubtype type = PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum;
    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:type options:nil];
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
    fetchOptions.sortDescriptors   = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    for (PHAssetCollection *album in albums) {
        @autoreleasepool {
            PHFetchResult *photos = [PHAsset fetchAssetsInAssetCollection:album options:fetchOptions];
            PPAlbumModel *object = [[PPAlbumModel alloc]init];
            object.name = album.localizedTitle;
            object.count = photos.count;
            object.fetchResult = photos;
            object.assetCollection = album;
            [tmpResult addObject:object];
        }
    }
    completion(YES,tmpResult);
}

- (void)getPosterImageForAlbumObj:(PPAlbumModel *)album
                       completion:(void (^)(BOOL ret, id obj))completion
{
    PHFetchResult *photos = (PHFetchResult *)album.fetchResult;
    PHAsset *asset = [photos firstObject];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat dimension = 60.f;
    CGSize  size  = CGSizeMake(dimension * scale, dimension * scale);
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completion(result?YES:NO,result);
    }];
}

- (void)getPhotosWithAlbumObj:(PPAlbumModel *)album
                   completion:(void (^)(BOOL ret, id obj))completion
{
    if (![album.fetchResult isKindOfClass:[PHFetchResult class]]) {
        completion(NO,nil);return;
    }
    completion(YES,album.fetchResult);
}

- (void)getImageForPHAsset:(PHAsset *)asset
                  withSize:(CGSize)size
                completion:(void (^)(BOOL ret, UIImage *image))completion
{
    if (![asset isKindOfClass:[PHAsset class]]){
        completion(NO, nil); return;
    }
    NSInteger scale = [UIScreen mainScreen].scale;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(size.width*scale, size.height*scale) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completion(YES, result);
    }];
}

- (void)getImageForPHAsset:(PHAsset *)asset
                  withSize:(CGSize)size
                   options: (PHImageRequestOptions *)options
                completion:(void (^)(BOOL ret, UIImage *image))completion
{
    if (![asset isKindOfClass:[PHAsset class]]){
        completion(NO, nil); return;
    }
    NSInteger scale = [UIScreen mainScreen].scale;
    CGSize _size = CGSizeMake(size.width*scale, size.height*scale);
    if (_size.width>1024) {
        _size = CGSizeMake(1024, _size.height*1024/_size.width);
    }
    [[PHImageManager defaultManager] requestImageForAsset:asset
                            targetSize:_size
                           contentMode:PHImageContentModeAspectFit
                               options:options
                         resultHandler:^(UIImage *result, NSDictionary *info)
     {
         completion(YES, result);
     }];
}

- (BOOL)isContainSize:(CGSize)size
{
    NSInteger scale = [UIScreen mainScreen].scale;
    CGRect screen = [UIScreen mainScreen].bounds;
    CGRect maxFrame = CGRectMake(0, 0, screen.size.width*scale, screen.size.height*scale);
    BOOL isContains = CGRectContainsRect(maxFrame,CGRectMake(0, 0, size.width, size.height));
    return isContains;
}

- (CGSize)limitSize:(CGSize)size
{
    NSInteger scale = [UIScreen mainScreen].scale;
    CGRect screen = [UIScreen mainScreen].bounds;
    CGRect maxFrame = CGRectMake(0, 0, screen.size.width*scale, screen.size.height*scale);
    BOOL isContains = CGRectContainsRect(maxFrame,CGRectMake(0, 0, size.width, size.height));
    CGFloat width = size.width;
    CGFloat height = size.height;
    if (!isContains) {
        if (width>height) { //图片的宽大于高
            height = height*maxFrame.size.width/width;
            width = maxFrame.size.width;
        }else{
            width = width*maxFrame.size.height/height;
            height = maxFrame.size.height;
        }
    }
    return CGSizeMake(width, height);
}

- (void)getImageForPHAsset:(PHAsset *)asset
                completion:(void (^)(BOOL ret, UIImage *image))completion
{
    if (![asset isKindOfClass:[PHAsset class]]){
        completion(NO, nil); return;
    }
    PHImageRequestOptions *option = [PHImageRequestOptions new];
    option.synchronous = YES;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    NSInteger scale = [UIScreen mainScreen].scale;
    CGFloat width = scale*asset.pixelWidth;
    CGFloat height = scale*asset.pixelHeight;
    [[PHImageManager defaultManager] requestImageForAsset:asset
                            targetSize:[self limitSize:CGSizeMake(width, height)]
                           contentMode:PHImageContentModeAspectFit
                               options:option
                         resultHandler:^(UIImage *image, NSDictionary *info)
     {
         /*
          if (![self isContainSize:image.size]) {
          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          CGSize limitSize = [self limitSize:image.size];
          UIImage *new_image = [image resizedImage:CGRectMake(0, 0, limitSize.width, limitSize.height)];
          dispatch_async(dispatch_get_main_queue(), ^{
          completion(YES, new_image);
          });
          });
          }else{
          completion(YES, image);
          }
          */
         completion(YES, image);
     }];
}

- (void)getImageDataForPHAsset:(PHAsset *)asset
                    completion:(void (^)(BOOL ret, NSData *data))completion
{
    if (![asset isKindOfClass:[PHAsset class]]){
        completion(NO, nil); return;
    }
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        completion(YES,imageData);
    }];
}

- (void)getURLForPHAsset:(PHAsset *)asset
              completion:(void (^)(BOOL ret, NSURL *URL))completion
{
    if (![asset isKindOfClass:[PHAsset class]]){
        completion(NO, nil); return;
    }
    [asset requestContentEditingInputWithOptions:nil
                               completionHandler:^(PHContentEditingInput *contentEditingInput,
                                                   NSDictionary *info)
     {
         NSURL *imageURL = contentEditingInput.fullSizeImageURL;
         completion(YES, imageURL);
     }];
}

+ (UIImage*)getCaptureImage:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (BOOL)canUsePhoto
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (BOOL)canTakePhoto
{
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (void)requestPhotoLibraryAuthorizationBlock:(void (^) (BOOL flag))block
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if(status == PHAuthorizationStatusAuthorized){
        block(YES);
    }else if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
        block(NO);
    }else if (status == PHAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status) {
                        case PHAuthorizationStatusAuthorized:
                    {
                        block (YES);
                        break;
                    }
                        case PHAuthorizationStatusNotDetermined:
                        case PHAuthorizationStatusRestricted:
                        case PHAuthorizationStatusDenied:
                    {
                        block (NO);
                        break;
                    }
                    default:
                    {
                        block (NO);
                        break;
                    }
                }
            });
        }];
    }
}
    
@end
