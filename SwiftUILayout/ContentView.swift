//
//  ContentView.swift
//  SwiftUILayout
//
//  Created by Donald McAllister on 4/8/20.
//  Copyright © 2020 Donald McAllister. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            EventHeader()
            Spacer()
        }.padding()
    }
}

struct EventHeader: View {
    var body: some View {
        HStack(spacing: 15) {
            CalendarView()
            VStack(alignment: .leading) {
                Text("Event title").font(.title)
                Text("Location")
            }
            Spacer()
        }
    }
}

struct CalendarView: View {
    var eventIsVerified = true
    
    var body: some View {
        Image(systemName: "calendar")
            .resizable()  //won't resize to parent frame without
            .padding()  // this location matters since encapsulating all prior modifiers
            .frame(width: 50, height: 50)
            .background(Color.red)
            .cornerRadius(10)
            .foregroundColor(.white)
            .addVerifiedBadge(eventIsVerified) //ZStack extension
    }
}

// Extensions

extension View {
    func addVerifiedBadge(_ isVerified: Bool) -> some View {
        ZStack(alignment: .topTrailing) {
            self
            
            if isVerified {
                Image(systemName: "checkmark.circle.fill")
                .offset(x: 3, y: -3)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
