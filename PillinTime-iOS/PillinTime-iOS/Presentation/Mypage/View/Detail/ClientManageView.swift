//
//  ClientManageView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/15/24.
//

import SwiftUI 

import Moya
import Factory

struct SelectedRelation: Identifiable {
    let id = UUID()
    let relationId: Int
    let name: String
    let ssn: String
    let phone: String
    let cabinetId: Int
}

// MARK: - ClientManageView

struct ClientManageView: View {
    
    // MARK: - Properties
    
    @ObservedObject var clientManageViewModel: ClientManageViewModel
    @ObservedObject var managementMyInformationViewModel: ManagementMyInformationViewModel
    @State var isDeletePopUp: Bool = false
    @State var isRequestRelationPopUp: Bool = false
    @State var showInformationView: Bool = false
    @State var selectedRelation: SelectedRelation?
    @State var selectedDeleteRelation: SelectedRelation?
    @State var showToastView: Bool = false
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            Color.white
            
            VStack {
                HStack {
                    Text("총 \(clientManageViewModel.relationList.count)명")
                        .font(.h5Bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .bottom], 20)
                    
                    Button(action: {
                        self.isRequestRelationPopUp = true
                    }, label: {
                        if (UserManager.shared.isManager ?? true) {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                        }
                    })
                    .foregroundColor(.gray60)
                }
                .padding([.leading, .trailing], 32)
                
                if clientManageViewModel.isNetworking {
                    LoadingView()
                } else if clientManageViewModel.relationList.isEmpty {
                    CustomEmptyView(mainText: "보호 관계가 없어요", subText: "보호 관계가 없을 경우, 서비스 이용이 제한돼요.")
                        .padding(.top, 150)
                }
                
                List {
                    ForEach(clientManageViewModel.relationList, id: \.memberID) { relation in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(relation.memberName)
                                    .font(.h5Bold)
                                    .foregroundStyle(Color.gray90)
                                    .padding(.bottom, 3)
                                
                                Text(relation.memberPhone)
                                    .font(.body2Medium)
                                    .foregroundStyle(Color.gray70)
                            }
                            
                            Spacer()

                            if (UserManager.shared.isManager ?? true) {
                                Image(relation.cabinetID == 0 ? "ic_cabnet_disconnected" : "ic_cabnet_connected")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            } else {
                                Image(systemName: "person.crop.circle.badge.checkmark.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40)
                                    .foregroundStyle(Color.gray90)
                            }
                        }
                        .background(Color.white)
                        .onTapGesture {
                            self.selectedRelation = SelectedRelation(relationId: relation.id,
                                                                     name: relation.memberName,
                                                                     ssn: relation.memberSsn,
                                                                     phone: relation.memberPhone,
                                                                     cabinetId: relation.cabinetID)
                            self.showInformationView = true
                        }
                        .swipeActions {
                            Button("삭제") {
                                self.isDeletePopUp = true
                                self.selectedDeleteRelation = SelectedRelation(relationId: relation.id,
                                                                               name: relation.memberName,
                                                                               ssn: relation.memberPhone,
                                                                               phone: relation.memberPhone, 
                                                                               cabinetId: relation.cabinetID)
                            }
                            .tint(.error90)
                        }
                        .ignoresSafeArea(edges: .all)
                        .frame(height: 70)
                        .padding([.leading, .trailing], 30)
                    }
                }
                .ignoresSafeArea(edges: .bottom)
                .listStyle(.plain)
                .fadeIn(delay: 0.1)
                .refreshable {
                    requestToGetInfo()
                }
                
                if showToastView {
                    ToastView(description: "보호 관계를 요청했어요.", show: $showToastView)
                        .padding(.bottom, 20)
                }
                
                if toastManager.show {
                    ToastView(description: toastManager.description, show: $toastManager.show)
                        .padding(.bottom, 60)
                        .zIndex(1)
                }
            }
        }
        .onChange(of: self.clientManageViewModel.isDeleteSucceed, {
            self.toastManager.showToast(description: "보호 관계 삭제를 완료했어요.")
            requestToGetInfo()
        })
        .onChange(of: self.managementMyInformationViewModel.isDeleteSucced, {
            self.toastManager.showToast(description: "약통 삭제를 완료했어요.")
            requestToGetInfo()
        })
        .onAppear(perform: {
            requestToGetInfo()
        })
        .fullScreenCover(isPresented: $isRequestRelationPopUp,
                         content: {
            RequestRelationPopUpView(onNetworkSuccess: {
                self.showToastView = true
            })
            .background(ClearBackgroundView())
            .background(Material.ultraThin)
        })
        .fullScreenCover(item: $selectedDeleteRelation, content: { relation in
            CustomPopUpView(mainText: "\(relation.name) 님을\n삭제하시겠어요?",
                            subText: popUpSubText(name: relation.name),
                            leftButtonText: "취소할래요",
                            rightButtonText: "삭제할래요",
                            leftButtonAction: {},
                            rightButtonAction: {
                requestToDelete(relation.relationId)
            })
            .background(ClearBackgroundView())
            .background(Material.ultraThin)
        })
        .sheet(item: $selectedRelation, content: { relation in
            ManagementMyInformationView(managementMyInformationViewModel: managementMyInformationViewModel, 
                                        clientManageViewModel: clientManageViewModel,
                                        userInfo: relation)
        })
        .transaction { transaction in   // 모달 애니메이션 삭제
            transaction.disablesAnimations = true
        }
    }
    
    private func requestToGetInfo() {
        self.clientManageViewModel.$requestGetRelationList.send()
    }
    
    private func requestToDelete(_ id: Int) {
        self.clientManageViewModel.$requestDeleteRelation.send(id)
    }
    
    private func popUpSubText(name: String) -> String {
        return (UserManager.shared.isManager ?? true) ? "삭제하면 \(name) 님은 새로운 보호자가 케어를\n요청할 때까지 서비스를 이용할 수 없어요." : "삭제하면 \(name) 님은 \n\(UserManager.shared.name ?? "null") 님을 케어할 수 없어요. 신중하게 삭제해주세요."
    }
}

