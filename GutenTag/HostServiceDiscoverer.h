//
//  HostServiceDiscoverer.h
//  GutenTag
//
//  Created by Ragnar B. Jóhannsson on 10/15/13.
//  Copyright (c) 2013 Ragnar B. Jóhannsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HostServiceDiscoverer : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate, NSUserNotificationCenterDelegate> {
    NSMutableDictionary *serviceBrowserDict;
    NSMutableDictionary *servicesDict;
    NSMutableDictionary *hostsDict;
}

- (void)addService:(NSNetService *)netService;

@end
