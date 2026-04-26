import Foundation
import HealthKit
import SwiftUI

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    
    @Published var isAuthorized: Bool = false
    @Published var lastNightSleep: NightlySleep?
    @Published var recentSleepRecords: [NightlySleep] = []
    @Published var isLoading: Bool = false
    
    init() {
        checkAuthorizationStatus()
    }
    
    func checkAuthorizationStatus() {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let status = healthStore.authorizationStatus(for: sleepType)
        DispatchQueue.main.async {
            self.isAuthorized = status == .sharingAuthorized
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }
        
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let typesToRead: Set = [sleepType]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                self.isAuthorized = success
                if success {
                    self.fetchRecentSleep()
                }
                completion(success)
            }
        }
    }
    
    func fetchRecentSleep(days: Int = 14) {
        guard isAuthorized else { return }
        
        DispatchQueue.main.async { self.isLoading = true }
        
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -days, to: endDate)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { [weak self] query, samples, error in
            guard let self = self, let categorySamples = samples as? [HKCategorySample] else {
                DispatchQueue.main.async { self?.isLoading = false }
                return
            }
            
            let records = categorySamples.map { SleepRecord.from(sample: $0) }
            let groupedRecords = self.groupRecordsByNight(records: records)
            
            DispatchQueue.main.async {
                self.recentSleepRecords = groupedRecords
                self.lastNightSleep = groupedRecords.first
                self.isLoading = false
            }
        }
        
        healthStore.execute(query)
    }
    
    private func groupRecordsByNight(records: [SleepRecord]) -> [NightlySleep] {
        // Grouping logic: Records within the same 24-hour window (usually 6 PM to 6 PM next day)
        let calendar = Calendar.current
        var nights: [Date: [SleepRecord]] = [:]
        
        for record in records {
            // If the sleep started after 6 PM, it belongs to the "next" morning's record
            // If it started before 6 PM, it belongs to that day's morning (the night before)
            let hour = calendar.component(.hour, from: record.startDate)
            let referenceDate: Date
            if hour >= 18 {
                referenceDate = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: record.startDate)!)
            } else {
                referenceDate = calendar.startOfDay(for: record.startDate)
            }
            
            nights[referenceDate, default: []].append(record)
        }
        
        return nights.map { NightlySleep(id: $0.key, records: $0.value) }
            .sorted(by: { $0.id > $1.id })
    }
    
    // MARK: - Mock Data for Preview
    static var mock: HealthKitManager {
        let manager = HealthKitManager()
        manager.isAuthorized = true
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var mockNights: [NightlySleep] = []
        for i in 0..<7 {
            let nightDate = calendar.date(byAdding: .day, value: -i, to: today)!
            let sleepStart = calendar.date(bySettingHour: 23, minute: 30, second: 0, of: calendar.date(byAdding: .day, value: -1, to: nightDate)!)!
            
            let records = [
                SleepRecord(startDate: sleepStart, endDate: sleepStart.addingTimeInterval(3600), stage: .awake),
                SleepRecord(startDate: sleepStart.addingTimeInterval(3600), endDate: sleepStart.addingTimeInterval(3600 * 3), stage: .core),
                SleepRecord(startDate: sleepStart.addingTimeInterval(3600 * 3), endDate: sleepStart.addingTimeInterval(3600 * 4), stage: .deep),
                SleepRecord(startDate: sleepStart.addingTimeInterval(3600 * 4), endDate: sleepStart.addingTimeInterval(3600 * 5), stage: .rem),
                SleepRecord(startDate: sleepStart.addingTimeInterval(3600 * 5), endDate: sleepStart.addingTimeInterval(3600 * 8), stage: .core)
            ]
            mockNights.append(NightlySleep(id: nightDate, records: records))
        }
        
        manager.recentSleepRecords = mockNights
        manager.lastNightSleep = mockNights.first
        return manager
    }
}
