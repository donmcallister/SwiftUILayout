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
            ImagePlaceholder()
                .layoutPriority(-1)
                .frame(minHeight: 100)
            Text(makeDescription()) //.layoutPriority(1)
//            Text("This is a description")
            Spacer()
            EventInfoList().layoutPriority(1)
        }.padding()
    }
}

struct ImagePlaceholder: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10).stroke()
            Text("Image placeholder")
        }
    }
}

struct EventInfoList: View {
    var body: some View {
        HeightSyncedRow(background: Color.secondary.cornerRadius(10)) {
            EventInfoBadge(iconName: "video.circle.fill", text: "Video call available")
            EventInfoBadge(iconName: "doc.text.fill", text: "Files are attached")
            EventInfoBadge(iconName: "person.crop.circle.badge.plus", text: "Invites enabled, 5 people maximum")
        }
    }
}

// row of "info badges" at bottom
struct EventInfoBadge: View {
    var iconName: String
    var text: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                //fit it content into its bounds when resized:
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
            Text(text)
                // scale as much as possible along parent (HStack) before splitting up into multiple lines:
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 5)
    //.background(Color.secondary) -> moved to HeightSyncedRow
        .cornerRadius(10)
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

// Extensions and Helpers To Reuse:

struct HeightSyncedRow<Background: View, Content: View>: View {
    private let background: Background
    private let content: Content
    @State private var childHeight: CGFloat?
    
    // ViewBuilder attribute to allow replace HStack with
    // this HeightSyncedRow view
    init(background: Background,
         @ViewBuilder content: () -> Content) {
        self.background = background
        self.content = content()
    }
    
    var body: some View {
        HStack {
            content.syncingHeightIfLarger(than: $childHeight)
                .frame(height: childHeight)
                .background(background)
        }
    }
}

// Compute the childHeight value that HeightSyncedRow
// will assign to each of its children.
// Each child to report current height updwards
private struct HeightPreferenceKey: PreferenceKey {
    // preference's default value
    static let defaultValue: CGFloat = 0
    // reduce two values (previous and next one) into one:
    static func reduce(value: inout CGFloat,
                       nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    func syncingHeightIfLarger(than height: Binding<CGFloat?>) -> some View {
        background(GeometryReader { proxy in
            // we have to attach our preference assignment to
            // some form of view, so we just us a clear color
            // here to make that view completely transparent:
            Color.clear.preference(
                key: HeightPreferenceKey.self,
                value: proxy.size.height
            )
        })
            .onPreferenceChange(HeightPreferenceKey.self) {
                height.wrappedValue = max(height.wrappedValue ?? 0, $0)
        }
    }
    
    
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

private extension ContentView {
    func makeDescription() -> String {
        String(repeating: "This is a description ", count: 50)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
