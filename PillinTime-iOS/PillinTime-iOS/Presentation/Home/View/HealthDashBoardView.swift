//
//  HealthDashBoardView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/29/24.
//

import SwiftUI

import Factory

struct HealthDashBoardView: View {
    
    let name: String
    
    var body: some View {
        VStack(alignment: .center) {
            
            Text.multiColoredText("오늘 \(name) 님의\n건강 상태를 분석했어요.", coloredSubstrings: [("\(name)", Color.primary60)])
                .multilineTextAlignment(.leading)
                .font(.logo3Medium)
                .foregroundStyle(Color.gray90)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
                .padding(.leading, 10)
                .lineSpacing(3)
                .fadeIn(delay: 0.1)
            
            Text("\(DateHelper.yearMonthDayFormatter.string(from: Date()))")
                .font(.body1Regular)
                .foregroundStyle(Color.gray70)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
                .padding(.leading, 10)
                .fadeIn(delay: 0.2)
            
            HStack {
                Spacer()
                
                StepCardView()
                    .padding(.trailing, 12)
                            
                SleepCardView()
                
                Spacer()
            }
            .padding(.bottom, 11)
            .fadeIn(delay: 0.3)
            
            HStack {
                Spacer()

                HeartRateCardView()
                    .padding(.trailing, 12)
                
                ActivityEnergyBurnedCardView()
                
                Spacer()
            }
            .fadeIn(delay: 0.3)
        }
        .padding([.leading, .trailing], 25)
    }
}

struct StepCardView: View {
    
    @ObservedObject var homeViewModel = Container.shared.homeViewModel.resolve()
    
    var body: some View {
        ZStack {
            Image("img-step-chart-unfilled")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleFadeIn(delay: 0.5)
            
            Image("img-step-chart-filled")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleFadeIn(delay: 0.6)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("걸음수")
                    .font(.body1Medium)
                    .foregroundStyle(Color.gray50)
                    .padding(.vertical, 5)
                
                Text("\(homeViewModel.healthData?.stepsMessage ?? "20대 권장까지 1684보 남았어요")")
                    .font(.body1Bold)
                    .foregroundStyle(Color.gray90)
                    .lineSpacing(3)
                    .padding(.bottom, 20)
                
                Spacer()
                
                HStack {
                    Text("오늘 걸음 수")
                        .font(.caption1Medium)
                        .foregroundStyle(Color.primary40)
                    
                    Spacer()
                    
                    Text("\(homeViewModel.healthData?.steps ?? 1684)보")
                        .font(.caption1Bold)
                        .foregroundStyle(Color.primary60)
                }
                .frame(width: 110)
                
                HStack {
                    Text("\(homeViewModel.healthData?.ageGroup ?? 20)대 권장")
                        .font(.caption1Medium)
                        .foregroundStyle(Color.gray40)
                    
                    Spacer()
                    
                    Text("\(homeViewModel.healthData?.averStep ?? 7000)보")
                        .font(.caption1Bold)
                        .foregroundStyle(Color.primary60)
                }
                .frame(width: 110)
            }
            .padding()
        }
        .background(Color.white)
        .frame(width: 160, height: 241)
        .cornerRadius(10)
    }
}

struct SleepCardView: View {
    
    @ObservedObject var homeViewModel = Container.shared.homeViewModel.resolve()

    var body: some View {
        
        ZStack {
            Color.white
            
            VStack(alignment: .leading, spacing: 5) {
                Text("수면")
                    .font(.body1Medium)
                    .foregroundStyle(Color.gray50)
                    .padding(.leading, 15)
                    .padding(.vertical, 5)
                
                Text("\(homeViewModel.healthData?.sleepTimeMessage ?? "오늘 14시간 잤어요")")
                    .font(.body1Bold)
                    .foregroundStyle(Color.gray90)
                    .lineSpacing(3)
                    .padding(.bottom, 20)
                    .padding(.leading, 15)
                    .frame(height: 70)

                HStack {
                    Image("img-sleep-arrow")
                        .fadeIn(delay: 0.5)
                    
                    Spacer()
                    
                    Image("img-sleep-moon")
                        .padding(.trailing, 15)
                        .fadeIn(delay: 0.6)
                }
                .padding([.bottom], 8)
                
                HStack {
                    Text("오늘 수면 시간")
                        .font(.caption1Medium)
                        .foregroundStyle(Color.primary40)
                    
                    Spacer()
                    
                    Text("\(homeViewModel.healthData?.sleepTime ?? 14)시간")
                        .font(.caption1Bold)
                        .foregroundStyle(Color.primary60)
                }
                .frame(width: 125, alignment: .center)
                .padding(.leading, 15)
                
                HStack {
                    Text("\(homeViewModel.healthData?.ageGroup ?? 20)대 권장 시간")
                        .font(.caption1Medium)
                        .foregroundStyle(Color.gray40)
                    
                    Spacer()
                    
                    Text("\(homeViewModel.healthData?.recommendSleepTime ?? 14)시간")
                        .font(.caption1Bold)
                        .foregroundStyle(Color.gray40)
                }
                .frame(width: 125, alignment: .center)
                .padding(.leading, 15)

            }
        }
        .background(Color.white)
        .frame(width: 160, height: 241)
        .cornerRadius(10)
    }
}

