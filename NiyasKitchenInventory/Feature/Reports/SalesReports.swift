import SwiftUI
import Charts

struct SalesDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    let category: String // Add category field
}

@MainActor
@Observable
final class SalesReportViewModel {
    enum TimeRange: String, CaseIterable, Identifiable {
        case day = "D"
        case week = "W"
        case month = "M"
        case year = "Y"
        var id: String { rawValue }
    }

    struct ChartPoint: Identifiable {
        let id = UUID()
        let label: String
        let value: Double
        let category: String
        let range: (start: Date, end: Date)
    }

    var selectedTimeRange: TimeRange = .day
    var selectedPage: Int = 0
    var selectedLabel: String? = nil
    var selectedCategory: String = "Total"

    var allData: [SalesDataPoint] = []
    let categories = ["Total", "Just Eat", "Uber Eat", "Cash", "Deliveroo", "All"]

    private let services = SalesReportsServices()
    func fetchSalesReports() async {
        do {
            let salesReports = try await services.fetchDailySalesReports()
            self.allData = salesReports.flatMap { closing in
                let date = closing.timeStamp
                return [
                    SalesDataPoint(date: date, value: closing.total, category: "Total"),
                    SalesDataPoint(date: date, value: closing.justEat, category: "Just Eat"),
                    SalesDataPoint(date: date, value: closing.uberEats, category: "Uber Eat"),
                    SalesDataPoint(date: date, value: closing.cash, category: "Cash"),
                    SalesDataPoint(date: date, value: closing.deliveroo, category: "Deliveroo")
                ]
            }
            .sorted { $0.date < $1.date }
            
            
            print(self.allData)
            
        } catch {
            print(error)
        }
    }
    
    private struct CategoryDateKey: Hashable {
        let category: String
        let date: Date
    }

    
    var chartData: [ChartPoint] {
        let calendar = Calendar(identifier: .gregorian)
        
        let isAll = selectedCategory == "All"
        let filtered = isAll ? allData : allData.filter { $0.category == selectedCategory }

        switch selectedTimeRange {
        case .day:
            // Single day window: today by default, swipe per day
            let targetDay = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -selectedPage, to: Date())!)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: targetDay)!.addingTimeInterval(-1)
            let range = DateInterval(start: targetDay, end: endOfDay)
            let items = isAll ? allData.filter { range.contains($0.date) } : filtered.filter { range.contains($0.date) }

            if isAll {
                let grouped = Dictionary(grouping: items, by: { CategoryDateKey(category: $0.category, date: targetDay) })
                return grouped.map { key, values in
                    let total = values.reduce(0) { $0 + $1.value }
                    let label = targetDay.formatted(date: .abbreviated, time: .omitted)
                    return ChartPoint(label: label, value: total, category: key.category, range: (targetDay, targetDay))
                }
                .sorted { $0.category < $1.category }
            } else {
                let total = items.reduce(0) { $0 + $1.value }
                let label = targetDay.formatted(date: .abbreviated, time: .omitted)
                return [ChartPoint(label: label, value: total, category: selectedCategory, range: (targetDay, targetDay))]
            }

        case .week:
            // One full week window (Mon–Sun), swipe week by week
            let today = Date()
            let currentWeekRef = calendar.date(byAdding: .weekOfYear, value: -selectedPage, to: today)!
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentWeekRef))!
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
            let range = DateInterval(start: startOfWeek, end: endOfWeek)

            let items = isAll ? allData.filter { range.contains($0.date) } : filtered.filter { range.contains($0.date) }

            // Helper for month label
            let monthLabel: (Date) -> String = { monthStart in
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MMM"
                return formatter.string(from: monthStart)
            }
            
            if isAll {
                // Group by category and startOfDay
                let grouped = Dictionary(grouping: items, by: { CategoryDateKey(category: $0.category, date: calendar.startOfDay(for: $0.date)) })
                return grouped.map { key, values in
                    let total = values.reduce(0) { $0 + $1.value }
                    //let label = key.date.formatted(date: .abbreviated, time: .omitted)
                    
                    let label = monthLabel(key.date)
                    
                    return ChartPoint(label: label, value: total, category: key.category, range: (key.date, key.date))
                }
                .sorted { $0.range.start < $1.range.start }
            } else {
                let grouped = Dictionary(grouping: items, by: { calendar.startOfDay(for: $0.date) })
                return grouped.map { date, values in
                    let total = values.reduce(0) { $0 + $1.value }
                   // let label = date.formatted(date: .abbreviated, time: .omitted)
                    
                    let label = monthLabel(date)
                    return ChartPoint(label: label, value: total, category: selectedCategory, range: (date, date))
                }
                .sorted { $0.range.start < $1.range.start }
            }

        case .month:
            // Full month window, swipe month by month
            let today = Date()
            let currentMonthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
            let targetMonthStart = calendar.date(byAdding: .month, value: -selectedPage, to: currentMonthStart)!
            guard let monthInterval = calendar.dateInterval(of: .month, for: targetMonthStart) else { return [] }

            let items = isAll ? allData.filter { monthInterval.contains($0.date) } : filtered.filter { monthInterval.contains($0.date) }

            // Helper for month label
            let monthLabel: (Date) -> String = { monthStart in
                let formatter = DateFormatter()
                formatter.dateFormat = "d"
                return formatter.string(from: monthStart)
            }
            
            if isAll {
                let grouped = Dictionary(grouping: items, by: { CategoryDateKey(category: $0.category, date: calendar.startOfDay(for: $0.date)) })
                return grouped.map { key, values in
                    let total = values.reduce(0) { $0 + $1.value }
//                    let label = key.date.formatted(date: .abbreviated, time: .omitted)
                    let label = monthLabel(key.date)
                    return ChartPoint(label: label, value: total, category: key.category, range: (key.date, key.date))
                }
                .sorted { $0.range.start < $1.range.start }
            } else {
                let grouped = Dictionary(grouping: items, by: { calendar.startOfDay(for: $0.date) })
                return grouped.map { date, values in
                    let total = values.reduce(0) { $0 + $1.value }
                   // let label = date.formatted(date: .abbreviated, time: .omitted)
                    let label = monthLabel(date)
                    
                    return ChartPoint(label: label, value: total, category: selectedCategory, range: (date, date))
                }
                .sorted { $0.range.start < $1.range.start }
            }

        case .year:
            // One year window (Jan–Dec), swipe year by year. Ensure all 12 months appear.
            let today = Date()
            let currentYear = calendar.component(.year, from: today)
            let targetYear = currentYear - selectedPage

            // Build the 12 month starts for the target year
            let monthsInYear: [Date] = (1...12).compactMap { m in
                calendar.date(from: DateComponents(year: targetYear, month: m, day: 1))
            }

            // Helper for month label
            let monthLabel: (Date) -> String = { monthStart in
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM"
                return formatter.string(from: monthStart)
            }

            if isAll {
                // Produce a series per category, zero-filling months without data
                let categoriesToShow = Set(allData.map { $0.category })
                return monthsInYear.flatMap { monthStart -> [ChartPoint] in
                    guard let interval = calendar.dateInterval(of: .month, for: monthStart) else { return [] }
                    let label = monthLabel(monthStart)
                    return categoriesToShow.map { cat in
                        let monthValues = allData.filter { $0.category == cat && interval.contains($0.date) }
                        let total = monthValues.reduce(0) { $0 + $1.value }
                        return ChartPoint(label: label, value: total, category: cat, range: (interval.start, interval.end))
                    }
                }
            } else {
                // Single category: zero-fill each month
                return monthsInYear.compactMap { monthStart in
                    guard let interval = calendar.dateInterval(of: .month, for: monthStart) else { return nil }
                    let values = filtered.filter { interval.contains($0.date) }
                    let total = values.reduce(0) { $0 + $1.value }
                    let label = monthLabel(monthStart)
                    return ChartPoint(label: label, value: total, category: selectedCategory, range: (interval.start, interval.end))
                }
            }
        }
    }

    var totalSales: Double {
        chartData.reduce(0) { $0 + $1.value }
    }

    func previousPage() { selectedPage += 1 }
    func nextPage() { selectedPage = max(0, selectedPage - 1) }
}

