//
//  AppDelegate.h
//  Pregnancy
//
//  Created by giming on 2014/3/1.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IIViewDeckController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;


// 增加Core Data的成員變數property定義
@property (retain, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (retain, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (retain, nonatomic) NSManagedObjectModel* managedObjectModel;


// 將物件同步進Core Data
- (void)saveContext;
// 傳回這個應用程式目錄底下的Documents子目錄
- (NSURL *)applicationDocumentsDirectory;
// 傳回這個應用程式中管理資料庫的Persistent Store Coordinator物件
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator;
// 傳回這個應用程式中的物件模型管理員，負責讀取data model
- (NSManagedObjectModel*) managedObjectModel;
// 傳回這個應用程式的物件本文管理員，用來作物件的同步
- (NSManagedObjectContext*) managedObjectContext;


@property (retain, nonatomic) UIViewController *centerController;
@property (retain, nonatomic) UIViewController *rightController;


@property int setupType;

- (IIViewDeckController*)generateControllerStack;

@end
