//
//  ContentView.swift
//  Haunt Hunt
//
//  Created by Luca on 12/05/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Image("background")
                        .resizable()
                        .ignoresSafeArea()
                        .aspectRatio(contentMode: .fill)
                    
                    VStack{
                        Spacer()
                        Image("Header")
                            .resizable()
                            .frame(width: 359, height: 59)
                            .padding(.bottom, 90)
                        NavigationLink{
                            EntityView()
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
                        }
                        
                        NavigationLink{
                            InvestigatorView()
                        }label: {
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
                        
                        Spacer()
                        
                        NavigationLink{
                            TutorialView()
                        }label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 350, height: 50)
                                    .foregroundColor(Color("Purple"))
                                Image("howtoplay")
                            }
                        }
                        .padding(.bottom)
                        Spacer()
                    }
                }//ZStack end
            }//VStack end
            .navigationTitle("")
        }//NavigationView end
        .accentColor(.purple)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
