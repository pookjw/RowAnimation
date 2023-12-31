//
//  SceneDelegate.mm
//  RowAnimation
//
//  Created by Jinwoo Kim on 12/30/23.
//

#import "SceneDelegate.hpp"
#import "RootViewController.hpp"

@implementation SceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:static_cast<UIWindowScene *>(scene)];
    RootViewController *rootViewController = [RootViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [rootViewController release];
    window.rootViewController = navigationController;
    [navigationController release];
    [window makeKeyAndVisible];
    self.window = window;
    [window release];
}

@end
