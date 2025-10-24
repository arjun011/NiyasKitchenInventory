//
//  DashboardView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 12/08/25.
//

import SwiftUI

struct DashboardView: View {

    @Environment(AppSession.self) private var session
    @State private var vm = DashboardViewModel()
    @State private var showPunchInPicker = false
    @State private var showPunchOutPicker = false
    @State private var selectedPunchInTime: Date = Date()
    @State private var selectedPunchOutTime: Date = Date()

    private enum Route: Hashable {
        case reservationView
        case dailySalesReportView
    }
    @State private var navPath: [Route] = []

    private func snappedToQuarterHour(_ date: Date) -> Date {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.hour, .minute], from: date)
        let minute = comps.minute ?? 0
        let snapped = (minute / 15) * 15
        if let hour = comps.hour,
           let adjusted = calendar.date(bySettingHour: hour, minute: snapped, second: 0, of: date) {
            return adjusted
        }
        return date
    }

    private struct QuarterHourTimePicker: View {
        let title: String
        @Binding var date: Date
        var onSnap: (Date) -> Date

        var body: some View {
            VStack(spacing: 16) {
                DatePicker(
                    title,
                    selection: $date,
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .onChange(of: date) { oldValue, newValue in
                    let adjusted = onSnap(newValue)
                    if adjusted != newValue {
                        date = adjusted
                    }
                }

                Spacer()
            }
        }
    }

    var body: some View {

        NavigationStack(path: $navPath) {

            ScrollView {

                VStack(alignment: .leading, spacing: 16) {
                    KIPStatCardView(
                        title: "Total Items", value: vm.totalInventoryCount,
                        icon: "cube.box.fill", bgColor: Color.brandPrimary
                    ) {

                    }

                    KIPStatCardView(
                        title: "Low Stock", value: vm.lowStockInventoryCount,
                        icon: "exclamationmark.triangle.fill",
                        bgColor: Color.appWarning
                    ) {
                        print("Low stock")
                    }

                    KIPStatCardView(
                        title: "Needs Review (7d)",
                        value: vm.staleInventoryCount,
                        icon: "clock.fill", bgColor: Color.brandPrimary
                    ) {
                        print("Need review")
                    }

                    KIPStatCardView(
                        title: "Waste This Week",
                        value: vm.wasteLastSevenDayCount,
                        icon: "trash.fill", bgColor: Color.appDanger
                    ) {
                        print("wast this week")
                    }

                    KIPStatCardView(
                        title: vm.bookingTitle, value: vm.bookingCount,
                        icon: "calendar", bgColor: Color.brandPrimary
                    ) {
                        print("Booking ")
                        navPath.append(.reservationView)
                    }

                    KIPStatCardView(
                        title: "Daily Sales",
                        value: 0,  // Optional: Could use today's total sales if available
                        icon: "banknote",
                        bgColor: Color.brandPrimary
                    ) {
                        navPath.append(.dailySalesReportView)

                    }

                    VStack(
                        alignment: .leading,
                        content: {

                            Text("Quick Actions")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(Color.textPrimary)

                            HStack(alignment: .center, spacing: 15) {
                                PillButtonView(title: "Punch In") {
                                    selectedPunchInTime = Date()
                                    showPunchInPicker = true
                                }.disabled(!vm.isPunchInEnabled)

                                PillButtonView(title: "Punch Out") {
                                    selectedPunchOutTime = Date()
                                    showPunchOutPicker = true
                                }.disabled(!vm.isPunchOutEnabled)
                            }

                            HStack(alignment: .center, spacing: 15) {

                                NavigationLink {
                                    POView()
                                } label: {

                                    Text("Purchase orders")
                                        .padding()
                                        .foregroundStyle(Color.white)
                                        .font(
                                            .system(size: 16, weight: .semibold)
                                        )
                                        .background(
                                            Capsule().fill(Color.brandPrimary))
                                }
                            }

                        }
                    ).padding(.horizontal)
                }

                .navigationTitle("Dashboard")
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {

                        Text(
                            "Hi, \(self.session.profile?.displayName ?? "Patel")"
                        )
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.textPrimary)

                    }
                }
            }
            .sheet(isPresented: $showPunchInPicker) {
                NavigationStack {
                    QuarterHourTimePicker(title: "Select Time", date: $selectedPunchInTime, onSnap: { date in
                        snappedToQuarterHour(date)
                    })
                    .padding()
                    .navigationTitle("Punch In Time")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showPunchInPicker = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Confirm") {
                                // Call punch with selected time; if VM supports passing date, use it; otherwise call existing method
                                Task {
                                    await vm.punchNow(userId: session.profile?.uid ?? "")
                                }
                                showPunchInPicker = false
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                .presentationDetents([.height(320), .medium])
            }
            .sheet(isPresented: $showPunchOutPicker) {
                NavigationStack {
                    QuarterHourTimePicker(title: "Select Time", date: $selectedPunchOutTime, onSnap: { date in
                        snappedToQuarterHour(date)
                    })
                    .padding()
                    .navigationTitle("Punch Out Time")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showPunchOutPicker = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Confirm") {
                                // Call punch out with selected time; if VM supports passing date, use it; otherwise call existing method
                                Task {
                                    await vm.punchNow(userId: session.profile?.uid ?? "")
                                }
                                showPunchOutPicker = false
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                .presentationDetents([.height(320), .medium])
            }
            .task {
                await withTaskGroup(of: Void.self) { group in
                    group.addTask { await vm.getInventoryList() }
                    group.addTask { await vm.getWasteCount() }
                    group.addTask { await vm.loadBookings() }
                    group.addTask {
                        guard let userId = await session.profile?.uid else {
                            return
                        }
                        await vm.checkPunchStateOnAppOpen(
                            userId: userId)
                    }
                }
            }
            .navigationDestination(for: Route.self) { screenEnum in

                DashboardView.navigate(to: screenEnum)

            }

        }

    }

}

extension DashboardView {

    private static func navigate(to screen: Route) -> some View {

        switch screen {
        case .reservationView:
            return AnyView(ReservationView())
        case .dailySalesReportView:
            return AnyView(DailySalesView())
        }
    }
}

#Preview {

    NavigationStack {
        DashboardView()
            .environment(AppSession())
    }

}
