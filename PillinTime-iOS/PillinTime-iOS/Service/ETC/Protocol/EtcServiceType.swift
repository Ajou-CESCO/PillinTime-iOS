//
//  EtcServiceType.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import Foundation
import Combine
import Moya

/// 기타 API Service입니다.
protocol EtcServiceType {
    
    /// 사용자 입력값을 통해 약물 정보를 검색합니다.
    ///
    /// - Parameters:
    ///     - name: 검색하고자 하는 검색어입니다.
    ///     - memberId: 부작용 조회를 위해 필요한 memberId입니다.
    /// - Returns:
    ///     - SearchDoseResponseModel: 검색 결과 정보를 담은 Model입니다.
    func searchDose(memberId: Int, name: String) -> AnyPublisher<SearchDoseResponseModel, PillinTimeError>
    
    /// 사용자에 대한 초기 정보를 받아옵니다.
    ///
    /// - Parameters: 없음
    /// - Returns:
    ///     - InitResponseModel: 사용자에 대한 초기 정보를 담은 Model입니다.
    func initClient() -> AnyPublisher<InitResponseModel, PillinTimeError>
    
    /// 캡디 시연용 임시 bug report
    func bugReport(body: String) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError>
    
    /// 약물 ID를 통해 약물 정보를 검색합니다.
    ///
    /// - Parameters:
    ///     - medicineId: 검색하고자 하는 약물의 Id입니다.
    /// - Returns:
    ///     - SearchDoseByIdResponseModel: 검색 결과 정보를 담은 Model입니다.
    func searchDoseById(medicineId: String) -> AnyPublisher<SearchDoseByIdResponseModel, PillinTimeError>
}
