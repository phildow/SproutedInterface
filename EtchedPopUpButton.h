
/* EtchedPopUpButton */
// NOTE TO SELF: where did this come from?

#import <Cocoa/Cocoa.h>


@interface EtchedPopUpButton : NSPopUpButton {

}

+ (Class)cellClass;
-(void)setShadowColor:(NSColor *)color;

@end
