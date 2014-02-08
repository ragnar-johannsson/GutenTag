//
//  AppDelegate.h
//  GutenTag
//
//  Created by Ragnar B. Jóhannsson on 10/12/13.
//  Copyright (c) 2013 Ragnar B. Jóhannsson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HostServiceDiscoverer.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSNetServiceBrowserDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSNetServiceBrowser *serviceBrowser;
    HostServiceDiscoverer *discoverer;
}

@end
