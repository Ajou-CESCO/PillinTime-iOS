//
//  DIContainer.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/11/24.
//

import Foundation
import SwiftUI

import Factory
import Moya

extension Container {
    
    // MARK: - ViewModel
    
    var doseAddViewModel: Factory<DoseAddViewModel> {
        Factory(self) {
            DoseAddViewModel(planService: PlanService(provider: MoyaProvider<PlanAPI>()))
        }
        .singleton
    }
    
    var homeViewModel: Factory<HomeViewModel> {
        Factory(self) {
            HomeViewModel(etcService: EtcService(provider: MoyaProvider<EtcAPI>()), 
                          planService: PlanService(provider: MoyaProvider<PlanAPI>()), 
                          healthService: HealthService(provider: MoyaProvider<HealthAPI>()))
        }
        .singleton
    }
    
    var doseScheduleStatusViewModel: Factory<DoseScheduleStatusViewModel> {
        Factory(self) {
            DoseScheduleStatusViewModel(etcService: EtcService(provider: MoyaProvider<EtcAPI>()))
        }
        .singleton
    }
    
    // MARK: - Moya
    
    // MARK: - Etc
    
    var toastManager: Factory<ToastManager> {
        Factory(self) {
            ToastManager()
        }
        .singleton
    }
    
    // MARK: - Service
    
    var caseService: Factory<CaseServiceType> {
        Factory(self) {
            CaseService(provider: MoyaProvider<CaseAPI>())
        }
        .singleton
    }
    
    var userService: Factory<UserServiceType> {
        Factory(self) {
            UserService(provider: MoyaProvider<UserAPI>())
        }
        .singleton
    }
    
    var authService: Factory<AuthServiceType> {
        Factory(self) {
            AuthService(provider: MoyaProvider<AuthAPI>())
        }
        .singleton
    }
    
    var validationService: Factory<ValidationServiceType> {
        Factory(self) {
            ValidationService()
        }
        .singleton
    }
    
    var requestServie: Factory<RequestServiceType> {
        Factory(self) {
            RequestService(provider: MoyaProvider<RequestAPI>())
        }
        .singleton
    }
    
    var relationService: Factory<RelationServiceType> {
        Factory(self) {
            RelationService(provider: MoyaProvider<RelationAPI>())
        }
        .singleton
    }
    
    var planService: Factory<PlanServiceType> {
        Factory(self) {
            PlanService(provider: MoyaProvider<PlanAPI>())
        }
        .singleton
    }
    
    var fcmService: Factory<FcmServiceType> {
        Factory(self) {
            FcmService(provider: MoyaProvider<FcmAPI>())
        }
        .singleton
    }
    
    var etcService: Factory<EtcServiceType> {
        Factory(self) {
            EtcService(provider: MoyaProvider<EtcAPI>())
        }
        .singleton
    }
    
    var healthService: Factory<HealthServiceType> {
        Factory(self) {
            HealthService(provider: MoyaProvider<HealthAPI>())
        }
        .singleton
    }
    
    var paymentService: Factory<PaymentServiceType> {
        Factory(self) {
            PaymentService(provider: MoyaProvider<PaymentAPI>())
        }
        .singleton
    }
    
    // MARK: - HealthKit
    
    var hkService: Factory<HKServiceProtocol> {
        Factory(self) {
            HKService(provider: HKProvider(), core: HKSleepCore())
        }
        .singleton
    }
}
