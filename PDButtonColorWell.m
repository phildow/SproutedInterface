//
//  PDButtonColorWell.m
//  SproutedInterface
//
//  Created by Philip Dow on 1/7/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDButtonColorWell.h>
#import <SproutedInterface/PDButtonColorWellCell.h>


@implementation PDButtonColorWell

- (id)initWithCoder:(NSCoder *)decoder {
	
	if ( self = [super initWithCoder:decoder] ) {
		
		NSArchiver * anArchiver = [[[NSArchiver alloc] initForWritingWithMutableData:[NSMutableData dataWithCapacity: 256]] autorelease];
		[anArchiver encodeClassName:@"NSButtonCell" intoClassName:@"PDButtonColorWellCell"];
		[anArchiver encodeRootObject:[self cell]];
		[self setCell:[NSUnarchiver unarchiveObjectWithData:[anArchiver archiverData]]];
	}
	
	return self;
}

- (void) dealloc
{
	[defaultsKey release];
	[super dealloc];
}


+ (Class) cellClass
{
    return [PDButtonColorWellCell class];
}

- (BOOL) isFlipped 
{ 
	return YES; 
}

- (NSColor*) color 
{
	return [[self cell] color];
}

- (void) setColor:(NSColor*)color 
{
	[self willChangeValueForKey:@"color"];
	[[self cell] setColor:color];
	[self didChangeValueForKey:@"color"];
	
	[self setNeedsDisplay:YES];
}

- (NSString*) defaultsKey
{
	return defaultsKey;
}

- (void) setDefaultsKey:(NSString*)aKey
{
	if ( defaultsKey != aKey )
	{
		[self willChangeValueForKey:@"defaultsKey"];
		[defaultsKey release];
		defaultsKey = [aKey copyWithZone:[self zone]];
		[self didChangeValueForKey:@"defaultsKey"];
		
		[self unbind:@"color"];
		[self bind:@"color" 
				toObject:[NSUserDefaultsController sharedUserDefaultsController] 
				withKeyPath:[NSString stringWithFormat:@"values.%@",defaultsKey] 
				options:[NSDictionary dictionaryWithObjectsAndKeys:
						NSUnarchiveFromDataTransformerName, NSValueTransformerNameBindingOption, nil]];
	}
}


@end
