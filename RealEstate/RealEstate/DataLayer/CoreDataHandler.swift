//
//  CoreDataHandler.swift
//  RealEstate
//
//  Created by Amr ELghadban on 6/16/18.
//  Copyright © 2018 ADKA. All rights reserved.
//

import Foundation

import UIKit
import CoreData

class CoreDataHandler: NSObject {

    static let shared = CoreDataHandler()

    static let RealEstateEntity = "RealEstateManaged"
    static let LocationEntity = "LocationManaged"
    static let Filename = "RealEstate"

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: CoreDataHandler.Filename)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Adding More Helpers

    func createManagedObject( entityName: String ) -> NSManagedObject {

        let managedContext =
            CoreDataHandler.shared.persistentContainer.viewContext

        let entity =
            NSEntityDescription.entity(forEntityName: entityName,
                                       in: managedContext)!

        let item = NSManagedObject(entity: entity,
                                   insertInto: managedContext)

        return item

    }

    func saveDatabase(completion:(_ result: Bool ) -> Void) {

        let managedContext =
            CoreDataHandler.shared.persistentContainer.viewContext

        do {
            try managedContext.save()

            completion(true)

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(false)
        }

    }

    func deleteManagedObject( managedObject: NSManagedObject, completion:(_ result: Bool ) -> Void) {

        let managedContext =
            CoreDataHandler.shared.persistentContainer.viewContext

        managedContext.delete(managedObject)

        do {
            try managedContext.save()

            completion(true)

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(false)
        }

    }
}

extension CoreDataHandler {
    func saveRealEstate(_ data: RealEstate) -> Bool {

        // 1
        let managedContext = CoreDataHandler.shared.persistentContainer.viewContext

        // 2
        let entityLocationManged =
            NSEntityDescription.entity(forEntityName: CoreDataHandler.LocationEntity,
                                       in: managedContext)!

        let location = NSManagedObject(entity: entityLocationManged,
                                       insertInto: managedContext)

        location.setValue(data.location?.address, forKey: "address")
        location.setValue(data.location?.latitude, forKey: "latitude")
        location.setValue(data.location?.longitude, forKey: "longitude")

        // 2
        let entityRealEstateManged =
            NSEntityDescription.entity(forEntityName: CoreDataHandler.RealEstateEntity,
                                       in: managedContext)!

        let realEstate = NSManagedObject(entity: entityRealEstateManged,
                                         insertInto: managedContext)

        // 3
        realEstate.setValue(data.id, forKeyPath: "id")
        realEstate.setValue(data.title, forKey: "title")
        realEstate.setValue(data.price, forKey: "price")
        realEstate.setValue(location, forKey: "location")

        // 4
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }

     func deleteRealEstate(WithId id: Int) -> Bool {
        // 1
        let managedContext = CoreDataHandler.shared.persistentContainer.viewContext

        // 2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: CoreDataHandler.RealEstateEntity)

        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        fetchRequest.returnsObjectsAsFaults = false

        // 3
        var resultArray: [NSManagedObject] = []
        do {
            resultArray = try managedContext.fetch(fetchRequest)
            for object in resultArray {
                managedContext.delete(object)
            }
            resultArray = try managedContext.fetch(fetchRequest)
            return resultArray.isEmpty
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }

     func isRealEstateExist(_ data: RealEstate) -> Bool {
        //1
        let managedContext = CoreDataHandler.shared.persistentContainer.viewContext

        // 2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: CoreDataHandler.RealEstateEntity)

        guard let realEstatId = data.id else {
            return false
        }
        fetchRequest.predicate = NSPredicate(format: "id = %d", realEstatId)
        fetchRequest.returnsObjectsAsFaults = false

        // 3
        var resultArray: [NSManagedObject] = []
        do {
            resultArray = try managedContext.fetch(fetchRequest)
            let isExist = resultArray.first != nil ? true : false
            return isExist
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }

     func allRealEstates() -> [NSManagedObject]? {
        // 1

        let managedContext = CoreDataHandler.shared.persistentContainer.viewContext

        // 2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: CoreDataHandler.RealEstateEntity)

        // 3
        var resultArray: [NSManagedObject] = []
        do {
            resultArray = try managedContext.fetch(fetchRequest)
            return resultArray
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}
