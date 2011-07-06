
/* EtchedPopUpButton */
// NOTE TO SELF: where did this come from?

#import <SproutedInterface/EtchedPopUpButton.h>
#import <SproutedInterface/EtchedPopUpButtonCell.h>

@implementation EtchedPopUpButton

+ (Class)cellClass
{
	return [EtchedPopUpButtonCell class];
}

- initWithCoder: (NSCoder *)origCoder
{
	if(![origCoder isKindOfClass: [NSKeyedUnarchiver class]]){
		self = [super initWithCoder: origCoder]; 
	} else {
		NSKeyedUnarchiver *coder = (id)origCoder;
		
		NSString *oldClassName = [[[self superclass] cellClass] className];
		Class oldClass = [coder classForClassName: oldClassName];
		if(!oldClass)
			oldClass = [[super superclass] cellClass];
		[coder setClass: [[self class] cellClass] forClassName: oldClassName];
		self = [super initWithCoder: coder];
		[coder setClass: oldClass forClassName: oldClassName];
		
		[self setShadowColor:[NSColor whiteColor]];
	}
	
	return self;
}

-(void)setShadowColor:(NSColor *)color
{
	EtchedPopUpButtonCell *cell = [self cell];
	[cell setShadowColor:color];
}


@end
