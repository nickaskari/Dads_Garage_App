//
//  LogView.swift
//  Dads Garage App
//
//  Created by Nick Askari on 13/06/2022.
//

import SwiftUI

struct LogView: View {
    @EnvironmentObject private var locManager: LocationManager
    @FetchRequest(sortDescriptors: []) var logFeed: FetchedResults<LogFeed>
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                List {
                    if logFeed.isEmpty {
                        Text("Log is empty..")
                            .opacity(0.7)
                    } else {
                        ForEach(logFeed) { log in
                            logRow(log)
                        }
                    }
                }
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            locManager.homeManager.toggleGarageState(false)
                        } label: {
                            Text("open")
                        }
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            locManager.homeManager.toggleGarageState(true)
                        } label: {
                            Text("close")
                        }
                    }
                }
                .navigationTitle("Garage log")
                
                if locManager.userLocationDescription != nil {
                    withAnimation {
                        isInZoneView
                            .scaleEffect()
                    }
                }
            }
        }
        .onReceive(locManager.homeManager.$log) { log in
            if !log.isEmpty {
                let last = log.last!
                if !logFeedContainslog(last) {
                    addToLogFeed(last)
                }
            }
        }
    }
    
    private var isInZoneView: some View {
        Text(locManager.userLocationDescription!)
            .capsuleStyle(.blue)
            .padding(.horizontal)
            .padding(.bottom, 60)
    }
    
    private func logFeedContainslog(_ inputlog: LogObject) -> Bool {
        for log in logFeed {
            if log.id == inputlog.id {
                return true
            }
        }
        return false
    }
    
    private func logRow(_ log: LogFeed) -> some View {
        HStack() {
            VStack(alignment: .leading, spacing: 10) {
                Text(log.state ? "Closed garage" : "Opened garage")
                Text(timeStamp(log.conception ?? Date()))
                    .opacity(0.6)
            }
            Spacer()
            Image(systemName: log.state ? "lock.fill" : "lock.open.fill")
        }
        .contentShape(Rectangle())
        .padding()
    }
    
    private func timeStamp(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        return dateFormatter.string(from: date)
    }
    
    private func addToLogFeed(_ log: LogObject) {
        let savedLog = LogFeed(context: moc)
        savedLog.id = log.id
        savedLog.conception = log.conception
        savedLog.state = log.state
        
        try? moc.save()
    }
}










struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
