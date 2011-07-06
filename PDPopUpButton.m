//
//  PDPopupButton.m
//  SproutedInterface
//
//  Created by Philip Dow on 12/10/05.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDPopUpButton.h>
#import <SproutedInterface/PDPopUpButtonCell.h>

@implementation PDPopUpButton

- (id)initWithCoder:(NSCoder *)decoder {
	
	/*
	NSKeyedUnarchiver *coder = (id)decoder;
		
	// gather info about the superclass's cell and save the archiver's old mapping
	Class superCell = [[self superclass] cellClass];
	NSString *oldClassName = NSStringFromClass( superCell );
	
	NSLog(@"%@ -> %@", oldClassName, NSStringFromClass([[self class] cellClass]));
	
	Class oldClass = [coder classForClassName: oldClassName];
	if( !oldClass ) oldClass = superCell;
	
	// override what comes out of the unarchiver
	[coder setClass: [[self class] cellClass] forClassName: oldClassName];
	
	// unarchive
	self = [super initWithCoder: coder];
	
	// set it back
	//[coder setClass: oldClass forClassName: oldClassName];
	
	NSLog([[self cell] className]);
	*/
	
	/*
	if ( self = [super initWithCoder:decoder] ) {
		
		NSArchiver * anArchiver = [[[NSArchiver alloc] 
				initForWritingWithMutableData:[NSMutableData dataWithCapacity: 256]] autorelease];
		
		[anArchiver encodeClassName:@"NSPopUpButtonCell" intoClassName:@"PDPopUpButtonCell"];
		[anArchiver encodeRootObject:[self cell]];
		
		[self setCell:[NSUnarchiver unarchiveObjectWithData:[anArchiver archiverData]]];
		
	}
	*/
	
	if ( self = [super initWithCoder:decoder] ) {
		NSMenu *theMenu = [[self menu] copyWithZone:[self zone]];
		[self setCell:[[[PDPopUpButtonCell alloc] 
				initTextCell:[self title] 
				pullsDown:[self pullsDown]] autorelease]];
		[self setMenu:theMenu];
		[theMenu release];
	}
		
	return self;
}


- (void) awakeFromNib {
	
	[[self cell] setMenu:[self menu]];
	
}


+ (Class) cellClass
{
    return [PDPopUpButtonCell class];
}


//- (BOOL) isFlipped { return YES; }

- (BOOL)isOpaque { return NO; }


@end