// MARK: - RequestRelationPopUpView

struct RequestRelationPopUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var validationViewModel: UserProfileValidationViewModel
    @StateObject var requestRelationViewModel: RequestRelationViewModel
    @State private var isButtonDisabled: Bool = true
    
    let onNetworkSuccess: () -> Void  // 클로저 추가
    
    init(onNetworkSuccess: @escaping () -> Void) {
        self.onNetworkSuccess = onNetworkSuccess
        self.validationViewModel = UserProfileValidationViewModel(validationService: ValidationService())
        _requestRelationViewModel = StateObject(wrappedValue: RequestRelationViewModel(requestService: RequestService(provider: MoyaProvider<RequestAPI>())))
        self.validationViewModel.bindEvent()
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Button(action: {
                    withAnimation(nil) {
                        dismiss()
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.gray90)
                        .padding([.leading, .trailing, .top], 5)
                })
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Text("추가할 피보호자의\n휴대폰 번호를 입력해주세요")
                    .font(.h4Bold)
                    .foregroundStyle(Color.gray90)
                    .padding(.bottom, 20)
                    .lineSpacing(3)
            
                CustomTextInput(placeholder: "휴대폰 번호 입력",
                                text: $validationViewModel.infoState.phoneNumber,
                                isError: validationViewModel.infoErrorState.phoneNumberErrorMessage.isEmpty ? .isErrorBinding(for: $requestRelationViewModel.requestRelationState.failMessage) : .isErrorBinding(for: $validationViewModel.infoErrorState.phoneNumberErrorMessage),
                                errorMessage: validationViewModel.infoErrorState.phoneNumberErrorMessage.isEmpty ? requestRelationViewModel.requestRelationState.failMessage : validationViewModel.infoErrorState.phoneNumberErrorMessage,
                                textInputStyle: .phoneNumber)
                .padding(.bottom, 40)
                                
                CustomButton(buttonSize: .regular,
                             buttonStyle: .filled,
                             action: {
                    hideKeyboard()
                    self.requestRelationViewModel.$tapRequestButton.send(validationViewModel.infoState.phoneNumber)
                }, content: {
                    Text("요청하기")
                }, isDisabled: isButtonDisabled
                , isLoading: requestRelationViewModel.isNetworking)
            }
            .padding([.leading, .trailing], 27)
            .padding(.top, 29)
            .padding(.bottom, 20)
            
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding()
        .fadeIn(delay: 0.1)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .shadow(color: Color.gray60.opacity(0.2), radius: 10, x: 0, y: 4)
        .onReceive(validationViewModel.$infoErrorState) { _ in
            updateButtonState()
        }
        .onReceive(validationViewModel.$infoState, perform: { _ in
            requestRelationViewModel.requestRelationState.failMessage = ""
            updateButtonState()
        })
        .onTapGesture {
            hideKeyboard()
        }
        .onChange(of: requestRelationViewModel.isNetworkSucceed, {
            onNetworkSuccess()
            withAnimation(nil) {
                dismiss()
            }
        })

    }
    
    private func updateButtonState() {
        self.isButtonDisabled = !validationViewModel.infoErrorState.phoneNumberErrorMessage.isEmpty || validationViewModel.infoState.phoneNumber.isEmpty
    }
}
