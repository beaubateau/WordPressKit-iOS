#import <Foundation/Foundation.h>

@interface RemotePostCategory : NSObject
@property (nonatomic, strong) NSNumber *categoryID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *parentID;
@property (nonatomic, strong) NSString *slug;
@end
