//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import Foundation

protocol BigThingsRepositoryType {
    func getListBigThing(completion: @escaping(Result<[BigThing], Error>) -> Void)
    func getImageBigThing(nameImage: String, completion: @escaping (Result<Data, Error>) -> Void)
    func submitRatingBigThing(id: Int, rating: Int, completion: @escaping((Result<Submit, Error>) -> Void))
    
    // Core Data Operations
    func getSavedBigThing(byId id: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func getSavedBigThings(completion: @escaping (Result<[BigThing], Error>) -> Void)
    func saveBigThing(_ bigThing: BigThing, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteBigThing(_ bigThing: BigThing, completion: @escaping (Result<Void, Error>) -> Void)
    func saveRating(byId id: String, rating: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func getSavedRating(byId id: String, completion: @escaping (Result<Int16, Error>) -> Void)
}

struct BigThingsRepository: BigThingsRepositoryType {
    
    private let apiService: APIService
    private let coreDataService: CoreDataService
    
    init(apiService: APIService, coreDataService: CoreDataService = CoreDataService.shared) {
        self.apiService = apiService
        self.coreDataService = coreDataService
    }
    
    func getListBigThing(completion: @escaping (Result<[BigThing], Error>) -> Void) {
        let urlString = "https://www.partiklezoo.com/bigthings/?fbclid=IwZXh0bgNhZW0CMTAAAR2CUz_N-dW1LsrW1UEpTB4FEk9nyDy7p1d5xAul11H5SYm3nCG_-3po6Bw_aem_aB8ekuh2q7b3IflKw6EsjA"
        apiService.fetchData(urlString: urlString, completion: completion)
    }
    
    func getImageBigThing(nameImage: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = "https://www.partiklezoo.com/bigthings/images/\(nameImage)"
        apiService.fetchImage(urlString: urlString, completion: completion)
    }
    
    func submitRatingBigThing(id: Int, rating: Int, completion: @escaping((Result<Submit, Error>) -> Void)) {
        let urlString = "https://www.partiklezoo.com/bigthings/?action=rate&id=\(id)&rating=\(rating)"
        apiService.fetchData(urlString: urlString, completion: completion)
    }
    

    // Core Data Operations
    func getSavedBigThing(byId id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let predicate = NSPredicate(format: "id == %@", id)
        coreDataService.fetch(entityName: "BigThingEntity", by: predicate) { (result: Result<[BigThingEntity], Error>) in
            switch result {
            case .success(let bigThingEntities):
                if bigThingEntities.first != nil {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSavedBigThings(completion: @escaping (Result<[BigThing], Error>) -> Void) {
        coreDataService.fetchAll(entityName: "BigThingEntity") { (result: Result<[BigThingEntity], Error>) in
            switch result {
            case .success(let bigThingEntities):
                let bigThings = bigThingEntities.map { $0.toModel() }
                completion(.success(bigThings))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveBigThing(_ bigThing: BigThing, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coreDataService.context()
        let bigThingEntity = bigThing.toEntity(context: context)
        coreDataService.save(entity: bigThingEntity) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteBigThing(_ bigThing: BigThing, completion: @escaping (Result<Void, Error>) -> Void) {
        let predicate = NSPredicate(format: "id == %@", bigThing.id)

        coreDataService.fetch(entityName: "BigThingEntity", by: predicate) { (result: Result<[BigThingEntity], Error>) in
            switch result {
            case .success(let bigThingEntities):
                guard let entityToDelete = bigThingEntities.first else {
                    return
                }
                coreDataService.delete(entity: entityToDelete) { deleteResult in
                    switch deleteResult {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
     func saveRating(byId id: String, rating: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let predicate = NSPredicate(format: "id == %@", id)
        coreDataService.fetch(entityName: "BigThingEntity", by: predicate) { (result: Result<[BigThingEntity], Error>) in
            switch result {
            case .success(let bigThingEntities):
                if !bigThingEntities.isEmpty {
                    for entity in bigThingEntities {
                        entity.myRating = Int16(rating)
                    }
                    coreDataService.saveContext { saveResult in
                        switch saveResult {
                        case .success:
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Entity not found."])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSavedRating(byId id: String, completion: @escaping (Result<Int16, any Error>) -> Void) {
        let predicate = NSPredicate(format: "id == %@", id)
        coreDataService.fetch(entityName: "BigThingEntity", by: predicate) { (result: Result<[BigThingEntity], Error>) in
            switch result {
            case .success(let bigThingEntities):
                guard let bigThingEnity = bigThingEntities.first else {
                    return
                }
                completion(.success(bigThingEnity.myRating))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
