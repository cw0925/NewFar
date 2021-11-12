
#import <Foundation/Foundation.h>

@interface YYPictureModel : NSObject

//@property (copy, nonatomic) NSString *icon;
@property(nonatomic,strong)UIImage *icon;
@property (copy, nonatomic) NSString *btnImage;
@property (assign, nonatomic, getter=isClickedBtn) BOOL clickedBtn;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)pictureWithDict:(NSDictionary *)dict;


@end
