import SwiftUI

struct ToDo: Identifiable {
    let id = UUID()
    var task: String
    var date: Date
    var isChecked: Bool
    var priority: String
}

struct ContentView: View {
    @State private var searchText = ""
    @State private var taskList = [
        ToDo(
            task: "Beispiel 1", date: Date.now, isChecked: false,
            priority: "medium"),
        ToDo(
            task: "Beispiel 2", date: Date.now, isChecked: false,
            priority: "high"),
        ToDo(
            task: "Beispiel 3", date: Date.now, isChecked: true, priority: "low"
        ),
        ToDo(
            task: "Beispiel 4", date: Date.now, isChecked: false,
            priority: "medium"),
    ]

    @State private var showingNewItemView = false
    @State private var showingFolder = false

    func delete(at offsets: IndexSet) {
        taskList.remove(atOffsets: offsets)
    }

    func priorityColor(priority: String) -> Color {
        switch priority {
        case "high":
            return .red
        case "medium":
            return .orange
        case "low":
            return .green
        default:
            return .gray
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(taskList.indices, id: \.self) { index in
                    HStack {
                        Button(action: {
                            taskList[index].isChecked.toggle()
                        }) {
                            if taskList[index].isChecked {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(.tint)
                            } else {
                                Image(systemName: "circle")
                                    .font(.title)
                                    .foregroundStyle(.gray)
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(taskList[index].task)
                                .bold()
                                .font(.headline)

                            Text(
                                taskList[index].date,
                                format: .dateTime.day().month().year()
                            )
                            .foregroundStyle(.gray)
                            .font(.footnote)

                        }
                        Spacer()

                        Text(taskList[index].priority)
                            .frame(width: 75, height: 30)
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(
                                priorityColor(
                                    priority: taskList[index].priority)
                            )
                            .cornerRadius(15)

                    }

                }
                .onDelete(perform: delete)
            }
            .listStyle(.plain)
            .navigationTitle("ToDo-List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingNewItemView = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.tint)
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingFolder = true
                    } label: {
                        Image(systemName: "chevron.backward")
                        Text("Folder")
                            .gridColumnAlignment(.leading)
                            .foregroundStyle(.tint)
                    }
                }

            }
            .sheet(isPresented: $showingNewItemView) {
                newItemView { newTask in
                    taskList.append(newTask)
                }
            }

        }
        .searchable(text: $searchText)

    }
}

struct newItemView: View {
    @State private var task = ""
    @State private var date = Date()
    @State private var priority = "medium"
    var onSave: (ToDo) -> Void
    @Environment(\.dismiss) var dismiss
    @FocusState private var titleIsFocused: Bool

    let priorities = ["low", "medium", "high"]

    var body: some View {
        NavigationStack {
            VStack {
                Text("New Item")
                    .font(.system(size: 32))
                    .bold()

                Form {
                    TextField("Title", text: $task)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .focused($titleIsFocused)

                    DatePicker(
                        "Datum", selection: $date, displayedComponents: .date
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())

                    Picker("Priorität", selection: $priority) {
                        ForEach(priorities, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(12)
                        .background(Color.gray)
                        .foregroundStyle(.white)
                        .cornerRadius(10)

                        Button("Save") {
                            let newToDo = ToDo(
                                task: task, date: date, isChecked: false,
                                priority: priority)
                            onSave(newToDo)
                            dismiss()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(task.isEmpty)
                    }

                }
                .padding()

                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            titleIsFocused = false
                        }
                    }
                }
            }
        }
    }
}

//In edit:
struct newFolderView: View {
    var body: some View {
        VStack {
            Section {
                Text("Folder")
                    .font(.system(size: 32))
                    .bold()
            }
        }
    }
}

#Preview {
    ContentView()
}
