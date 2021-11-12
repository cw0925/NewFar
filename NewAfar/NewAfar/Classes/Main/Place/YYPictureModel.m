

#import "YYPictureModel.h"

@implementation YYPictureModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)pictureWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
}


@end
