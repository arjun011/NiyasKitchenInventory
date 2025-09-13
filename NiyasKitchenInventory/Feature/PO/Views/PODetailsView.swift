//
//  PODetailsView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 08/09/25.
//

import SwiftUI
import MessageUI

struct PODetailsView: View {
    @State private var vm = PODetailsViewModel()
    var orderDetail: POModel
    @State private var showComposer = false
    @State private var composerPayload: (to: String, subject: String, body: String)?

    var body: some View {
        List {

            Section {

                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(orderDetail.supplierName).font(.headline)
                        Text(orderDetail.supplierEmail).font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(orderDetail.status)
                        .font(.caption).bold()
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(
                            orderDetail.orderStatus.chipColor.opacity(0.15),
                            in: Capsule()
                        )
                        .foregroundStyle(orderDetail.orderStatus.chipColor)

                }

                HStack {

                    Label(
                        orderDetail.dispalyDateOnDetails?.formatted(
                            date: .long, time: .omitted) ?? "N/A",
                        systemImage: "calendar")
                    Spacer()
                    if let cnt = orderDetail.lineCount {
                        Label("\(cnt) items", systemImage: "list.number")
                    }
                }
                .font(.subheadline).foregroundStyle(.secondary)

            } header: {
                Text("Purchase Order")
            }

            Section {
                if vm.lines.isEmpty {
                    Text("No lines").foregroundStyle(.secondary)
                } else {
                    ForEach(vm.lines) { line in
                        HStack {
                            Text(line.itemName)
                            Spacer()

                            Text(
                                "\(line.orderedQty ?? 0, format: .number) \(line.unitName)"
                            )

                        }
                    }.onDelete { offsets in

                        for index in offsets {
                            let lineID = vm.lines[index].id ?? ""

                            Task {
                                await vm.deletedLine(
                                    poID: orderDetail.id ?? "",
                                    lineId: lineID)
                            }
                        }

                    }
                }
            } header: {
                Text("Items")
            }
            
            if orderDetail.orderStatus != .closed && orderDetail.orderStatus != .canceled {
                
                Section {

                    HStack {

                        RoundedRectangleButton(
                            fill: .brandPrimary, textColor: .white, text: "Send to Supplier"
                        ) {

                            presentComposer(for: orderDetail , lines: vm.lines)
                            
                            print("Send action")

                        }.buttonStyle(.plain)

                        RoundedRectangleButton(
                            fill: .appDanger, textColor: .white, text: "Cancel"
                        ) {

                            Task {
                                 await vm.cancelOrder(poID: orderDetail.id ?? "")
                            }

                        }.buttonStyle(.plain)
                    }.frame(maxWidth: .infinity, alignment: .center)
                        .listRowInsets(EdgeInsets())  // remove default padding
                        .listRowBackground(Color.clear)

                } header: {
                    Text("Actions")
                }.sheet(isPresented: $showComposer) {
                    if let payload = composerPayload {
                        MailComposerView(to: payload.to, subject: payload.subject, body: payload.body) { result in
                            switch result {
                            case .success:
                                
                                print("mail send successfully")
                                
                               // Task { await vm.didSendEmailSuccessfully() }
                            case .failure:
                                break // user cancelled or error; do nothing
                            }
                        }
                    }
                }

                
            }

        }.task {
            await vm.getPOLines(poID: orderDetail.id ?? "")
        }
    }
    
    private func presentComposer(for po: POModel, lines: [POLineModel]) {
            guard MFMailComposeViewController.canSendMail() else {
                // Fallback: open Mail app
                let subject = "PO \(po.id ?? "") – \(po.supplierName)"
                let body = makeEmailBody(po: po, lines: lines)
                let to = po.supplierEmail.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                let sub = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                let bod = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                if let url = URL(string: "mailto:\(to)?subject=\(sub)&body=\(bod)") {
                    UIApplication.shared.open(url)
                }
                return
            }
            composerPayload = (po.supplierEmail, "PO \(po.id ?? "") – \(po.supplierName)", makeEmailBody(po: po, lines: lines))
            showComposer = true
        }

        private func makeEmailBody(po: POModel, lines: [POLineModel]) -> String {
            let date = DateFormatter.localizedString(from: po.expectedDate ?? Date(), dateStyle: .medium, timeStyle: .none)
            let items = lines.map { "• \($0.itemName): \(Double($0.orderedQty ?? 0)) \($0.unitName)" }.joined(separator: "\n")
            let body = """
            Hello \(po.supplierName),

            Please find our purchase order:

            PO ID: \(po.id ?? "-")
            Expected Delivery: \(date)

            Items:
            \(items)

            Notes:
            \(po.notes ?? "-")

            Regards,
            Niya's Kitchen
            """
            return body
        }
}

#Preview {
    PODetailsView(orderDetail: mocPOModel)
}
