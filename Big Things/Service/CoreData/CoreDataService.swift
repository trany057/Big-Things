//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import Foundation
import CoreData

class CoreDataService {
    
    static let shared = CoreDataService()
    
    private init() {}
    
    func context() -> NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }
    
    func save(entity: NSManagedObject, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try context().save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func delete<T: NSManagedObject>(entity: T, completion: @escaping (Result<Void, Error>) -> Void) {
        context().delete(entity)
        save(entity: entity, completion: completion)
    }
    
    func fetchAll<T: NSManagedObject>(entityName: String, completion: @escaping (Result<[T], Error>) -> Void) {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)

        do {
            let results = try context().fetch(fetchRequest)
            completion(.success(results))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetch<T: NSManagedObject>(entityName: String, by predicate: NSPredicate, completion: @escaping (Result<[T], Error>) -> Void) {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate

        do {
            let results = try context().fetch(fetchRequest)
            completion(.success(results))
        } catch {
            completion(.failure(error))
        }
    }
}
