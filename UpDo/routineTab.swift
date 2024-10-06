import SwiftUI
struct routineTab: View {
    @State private var selectedTab = 0
    @State private var selectedRoutine = "LOC Method"
    @State private var washDayDate = Date()
    @State private var isWashDayCompleted = false
    @State private var reminders: [Reminder] = []
    @State private var newReminderText = ""
    @State private var customRoutines: [CustomRoutine] = []
    
    let defaultRoutines = [
        "LOC Method",
        "Cleansing & Conditioning (Basic Routine)",
        "Leave-In Treatment",
        "Hot Oil Treatment",
        "Hair Mask Treatment",
        "Protective Styling",
        "Scalp Care Routine"
    ]
    
    var body: some View {
        RoutineView(selectedRoutine: $selectedRoutine, washDayDate: $washDayDate, isWashDayCompleted: $isWashDayCompleted, reminders: $reminders, newReminderText: $newReminderText, customRoutines: $customRoutines, defaultRoutines: defaultRoutines)
    }
}
struct RoutineView: View {
    @Binding var selectedRoutine: String
    @Binding var washDayDate: Date
    @Binding var isWashDayCompleted: Bool
    @Binding var reminders: [Reminder]
    @Binding var newReminderText: String
    @Binding var customRoutines: [CustomRoutine]
    let defaultRoutines: [String]
    @State private var isEditingRoutine = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Your Routine")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    Picker("Select Routine", selection: $selectedRoutine) {
                        ForEach(defaultRoutines, id: \.self) { routine in
                            Text(routine).tag(routine)
                        }
                    }
                    .background(Color(red: 0.347, green: 0.239, blue: 0.173))
                    .accentColor(Color(red: 0.953, green: 0.878, blue: 0.749))
                    .cornerRadius(10)
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    RoutineChecklist(routine: selectedRoutine, customRoutines: customRoutines)
                        .padding(.horizontal)
                    
                    if !customRoutines.isEmpty {
                        Divider()
                            .background(Color.black.opacity(0.2))
                            .padding(.horizontal)
                        
                        Text("My Routines")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        ForEach($customRoutines) { $routine in
                            CustomRoutineView(routine: $routine, customRoutines: $customRoutines)
                                .padding(.horizontal)
                        }
                    }
                    
                    Divider()
                        .background(Color.black.opacity(0.2))
                        .padding(.horizontal)
                    
                    RemindersSection(washDayDate: $washDayDate, isWashDayCompleted: $isWashDayCompleted, reminders: $reminders, newReminderText: $newReminderText)
                        .padding(.horizontal)
                }
            }
            .navigationBarItems(trailing: Button(action: {
                isEditingRoutine.toggle()
            }) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 22))
                    .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
            })
            .sheet(isPresented: $isEditingRoutine) {
                CreateRoutineView(customRoutines: $customRoutines)
            }
            .background(Color(red: 0.953, green: 0.878, blue: 0.749))
        }
    }
}
struct RoutineChecklist: View {
    let routine: String
    let customRoutines: [CustomRoutine]
    @State private var completedSteps: Set<String> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(routine)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                .padding(.vertical)
            
            ForEach(getSteps(for: routine), id: \.self) { step in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: completedSteps.contains(step) ? "checkmark.square.fill" : "square")
                        .font(.title3)
                        .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                        .frame(width: 30, alignment: .leading)
                    
