import SwiftUI
import Charts

struct OverallAttendanceView: View {
    @StateObject private var vm = OverallAttendanceViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text("Overall Attendance")
                .font(.title2).bold()

            Picker("Time", selection: $vm.selectedTimeRange) {
                ForEach(OverallAttendanceViewModel.TimeRange.allCases) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            HStack {
                Button { vm.previousPage() } label: {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(vm.currentRangeLabel)
                    .font(.callout)
                Spacer()
                Button {
                    vm.nextPage()
                } label: {
                    Image(systemName: "chevron.right")
                }
                .disabled(vm.selectedPage == 0)
            }
            .padding(.horizontal)

            Text("Total Hours: \(vm.totalHoursInView, specifier: "%.1f")")
                .fontWeight(.semibold)

            Chart {
                ForEach(vm.chartData) { point in
                    BarMark(
                        x: .value("Date", point.label),
                        y: .value("Hours", point.hours)
                    )
                    .foregroundStyle(.blue)
                    .annotation(position: .top) {
                        Text("\(point.hours, specifier: "%.1f")h")
                            .font(.caption2)
                    }
                }
            }
            .frame(height: 300)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .onChange(of: vm.selectedTimeRange) {
            vm.updateChartData()
        }
        .onChange(of: vm.selectedPage) {
            vm.updateChartData()
        }
        .task {
            await vm.loadMockData()
        }
    }
}
@MainActor
final class OverallAttendanceViewModel: ObservableObject {
    enum TimeRange: String, CaseIterable, Identifiable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        var id: String { rawValue }
    }

    struct AggregatedPoint: Identifiable {
        let id = UUID()
        let label: String
        let hours: Double
        let range: (start: Date, end: Date)
    }

    @Published var selectedTimeRange: TimeRange = .daily
    @Published var selectedPage: Int = 0
    @Published var chartData: [AggregatedPoint] = []

    private var rawData: [AttendanceRecord1] = []

    var totalHoursInView: Double {
        chartData.reduce(0) { $0 + $1.hours }
    }

    var currentRangeLabel: String {
        guard let first = chartData.first?.range.start,
              let last = chartData.last?.range.end else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return "\(formatter.string(from: first)) – \(formatter.string(from: last))"
    }

    func previousPage() { selectedPage += 1 }
    func nextPage() { selectedPage = max(0, selectedPage - 1) }

    func loadMockData() async {
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.startOfDay(for: Date())

        rawData = (0..<365).compactMap { i in
            guard let date = calendar.date(byAdding: .day, value: -i, to: today) else { return nil }
            let hours = Double.random(in: 3...10)
            return AttendanceRecord1(date: date, hoursWorked: hours)
        }

        updateChartData()
    }

    func updateChartData() {
        let calendar = Calendar(identifier: .gregorian)

        switch selectedTimeRange {
        case .daily:
            let baseDate = calendar.date(byAdding: .weekOfYear, value: -selectedPage, to: Date())!
            let start = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: baseDate))!
            let end = calendar.date(byAdding: .day, value: 6, to: start)!
            let interval = DateInterval(start: start, end: end)
            let grouped = Dictionary(grouping: rawData.filter { interval.contains($0.date) }, by: { calendar.startOfDay(for: $0.date) })

            chartData = grouped.map { date, records in
                let total = records.reduce(0) { $0 + $1.hoursWorked }
               // let label = date.formatted(date: .abbreviated, time: .omitted)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "ddMMM"
                let label = "\(formatter.string(from: date))"
                
                return AggregatedPoint(label: label, hours: total, range: (date, date))
            }.sorted { $0.range.start < $1.range.start }

        case .weekly:
            
            let weeksBack = 4
            let currentWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
            let weekStarts: [Date] = (0..<weeksBack).map {
                calendar.date(byAdding: .weekOfYear, value: -$0 - (selectedPage * weeksBack), to: currentWeek)!
            }
            
            

            chartData = weekStarts.map { weekStart in
                let start = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: weekStart))!
                let end = calendar.date(byAdding: .day, value: 6, to: start)!
                let range = DateInterval(start: start, end: end)
                let total = rawData.filter { range.contains($0.date) }.reduce(0) { $0 + $1.hoursWorked }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "ddMMM"
                let label = "\(formatter.string(from: start))–\(formatter.string(from: end))"
                return AggregatedPoint(label: label, hours: total, range: (start, end))
            }.sorted { $0.range.start < $1.range.start }

        case .monthly:
            let now = Date()
            let currentMonth = calendar.component(.month, from: now)
            let baseYear = currentMonth >= 4 ? calendar.component(.year, from: now) - selectedPage : calendar.component(.year, from: now) - selectedPage - 1

            let months = (0..<12).map { i -> Date in
                let month = ((i + 3) % 12) + 1
                let year = i < 9 ? baseYear : baseYear + 1
                return calendar.date(from: DateComponents(year: year, month: month, day: 1))!
            }

            chartData = months.compactMap { monthStart in
                guard let range = calendar.dateInterval(of: .month, for: monthStart) else { return nil }
                let total = rawData.filter { range.contains($0.date) }.reduce(0) { $0 + $1.hoursWorked }
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM"
                return AggregatedPoint(label: formatter.string(from: monthStart), hours: total, range: (range.start, range.end))
            }.sorted { $0.range.start < $1.range.start }
        }
    }
}

// Mock model
struct AttendanceRecord1 {
    let date: Date
    let hoursWorked: Double
}

#Preview {
    OverallAttendanceView()
}
