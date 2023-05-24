//
//  PreviousView.swift
//  Haunt Hunt
//
//  Created by Luca on 18/05/23.
//

import SwiftUI

struct PreviousView: View {
   
    @State private var showWarning = false
    @State private var isEntityButtonVisible = true
    @State private var isInvestigatorButtonVisible = true
    @State private var isHowButtonVisible = true
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    
    var body: some View {
        NavigationView() {
            
            ZStack {
                
                Image("background")
                    .resizable()
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fill)
                
                VStack{
                    
                    if isEntityButtonVisible == false {
                        EntityView()
                            .transition(.opacity)
                    }
                    else if isInvestigatorButtonVisible == true && isHowButtonVisible == true{
                        
                        Image("Header")
                            .resizable()
                            .frame(width: 359, height: 59)
                            .padding(.bottom, 90)
                            .padding(.top, 120)
                        Button{
                            withAnimation{
                                isEntityButtonVisible = false
                            }
                        }label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width: 350, height: 170)
                                    .padding(.bottom)
                                    .foregroundColor(Color("Purple"))
                                VStack {
                                    Image("ghost")
                                        .resizable()
                                        .frame(width: 80, height: 70)
                                        .offset(y: 5)
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .frame(width: 330, height: 45)
                                            .foregroundColor(Color("BrightPurple"))
                                        Image("entity")
                                    }
                                    .offset(y: 5)
                                .padding()
                                }
                            }
                        }.frame(width: 350, height: 170)
                            .position(x:screenWidth/2,y:screenHeight/13)
                        
                    }
                    
                    if isInvestigatorButtonVisible == false{
                        InvestigatorView()
                            .transition(.opacity)
                    }
                    else if isEntityButtonVisible == true && isHowButtonVisible == true{
                        Button{
                            withAnimation{
                                isInvestigatorButtonVisible = false
                            }
                        }label: {
                            VStack {
                                Spacer()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width: 350, height: 170)
                                    
                                    .foregroundColor(Color("Purple"))
                                    VStack {
                                        Image("search")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                            .offset(y: 15)
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .frame(width: 330, height: 45)
                                            .foregroundColor(Color("BrightPurple"))
                                            Image("investigator")
                                        }
                                        .offset(y: 12)
                                        .padding()
                                    }
                                }
                            }
                        }.frame(width: 350, height: 170)
                            .position(x:screenWidth/2,y:screenHeight/17)
                            
                        
                    }
                    
                    if isHowButtonVisible == false{
                        TutorialView()
                            .transition(.opacity)
                    }
                    else if isEntityButtonVisible == true && isInvestigatorButtonVisible == true{
                        
                        Button{
                            withAnimation{
                                isHowButtonVisible.toggle()
                            }
                        }label: {
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 350, height: 50)
                                        .foregroundColor(Color("Purple"))
                                    Image("howtoplay")
                                }
                                
                            }
                            
                        }.position(x:screenWidth/2,y:screenHeight/13)
                    }
                }
            }
            
            
            
        }
    }
}

struct PreviousView_Previews: PreviewProvider {
    static var previews: some View {
        PreviousView()
    }
}

