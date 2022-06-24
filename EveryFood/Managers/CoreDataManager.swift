//
//  CoreDataManager.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 23.06.2022.
//

import Foundation
import CoreData

protocol ICoreDataManager {
    func saveContext()
}

protocol ICartStorage {
    func addToCart(cartItem: FoodDataDTO)
}

final class CoreDataManager {
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EveryFood")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return self.container.viewContext
    }
}

extension CoreDataManager: ICoreDataManager {
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataManager: ICartStorage {
    func addToCart(cartItem: FoodDataDTO) {
        container.performBackgroundTask { context in
            let cartObject = CartEntity(context: context)
            cartObject.id = cartItem.id
            cartObject.title = cartItem.title
            cartObject.price = Int16(cartItem.price)
            cartObject.image = cartItem.images.first
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func removeCartItem(cartItem: FoodModel) {
        container.performBackgroundTask {context in
            let fetchRequest: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "\(#keyPath(CartEntity.id)) = %@",
//                                                 cartItem.id)
            fetchRequest.predicate = NSPredicate(format: "%K = %@", (\CartEntity.id)._kvcKeyPathString!, cartItem.id!)
            do {
                if let object = try context.fetch(fetchRequest).first {
                    context.delete(object)
                }
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadCartItems(completion: @escaping (Result<[FoodModel], Error>) -> Void) {
        let request: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
        do {
            let foodModels = try viewContext.fetch(request).compactMap{
                FoodModel(coreDataModel: $0)
            }
            completion(.success(foodModels))
        }
        catch {
            completion(.failure(error))
        }
    }
}
