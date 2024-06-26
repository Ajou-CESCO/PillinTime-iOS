//
//  RequestService.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/15/24.
//

import Foundation
import Moya
import CombineMoya
import Combine

class RequestService: RequestServiceType {
    
    let provider: MoyaProvider<RequestAPI>
    var cancellables = Set<AnyCancellable>()
    
    init(provider: MoyaProvider<RequestAPI>, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.provider = provider
        self.cancellables = cancellables
    }
    
    /// 보호 관계 요청
    func relationRequest(receiverPhone: String) -> AnyPublisher<RequestRelationResponseModel, RelationError> {
        return provider.requestPublisher(.requestRelation(receiverPhone))
            .tryMap { response in
                let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                
                if let status = json?["status"] as? Int, status == 40008 {
                    throw RelationError.createRelation(.duplicatedUser)
                }
                
                let decodedData = try response.map(RequestRelationResponseModel.self)
                return decodedData
            }
            .mapError { error in
                print("error:", error)
                if error is MoyaError {
                    return RelationError.createRelation(.duplicatedUser)
                } else {
                    return error as! RelationError
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// 보호 관계 요청 리스트 조회 요청
    func relationRequestList() -> AnyPublisher<RelationRequestListResponseModel, PillinTimeError> {
        return provider.requestPublisher(.relationRequestList)
            .tryMap { response in
                let decodedData = try response.map(RelationRequestListResponseModel.self)
                return decodedData
            }
            .mapError { error in
                print("error:", error)
                if error is MoyaError {
                    return PillinTimeError.networkFail
                } else {
                    return error as! PillinTimeError
                }
            }
            .eraseToAnyPublisher()
    }
}
