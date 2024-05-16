//
//  SignUpRequestViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/11/24.
//

import Foundation
import Combine

import Factory

class SignUpRequestViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.authService) var authService: AuthServiceType
    var eventToValidationViewModel = PassthroughSubject<SignUpRequestViewModelEvent, Never>()
    var eventFromValidationViewModel: PassthroughSubject<SignUpValidationViewModelEvent, Never>?
    
    // MARK: - Input State
    @Subject var tapSignUpButton: Void = ()
    @Subject var tapSignInButton: Void = ()
    
    // MARK: - Output State
    @Published var signUpState: SignUpState = SignUpState()
    
    // MARK: - Other Data
    @Published var isLoginSucced: Bool = false
    @Published var isLoginFailed: Bool = false
    @Published var isNetworking: Bool = false
    
    // MARK: - Cancellable Bag
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constructor
    
    init(authService: AuthService) {
        self.authService = authService
        self.bindState()
        self.bindEvent()
    }
    
    // MARK: - Bind Method
    
    private func bindState() {
        // 회원가입에 해당하는 버튼 (프로필 생성 후 마지막 다음 버튼을 누를 경우) input 정보를 받아오기 위해 ValidationViewModel에 요청 보내기
        $tapSignUpButton.sink { [weak self] in
            self?.eventToValidationViewModel.send(.signUp)
        }
        .store(in: &cancellables)
        
        // 로그인에 해당하는 버튼
        $tapSignInButton.sink { [weak self] in
            self?.eventToValidationViewModel.send(.signIn)
        }
        .store(in: &cancellables)
    }
    
    func bindEvent() {
        eventFromValidationViewModel?.sink { [weak self] (event: SignUpValidationViewModelEvent) in
            guard let self = self else { return }
            
            switch event {
            case .phoneNumberValid:
                return
            case .phoneNumberInvalid:
                return
            case .nameValid:
                return
            case .nameInvalid:
                return
            case .ssnValid:
                return
            case .ssnInvalid:
                return
            case .sendInfoForSignUp(let info):
                self.requestSignUp(SignUpRequestModel(name: info.name,
                                                      ssn: String(info.ssn.prefix(8)),
                                                      phone: info.phoneNumber,
                                                      isManager: UserManager.shared.isManager ?? true))
            case .sendInfoForSignIn(let info):
                self.requestSignIn(SignInRequestModel(name: info.name,
                                                      phone: info.phoneNumber,
                                                      ssn: String(info.ssn.prefix(8))))
            }
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Request Method
    
    func requestSignIn(_ signInModel: SignInRequestModel) {
        print("로그인 요청 시작: \(signInModel)")
        self.isNetworking = true
        authService.requestSignIn(signInRequestModel: signInModel)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isNetworking = false
                switch completion {
                case .finished:
                    print("로그인 요청 완료")
                    self.isLoginSucced = true
                case .failure(let error):
                    print("로그인 요청 실패: \(error)")
                    /// 사용자가 회원가입 절차가 필요한 경우
                    if case AuthError.signIn(.userNotFound) = error {
                        self.isLoginSucced = false
                        self.isLoginFailed = true
                        print(AuthError.signIn(.userNotFound).description)
                    }
                    self.signUpState.failMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] result in
                print("로그인 성공: ", result)
                guard let self = self else { return }
                /// 성공적으로 로그인을 완료했으므로, 사용자 정보를 로컬에 저장
                let userManager = UserManager.shared
                userManager.name = signInModel.name
                userManager.phoneNumber = signInModel.phone
                userManager.ssn = String(signInModel.ssn.prefix(8))
                userManager.accessToken = result.result.accessToken
                // 유저타입 저장하기 추가
                self.signUpState.failMessage = String()
            })
            .store(in: &cancellables)
    }
    
    func requestSignUp(_ signUpModel: SignUpRequestModel) {
        print("회원가입 요청 시작: \(signUpModel)")
        authService.requestSignUp(signUpRequestModel: signUpModel)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("회원가입 요청 완료")
                case .failure(let error):
                    print("회원가입 요청 실패: \(error)")
                    self.signUpState.failMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] result in
                print("회원가입 성공: ", result)
                guard let self = self else { return }
                /// 성공적으로 회원가입을 완료했으므로, 사용자 정보를 로컬에 저장
                let userManager = UserManager.shared
                userManager.name = signUpModel.name
                userManager.phoneNumber = signUpModel.phone
                userManager.ssn = String(signUpModel.ssn.prefix(8))
                userManager.accessToken = result.result.accessToken
                userManager.isManager = signUpModel.isManager
                self.signUpState.failMessage = String()
            })
            .store(in: &cancellables)
    }
}