struct HeartRateCardView: View {
    
    @ObservedObject var homeViewModel = Container.shared.homeViewModel.resolve()
    
    var body: some View {
        ZStack {
            Color.white
            
            VStack(alignment: .leading) {
                Text("심장박동 수")
                    .font(.body1Medium)
                    .foregroundStyle(Color.gray50)
                    .padding(.leading, 8)
                
                HStack {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundStyle(Color.red)
                        .padding(.leading, 8)
                    
                    Text("\(homeViewModel.healthData?.heartRate ?? 89)")
                        .font(.logo3ExtraBold)
                        .foregroundStyle(Color.gray90)

                    Text("bpm")
                        .font(.logo5Medium)
                        .foregroundStyle(Color.gray90)
                }
                
                Image("img-heart-graph")
                    .padding(5)
                    .fadeIn(delay: 0.5)
                
                HStack {
                    Text("\(homeViewModel.healthData?.ageGroup ?? 20)대 평균")
                        .font(.caption1Medium)
                        .foregroundStyle(Color.gray40)
                    
                    Spacer()
                    
                    Text("\(homeViewModel.healthData?.heartRateMessage ?? "80-90bpm")")
                        .font(.caption1Bold)
                        .foregroundStyle(Color.gray40)
                }
                .frame(width: 125)
            }
        }
        .background(Color.white)
        .frame(width: 160, height: 241)
        .cornerRadius(10)
    }
}

struct ActivityEnergyBurnedCardView: View {
    
    @ObservedObject var homeViewModel = Container.shared.homeViewModel.resolve()
    
    var body: some View {
        ZStack {
            Color.white
            
            VStack(alignment: .leading, spacing: 5) {
                Text("활동량")
                    .font(.body1Medium)
                    .foregroundStyle(Color.gray50)
                    .padding(.leading, 8)
                
                ZStack {
                    Image("img-activity-graph")
                        .scaleFadeIn(delay: 0.5)
                    
                    VStack {
                        Text("\(homeViewModel.healthData?.calorie ?? 435)")
                            .font(.logo4ExtraBold)
                            .foregroundStyle(Color.gray90)
                        Text("kcal")
                            .font(.logo5Medium)
                            .foregroundStyle(Color.gray90)
                    }
                    .fadeIn(delay: 0.6)
                }
                .padding(5)
                            
                HStack {
                    Text("오늘 활동량")
                        .font(.caption1Medium)
                        .foregroundStyle(Color.primary40)
                    
                    Spacer()
                    
                    Text("\(homeViewModel.healthData?.calorie ?? 435)kcal")
                        .font(.caption1Bold)
                        .foregroundStyle(Color.primary60)
                }
                .frame(width: 125)
                .padding(.leading, 8)
                
                HStack {
                    Text("\(homeViewModel.healthData?.ageGroup ?? 20)대 권장")
                        .font(.caption1Medium)
                        .foregroundStyle(Color.gray40)
                    
                    Spacer()
                    
                    Text("\(homeViewModel.healthData?.calorieMessage ?? "2600kcal")")
                        .font(.caption1Bold)
                        .foregroundStyle(Color.gray40)
                }
                .frame(width: 125)
                .padding(.leading, 8)
            }
        }
        .background(Color.white)
        .frame(width: 160, height: 241)
        .cornerRadius(10)
    }
}
