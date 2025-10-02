import SwiftUI
import Firebase

struct AttendanceReportView: View {

    @State private var vm = AttendanceReportViewModel()
    @Environment(AppSession.self) private var session

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                headerSection
                Text("Total Hours: \(vm.totalHours)")
                    .font(.headline)
                    .padding(.bottom, 4)

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(vm.attendanceRecords) { record in
                            AttendanceCard(record: record)
                        }
                    }
                    .padding(.horizontal)
                }.sheet(isPresented: $vm.showDatePicker) {
                    DateRangePickerView(startDate: $vm.startDate, endDate: $vm.endDate) {
                        Task { await vm.loadAttendance() }
                    }
                }
            }.task {
                guard let loginUser = session.profile else {
                    return
                }
                await vm.loadCurrentUser(currentUser: loginUser)
            }
            .navigationTitle("Attendance")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    if vm.currentUserRole != "Employee" {
                        staffSelectorMenu
                    }
                }
            })
            
            
        }
    }

    private var headerSection: some View {
        HStack {
            dateRangeButton
            Spacer()
            
            exportButton
        }
        .padding(.horizontal)
    }

    private var dateRangeButton: some View {
        Button {
            vm.showDatePicker = true
        } label: {
            HStack {
                Text(vm.startDate.formatted(date: .abbreviated, time: .omitted))
                Text("-")
                Text(vm.endDate.formatted(date: .abbreviated, time: .omitted))
                Image(systemName: "calendar")
            }
            .padding(8)
            .cornerRadius(8)
        }
    }

    private var staffSelectorMenu: some View {
        Menu {
            ForEach(vm.staffList, id: \.uid) { staff in
                Button(staff.displayName ?? "") {
                    vm.selectedStaffId = staff.uid
                    Task { await vm.loadAttendance() }
                }
            }
        } label: {
            let selectedName = vm.staffList.first(where: { $0.uid == vm.selectedStaffId })?.displayName ?? "Me"
            HStack {
                Text("\(selectedName)")
                Image(systemName: "person.2")
            }
            .padding(8)
           // .background(Color(.secondarySystemBackground))
            //.cornerRadius(8)
        }
    }

    private var exportButton: some View {
        Button(action: exportAttendance) {
            Image(systemName: "square.and.arrow.up")
                .padding(8)
        }
    }

    private func exportAttendance() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let header = "Date,Status,Working Hours"
        let csv = vm.attendanceRecords.map {
            "\($0.formattedDate),\($0.status == .present ? "Present" : "Missed Punch Out"),\($0.formattedDuration)"
        }.joined(separator: "\n")

        let fullCSV = "\(header)\n\(csv)"
        let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent("AttendanceReport.csv")

        do {
            try fullCSV.write(to: tmpURL, atomically: true, encoding: .utf8)

            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = scene.windows.first?.rootViewController {
                let activityVC = UIActivityViewController(activityItems: [tmpURL], applicationActivities: nil)
                rootVC.present(activityVC, animated: true)
            }
        } catch {
            print("Export failed: \(error.localizedDescription)")
        }
    }
}

private struct AttendanceCard: View {
    let record: AttendanceRecord

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Date: \(record.formattedDate)")
                    .font(.headline)
                Text(record.status == .present ? "Status: Present" : "⚠️ Missed Punch Out")
                    .font(.subheadline)
                    .foregroundColor(record.isIrregular ? .orange : .green)
            }
            Spacer()
            Text(record.formattedDuration)
                .font(.subheadline)
        }
        .padding()
        .background(record.isIrregular ? Color.orange.opacity(0.15) : Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct DateRangePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var startDate: Date
    @Binding var endDate: Date
    var onApply: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
                DatePicker("End Date", selection: $endDate, in: startDate..., displayedComponents: [.date])
            }
            .navigationTitle("Select Date Range")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        onApply()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AttendanceReportView()
        .environment(AppSession())
}