                    Text(step)
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .contentShape(Rectangle())
                .onTapGesture(count: 2) {
                    if completedSteps.contains(step) {
                        completedSteps.remove(step)
                    } else {
                        completedSteps.insert(step)
                    }
                }
            }
        }
    }
    
    func getSteps(for routine: String) -> [String] {
        switch routine {
        case "LOC Method":
            return [
                "Liquid: Start with a liquid or leave-in conditioner.",
                "Oil: Apply an oil for added moisture and seal.",
                "Cream: Finish with a cream to lock in moisture."
            ]
        case "Cleansing & Conditioning (Basic Routine)":
            return [
                "Cleanse: Use a shampoo or cleansing conditioner to clean the hair.",
                "Condition: Apply a conditioner to detangle and moisturize."
            ]
        case "Leave-In Treatment":
            return [
                "Cleanse & Condition: Wash and condition your hair.",
                "Leave-In Conditioner: Apply a leave-in conditioner to keep hair moisturized and manageable throughout the day."
            ]
        case "Hot Oil Treatment":
            return [
                "Apply Oil: Warm oil (e.g., coconut, olive) is applied to the hair and scalp.",
                "Leave In: Let the oil sit for a period of time to deeply moisturize.",
                "Shampoo: Wash out the oil with shampoo."
            ]
        case "Hair Mask Treatment":
            return [
                "Cleanse: Wash hair as usual.",
                "Apply Mask: Use a deep conditioning mask to provide intense hydration and nourishment.",
                "Rinse: Rinse thoroughly."
            ]
        case "Protective Styling":
            return [
                "Choose Style: Opt for styles like braids, twists, or buns that protect the ends of your hair.",
                "Moisturize: Keep hair moisturized while it's in a protective style."
            ]
        case "Scalp Care Routine":
            return [
                "Exfoliate: Use a scalp scrub or treatment to remove buildup.",
                "Massage: Regularly massage the scalp to stimulate blood flow.",
                "Treat: Apply scalp treatments or oils as needed."
            ]
        default:
            if let customRoutine = customRoutines.first(where: { $0.title == routine }) {
                return customRoutine.steps
            }
            return []
        }
    }
}
struct CustomRoutineView: View {
    @Binding var routine: CustomRoutine
    @Binding var customRoutines: [CustomRoutine]
    @State private var completedSteps: Set<String> = []
    @State private var isEditingRoutine = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(routine.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                
                Spacer()
                
                Button(action: {
                    isEditingRoutine = true
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                }
            }
            .padding(.vertical)
            
            ForEach(routine.steps, id: \.self) { step in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: completedSteps.contains(step) ? "checkmark.square.fill" : "square")
                        .font(.title3)
                        .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                        .frame(width: 30, alignment: .leading)
                    
                    Text(step)
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .contentShape(Rectangle())
                .onTapGesture(count: 2) {
                    if completedSteps.contains(step) {
                        completedSteps.remove(step)
                    } else {
                        completedSteps.insert(step)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .sheet(isPresented: $isEditingRoutine) {
            EditRoutineView(routine: $routine, customRoutines: $customRoutines)
        }
    }
}
struct CreateRoutineView: View {
    @Binding var customRoutines: [CustomRoutine]
    @State private var newRoutineTitle = ""
    @State private var newRoutineSteps: [String] = [""]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Routine Title").font(.headline)) {
                    TextField("Enter routine title", text: $newRoutineTitle)
                }
                
                Section(header: Text("Steps").font(.headline)) {
                    ForEach(0..<newRoutineSteps.count, id: \.self) { index in
                        HStack {
                            TextField("Enter step", text: $newRoutineSteps[index])
                            
                            Button(action: {
                                newRoutineSteps.remove(at: index)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    Button(action: {
                        newRoutineSteps.append("")
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Step")
                        }
                    }
                }
            }
            .navigationBarTitle("Create New Routine", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                if !newRoutineTitle.isEmpty && !newRoutineSteps.isEmpty {
                    let newRoutine = CustomRoutine(title: newRoutineTitle, steps: newRoutineSteps.filter { !$0.isEmpty })
                    customRoutines.append(newRoutine)
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .background(Color(red: 0.953, green: 0.878, blue: 0.749))
            .accentColor(Color(red: 0.347, green: 0.239, blue: 0.173))
        }
    }
}
import SwiftUI
struct EditRoutineView: View {
    @Binding var routine: CustomRoutine
    @State private var title: String
    @State private var steps: [String]
    @Environment(\.presentationMode) var presentationMode
    @Binding var customRoutines: [CustomRoutine]
    
    init(routine: Binding<CustomRoutine>, customRoutines: Binding<[CustomRoutine]>) {
        self._routine = routine
        self._customRoutines = customRoutines
        self._title = State(initialValue: routine.wrappedValue.title)
        self._steps = State(initialValue: routine.wrappedValue.steps)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Routine Title").font(.headline)) {
                    TextField("Enter routine title", text: $title)
                }
                
                Section(header: Text("Steps").font(.headline)) {
                    ForEach(steps.indices, id: \.self) { index in
                        HStack {
                            TextField("Enter step", text: $steps[index])
                            
                            Button(action: {
                                steps.remove(at: index)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .onMove(perform: moveStep)
                    
                    Button(action: {
                        steps.append("")
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Step")
                        }
                    }
                }
                
                Section {
                    Button(action: deleteRoutine) {
                        Text("Delete Routine")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Edit Routine", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveChanges()
                }
            )
            .background(Color(red: 0.953, green: 0.878, blue: 0.749))
            .accentColor(Color(red: 0.347, green: 0.239, blue: 0.173))
        }
    }
    
    private func moveStep(from source: IndexSet, to destination: Int) {
        steps.move(fromOffsets: source, toOffset: destination)
    }
    
    private func saveChanges() {
        routine.title = title
        routine.steps = steps.filter { !$0.isEmpty }
        presentationMode.wrappedValue.dismiss()
    }
    
    private func deleteRoutine() {
        customRoutines.removeAll { $0.id == routine.id }
        presentationMode.wrappedValue.dismiss()
    }
}
struct RemindersSection: View {
    @Binding var washDayDate: Date
    @Binding var isWashDayCompleted: Bool
    @Binding var reminders: [Reminder]
    @Binding var newReminderText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Reminders")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                .padding(.bottom)
            
            HStack {
                TextField("Add new reminder", text: $newReminderText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if !newReminderText.isEmpty {
                        reminders.append(Reminder(text: newReminderText, isCompleted: false))
                        newReminderText = ""
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                }
            }
            .padding(.bottom)
            
            HStack(alignment: .center, spacing: 10) {
                Button(action: {
                    isWashDayCompleted.toggle()
                    if isWashDayCompleted {
                        washDayDate = Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
                    }
                }) {
                    Image(systemName: isWashDayCompleted ? "checkmark.square.fill" : "square")
                        .font(.title3)
                        .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                        .frame(width: 30, alignment: .leading)
                }
                
                Text("Wash Day")
                    .font(.system(size: 18))
                    .fontWeight(.regular)
                    .foregroundColor(.black)
                
                Spacer()
                
                DatePicker("", selection: $washDayDate, displayedComponents: .date)
                    .labelsHidden()
            }
            .padding(.bottom)
            
            ForEach($reminders) { $reminder in
                HStack(alignment: .top, spacing: 10) {
                    Button(action: {
                        reminder.isCompleted.toggle()
                    }) {
                        Image(systemName: reminder.isCompleted ? "checkmark.square.fill" : "square")
                            .font(.title3)
                            .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                            .frame(width: 30, alignment: .leading)
                    }
                    
                    Text(reminder.text)
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    Button(action: {
                        reminders.removeAll { $0.id == reminder.id }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                .padding(.vertical, 5)
            }
        }
    }
}





struct ReminderRow: View {
    @Binding var reminder: Reminder
    @Binding var reminders: [Reminder]
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Button(action: {
                reminder.isCompleted.toggle()
            }) {
                Image(systemName: reminder.isCompleted ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                    .frame(width: 30, alignment: .leading)
            }
            
            TextField("", text: $reminder.text)
                .font(.system(size: 18))
                .foregroundColor(.black)
                .strikethrough(reminder.isCompleted)
            
            Spacer()
            
            Button(action: {
                reminders.removeAll { $0.id == reminder.id }
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 5)
        .background(Color.white.opacity(0.5))
        .cornerRadius(8)
    }
}
struct Reminder: Identifiable {
    let id = UUID()
    var text: String
    var isCompleted: Bool
}


struct CustomRoutine: Identifiable {
    let id: UUID
    var title: String
    var steps: [String]
    
    init(id: UUID = UUID(), title: String, steps: [String]) {
        self.id = id
        self.title = title
        self.steps = steps
    }
}


#Preview {
    routineTab()
}

