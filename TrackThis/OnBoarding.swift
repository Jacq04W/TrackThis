//
//  OnBoarding.swift
//  OffSeason3
//
//  Created by Jacquese Whitson on 6/28/23.
//

import SwiftUI
// onboarding steps \

struct OnBoardingStep{
    
    
    
    let image : String
    let title : String
    let description : String
     
}
private let onBoardingSteps = [
OnBoardingStep(image: "logo1", title: "Welcome to TrackThis", description: "The simplest app in the world to track your daily expenses"),
OnBoardingStep(image: "onBoard1", title: "Make A deposit", description: ""),

OnBoardingStep(image: "onBoard2", title: "How to Track", description: "Now hit the arrow at thew bottom of the screen to start tracking your expenses"),


OnBoardingStep(image: "onBoard3", title: "Tracking", description: "Be sure to add the name of the expense,the amount spent and category before saving")

]

struct OnBoarding: View {
    @State private var currentStep = 0
    @State private var playNow = false
    @AppStorage ("isOnboarding") var isOnboarding: Bool?
    init(){
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        NavigationStack {
            HStack {
                VStack{
                    HStack{
                        Spacer()
                        Button{
                            // if code is breakin its prolly caus eof here
                            withAnimation{
                                self.currentStep = onBoardingSteps.count - 1
                            } }label: {
                            Text("Skip")
                                .padding(16)
                                .foregroundColor(.gray)
                            
                        }
                    }
                    
                    
                    
                    TabView(selection: $currentStep) {
                        ForEach(0..<onBoardingSteps.count) { step in
                            VStack{
                       
                                
                                if step == 0 {
                                    Text(onBoardingSteps[step].title)
                                        .font(Font.custom("Marker Felt", size: 45))
                                        .foregroundColor(.yellow)
                                        .offset(y:140)
                                }
                                else {
                                    
                                    
                                    Text(onBoardingSteps[step].title)
                                        .font(Font.custom("Marker Felt", size: 40))
                                        .foregroundColor(.yellow)
                                    
                                }
                                
                               
                                if step == 2 {
                                    Image(onBoardingSteps[step].image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .imageScale(.medium)
                                        .frame(width: 350, height: 300)
                                        .cornerRadius(30)
                                    
                                } 
                                else if step == 3 {
                                    Image(onBoardingSteps[step].image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .imageScale(.medium)
//                                        .frame(width: 500, height: 300)
                                        .cornerRadius(30)
                                }
                                else {
                                Image(onBoardingSteps[step].image)
                                    .resizable()
                                    .imageScale(.medium)
                                    .frame(width: 350, height: 300)
                                    .cornerRadius(30)
                            }
                Text(onBoardingSteps[step].description)
                                    .bold()
                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                            }
                            .tag(step)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    HStack{
                        ForEach(0..<onBoardingSteps.count) { step in
                            
                            // these are for the ittle dots at the bottom of the page
                            if step == currentStep {
                                Rectangle()
                                    .frame(width: 20, height: 10)
                                    .cornerRadius(10)
                                    .foregroundColor(currentStep < onBoardingSteps.count - 1 ? .white : .green)
                            }
                            else {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(.gray)
                            }
                            
                            
                        }
                    }.padding(.bottom,24)
                    
                    
                    Button{
                        
                        if currentStep < onBoardingSteps.count - 1{
                            withAnimation{
                                
                                currentStep += 1
                            }
                        } else {
                            withAnimation{
                                
                                isOnboarding = false
                                playNow.toggle()
                            }
                        }
                        
                    } label :{
                        Text(currentStep < onBoardingSteps.count - 1 ? "Next" : "Get Started")
                            .bold()
                            .font(Font.custom("Marker Felt", size: 30))
                            .padding(16)
                            .frame(maxWidth: .infinity)
                            .background(currentStep < onBoardingSteps.count - 1 ? .indigo : .indigo)
                            .cornerRadius(16)
                            .padding(.horizontal,16)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .fullScreenCover(isPresented: $playNow) {
                HomePage(player: Player(), showSignInView: .constant(false))
//ContentView()
                
            }
        }.preferredColorScheme(.dark)
        
        
        
        
        
        
     }
}

struct OnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding()
    }
}
