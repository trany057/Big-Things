//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import Foundation

protocol BigThingsRepositoryType {
    func getListBigThing(completion: @escaping(Result<[BigThing], Error>) -> Void)
    func getImageBigThing(nameImage: String, completion: @escaping (Result<Data, Error>) -> Void)
}

struct BigThingsRepository: BigThingsRepositoryType {
    
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func getListBigThing(completion: @escaping (Result<[BigThing], any Error>) -> Void) {
        let urlString = "https://www.partiklezoo.com/bigthings/?fbclid=IwZXh0bgNhZW0CMTAAAR2CUz_N-dW1LsrW1UEpTB4FEk9nyDy7p1d5xAul11H5SYm3nCG_-3po6Bw_aem_aB8ekuh2q7b3IflKw6EsjA"
        apiService.fetchData(urlString: urlString, completion: completion)
    }
    
    func getImageBigThing(nameImage: String, completion: @escaping (Result<Data, any Error>) -> Void) {
        let urlString = "https://www.partiklezoo.com/bigthings/images/\(nameImage)"
        apiService.fetchImage(urlString: urlString, completion: completion)
    }
}
