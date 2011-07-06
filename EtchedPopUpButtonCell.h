
/* EtchedPopUpButtonCell */
// NOTE TO SELF: where did this come from?

#import <Cocoa/Cocoa.h>


@interface EtchedPopUpButtonCell : NSPopUpButtonCell {
	NSColor *mShadowColor;
}

-(void)setShadowColor:(NSColor *)aColor;

@end