struct SalesReportsView: View {
    @State private var vm = SalesReportViewModel()

    var body: some View {
        VStack(spacing: 12) {
            Text("Sales Reports")
                .font(.title2)
                .bold()

            Picker("Time", selection: $vm.selectedTimeRange) {
                ForEach(SalesReportViewModel.TimeRange.allCases) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            Menu {
                ForEach(vm.categories, id: \.self) { category in
                    Button(action: {
                        vm.selectedCategory = category
                    }) {
                        Label(category, systemImage: vm.selectedCategory == category ? "checkmark" : "")
                    }
                }
            } label: {
                Label(vm.selectedCategory, systemImage: "line.3.horizontal.decrease.circle")
                    .padding(.horizontal)
            }

            HStack {
                Button(action: { vm.previousPage() }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(currentRangeLabel)
                    .font(.callout)
                Spacer()
                Button(action: { vm.nextPage() }) {
                    Image(systemName: "chevron.right")
                }.disabled(vm.selectedPage == 0)
            }.padding(.horizontal)

            Text("Total: \(vm.totalSales, format: .currency(code: "GBP"))")
                .fontWeight(.semibold)

            Chart {
                ForEach(vm.chartData) { item in
                    LineMark(
                        x: .value("Date", item.label),
                        y: .value("Sales", item.value),
                        series: .value("Category", item.category)
                    )
                    .foregroundStyle(by: .value("Category", item.category))
                    .interpolationMethod(.catmullRom)

                    if (vm.selectedCategory == "All" && vm.selectedLabel == item.label + item.category)
                        || (vm.selectedCategory != "All" && vm.selectedLabel == item.label) {
                        PointMark(
                            x: .value("Date", item.label),
                            y: .value("Sales", item.value)
                        )
                        .annotation(position: .top) {
                            VStack(spacing: 4) {
                                Text("\(item.category)").font(.caption2)
                                Text(item.label).font(.caption)
                                Text(item.value, format: .currency(code: "GBP")).bold().font(.caption2)
                            }
                            .padding(6)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 2)
                        }
                    }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let location = value.location
                                    guard let x: String = proxy.value(atX: location.x) else { return }

                                    let tappedPoints = vm.chartData.filter { $0.label == x }

                                    // If "All" category, resolve closest line
                                    if vm.selectedCategory == "All",
                                       let tappedY: Double = proxy.value(atY: location.y),
                                       let nearest = tappedPoints.min(by: { abs($0.value - tappedY) < abs($1.value - tappedY) }) {
                                        vm.selectedLabel = nearest.label + nearest.category
                                    } else {
                                        // For single-category case
                                        vm.selectedLabel = x
                                    }
                                }
                        )
                }
            }
            .frame(height: 300)
            .padding(.horizontal)
        }.task({
           await vm.fetchSalesReports()
        })
        .padding()
    }

    private var currentRangeLabel: String {
        guard let first = vm.chartData.first?.range.start,
              let last = vm.chartData.last?.range.end else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return "\(formatter.string(from: first)) – \(formatter.string(from: last))"
    }
}

#Preview {
    SalesReportsView()
}

