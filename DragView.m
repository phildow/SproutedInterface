//
//  DragView.m
//  SproutedInterface
//
//  Created by Philip Dow on 9/14/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/DragView.h>

@implementation DragView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
}

- (BOOL)mouseDownCanMoveWindow {
	return NO;
}

@end
