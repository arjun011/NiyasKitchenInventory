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

    private enum Route: Hashable {
        case reservationView
        case dailySalesReportView
    }
    @State private var navPath: [Route] = []
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
                                    Task {
                                        await vm.punchNow(
                                            userId: session.profile?.uid ?? "")
                                    }
                                }.disabled(!vm.isPunchInEnabled)

                                PillButtonView(title: "Punch Out") {
                                    Task {
                                        await vm.punchNow(
                                            userId: session.profile?.uid ?? "")
                                    }
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

            }.task {
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
            }.navigationDestination(for: Route.self) { screenEnum in

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
