//
//  PDURLTextField.m
//  SproutedInterface
//
//  Created by Philip Dow on 5/28/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDURLTextField.h>
#import <SproutedInterface/PDURLTextFieldCell.h>
#import <SproutedUtilities/PDUtilityDefinitions.h>

#define kWebURLsWithTitlesPboardType @"WebURLsWithTitlesPboardType"

static NSString *kFileURLIdentifier = @"file://";

@implementation PDURLTextField


- (id)initWithCoder:(NSCoder *)decoder {
	
	if ( self = [super initWithCoder:decoder] ) {
		
		NSArchiver * anArchiver = [[[NSArchiver alloc] 
				initForWritingWithMutableData:[NSMutableData dataWithCapacity: 256]] autorelease];
		[anArchiver encodeClassName:@"NSTextFieldCell" intoClassName:@"PDURLTextFieldCell"];
		[anArchiver encodeRootObject:[self cell]];
		[self setCell:[NSUnarchiver unarchiveObjectWithData:[anArchiver archiverData]]];
		
		_url_title = [[NSString alloc] init];
		[self setImage:[PDURLTextField defaultImage]];
		
	}
	
	return self;
}


+ (Class) cellClass
{
    return [PDURLTextFieldCell class];
}

- (void) dealloc {
	[_url_title release];
	_url_title = nil;
	[super dealloc];
}

#pragma mark -

+ (NSImage*) defaultImage 
{
	return BundledImageWithName(@"PDURLTextFieldWebDefault.tiff", @"com.sprouted.interface");
}


- (void)setStringValue:(NSString *)aString {
	[super setStringValue:aString];
	if ( [[self stringValue] rangeOfString:kFileURLIdentifier options:NSCaseInsensitiveSearch].location == 0 )
		[self setImage:BundledImageWithName(@"PDURLTextFieldFileDefault.png", @"com.sprouted.interface")];
	[self setURLTitle:nil];
}

- (void)setObjectValue:(id <NSCopying>)object 
{
	[super setObjectValue:object];
	if ( [[self stringValue] rangeOfString:kFileURLIdentifier options:NSCaseInsensitiveSearch].location == 0 )
		[self setImage:BundledImageWithName(@"PDURLTextFieldFileDefault.png", @"com.sprouted.interface")];
	[self setURLTitle:nil];
}

- (NSString*)URLTitle { 
	if (_url_title != nil && [_url_title length] != 0 )
		return _url_title;
	else
		return [self stringValue];
}

- (void) setURLTitle:(NSString*)aTitle {
	if ( _url_title != aTitle ) {
		[_url_title release];
		_url_title = [aTitle copyWithZone:[self zone]];
	}
}

- (NSImage*) image { return [[self cell] image]; }

- (void) setImage:(NSImage*)anImage { 
	[[self cell] setImage:anImage];
}

- (double) estimatedProgress { return [[self cell] estimatedProgress]; }

- (void) setEstimatedProgress:(double)estimate {
	[[self cell] setEstimatedProgress:estimate];
	[self setNeedsDisplay:YES];
}

#pragma mark -

- (void)mouseDragged:(NSEvent *)theEvent
{
    static int kTextOffest = 4.0;
	
	// do not execute a drag if there is nothing to drag
	if ( [self stringValue] == nil || [[self stringValue] length] == 0 ) return;
	
	NSPoint image_location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSPasteboard *pboard = [NSPasteboard pasteboardWithName:NSDragPboard];
	
	NSImage *my_image = [[self image] copyWithZone:[self zone]];;
	NSString *drag_title = [self URLTitle];
	if ( !drag_title || [drag_title length] == 0 ) drag_title = [self stringValue];
	
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
			[self font], NSFontAttributeName, 
			[NSColor colorWithCalibratedWhite:0.2 alpha:1.0], NSForegroundColorAttributeName, nil];
	
	NSSize image_size = [my_image size];
	NSSize title_size = [drag_title sizeWithAttributes:attributes];
	NSSize total_size = NSMakeSize( (image_size.width + kTextOffest + title_size.width), 
									(image_size.height > title_size.height ? image_size.height : title_size.height) );
	
	NSSize drag_offset = NSMakeSize(image_size.width/2, image_size.height/2);
	image_location.x -= drag_offset.width;
	image_location.y += drag_offset.height;
	
	NSImage *drag_image = [[NSImage alloc] initWithSize:total_size];
	[my_image setFlipped:[drag_image isFlipped]];
	
	[drag_image lockFocus];
	
	[my_image compositeToPoint:NSZeroPoint operation:NSCompositeSourceOver];
	[drag_title drawAtPoint:NSMakePoint(image_size.width+kTextOffest,0) withAttributes:attributes];
	
	[drag_image unlockFocus];
	
	NSArray *types = [NSArray arrayWithObjects:
			kWebURLsWithTitlesPboardType, NSURLPboardType, nil];
			
	NSURL *url = [NSURL URLWithString:[self stringValue]];
	
	NSArray *url_array = [NSArray arrayWithObjects:[self stringValue],nil];
	NSArray *title_array = [NSArray arrayWithObjects:drag_title, nil];
	NSArray *web_urls_array = [NSArray arrayWithObjects:url_array,title_array,nil];
	
    [pboard declareTypes:types owner:self];
	
	[pboard setPropertyList:web_urls_array forType:kWebURLsWithTitlesPboardType];
    [url writeToPasteboard:pboard];
	
    [self dragImage:drag_image at:image_location offset:NSMakeSize(0.0,0.0) 
        event:theEvent pasteboard:pboard source:self slideBack:YES];
	
	[my_image release];
	[drag_image release];
	
    return;
}

@end
