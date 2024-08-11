//
//  ContentView.swift
//  GestureSwipeTest
//
//  Created by Kehinde Bankole on 10/08/2024.
//

import SwiftUI

struct Profile : Identifiable {
    var id = UUID()
    var image : String
    var offset : CGFloat
}


struct ContentView: View {
    
    
    @State var profiles = [
        
        Profile( image: "p0", offset: 0),
        Profile( image: "p1", offset: 0),
        Profile(image: "p2",  offset: 0),
        Profile(image: "p3", offset: 0),
        Profile(image: "p4",  offset: 0),
        Profile(image: "p5",  offset: 0),
        
    ]
    
    
    var body: some View {
        VStack {
            ZStack{
                
                ForEach(profiles.reversed()){profile in
                    
                    ProfileView(profile: profile , profiles: $profiles)
                }
            }
        }
        .padding()
    }
}




struct ProfileView : View {
    @State var profile : Profile
    @Binding var profiles:[Profile]
    
    func addToBack(){
        
        profiles.remove(at: profiles.firstIndex{$0.id == profile.id} ?? 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            profiles.append(Profile(image: profile.image, offset: 0))
        }
    }
    
    var body: some View {
        VStack{
            GeometryReader{ reader in
                Image(profile.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width:reader.size.width , height: reader.size.height)
                    .overlay(
                        
                        Rectangle().fill(profile.offset == 0 ? Color("transparent") : profile.offset < 0 ? Color.red : Color.green)
                            .opacity(0.5)
                            .frame(width:reader.size.width)
                        
                    )
                    .cornerRadius(20)
                    .offset(x: profile.offset)
                    .rotationEffect(Angle(degrees: profile.offset == 0 ? 0 : (profile.offset < 0 ? -12 : 12)) , anchor: .center)
                    .gesture(DragGesture().onChanged({ val  in
                        
                        withAnimation(.default){
                            
                            profile.offset = val.translation.width
                        }
                    })
                        .onEnded{_ in
                            
                            withAnimation(.easeIn){
                                
                                if profile.offset > 150{
                                    
                                    profile.offset = 500
                                    addToBack()
                                }
                                else if profile.offset < -150{
                                    
                                    profile.offset = -500
                                    addToBack()
                                }
                                else{
                                    
                                    profile.offset = 0
                                }
                                
                            }
 
                        }
                             
                             
                    )
                
            }
            
        }
        
    }
}
#Preview {
    ContentView()
}
