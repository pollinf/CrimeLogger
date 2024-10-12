//
//  AddCriminalView.swift
//  CrimeLogger
//
//  Created by polina on 10.09.2024.
//
import SwiftUI
import CoreData

struct AddCriminalView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var crime: String = ""
    @State private var articles: String = ""
    @State private var additionalInfo: String = ""
    @State private var selectedDate = Date() 
    @State private var selectedLaw: String = ""
    @State private var laws: [String] = ["123", "32"]
    @State private var image: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var showingDatePicker = false
    @State private var showingLawPicker = false

    var existingCriminal: Criminal?

    var body: some View {
        VStack {
            HStack {
                Button("Назад") {
                    dismiss()
                }
                .foregroundColor(.black)
                Spacer()
                Text("Добавить")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
                Button("Сохранить") {
                    saveCriminal()
                    dismiss()
                }
                .foregroundColor(.black)
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        TextField("ФИО", text: $name)
                            .padding()
                            .background(Color(white: 0.95))
                            .cornerRadius(15)
                    }
                    
                    HStack {
                        TextField("Дополнительная информация", text: $additionalInfo)
                            .padding()
                            .background(Color(white: 0.95))
                            .cornerRadius(15)
                    }
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("Время/дата")
                                .foregroundColor(.gray)
                                .font(.headline)
                            Button(action: {
                                showingDatePicker = true
                            }) {
                                Text("\(selectedDate, formatter: dateFormatter)")
                                    .padding(5)
                                    .background(Color(white: 0.95))
                                    .cornerRadius(10)
                            }
                            .sheet(isPresented: $showingDatePicker) {
                                NavigationView {
                                    VStack {
                                        DatePicker(
                                            "Выберите дату и время",
                                            selection: $selectedDate,
                                            displayedComponents: [.date, .hourAndMinute]
                                        )
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .padding()
                                        Spacer()
                                    }
                                    .toolbar {
                                        ToolbarItem(placement: .navigationBarTrailing) {
                                            Button("Сохранить") {
                                                showingDatePicker = false
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(white: 0.98))
                        .cornerRadius(15)
                        .shadow(radius: 1)
                        
                        VStack(alignment: .leading) {
                            Text("Статья")
                                .foregroundColor(.gray)
                                .font(.headline)
                            Button(action: {
                                showingLawPicker = true
                            }) {
                                Text(selectedLaw.isEmpty ? "Выберите статью" : selectedLaw)
                                    .padding(5)
                                    .background(Color(white: 0.95))
                                    .cornerRadius(10)
                            }
                            .sheet(isPresented: $showingLawPicker) {
                                NavigationView {
                                    LawPickerView(laws: laws, selectedLaw: $selectedLaw)
                                        .toolbar {
                                            ToolbarItem(placement: .navigationBarTrailing) {
                                                Button("Сохранить") {
                                                    showingLawPicker = false
                                                }
                                            }
                                        }
                                }
                            }
                        }
                        .padding()
                        .background(Color(white: 0.98))
                        .cornerRadius(15)
                        .shadow(radius: 1)
                    }
                    
                    VStack {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .padding()
                        }
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            HStack {
                                Text("Добавить фото")
                                    .foregroundColor(.gray)
                                    .padding()
                                Spacer()
                                Image(systemName: "plus")
                                    .foregroundColor(.gray)
                            }
                            .background(Color(white: 0.95))
                            .cornerRadius(15)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $image)
        }
        .onAppear {
            if let existingCriminal = existingCriminal {
                name = existingCriminal.name ?? ""
                crime = existingCriminal.crime ?? ""
                articles = existingCriminal.articles ?? ""
                additionalInfo = existingCriminal.additionalInfo ?? ""
                if let imageName = existingCriminal.imageName,
                   let loadedImage = loadImageFromDocuments(fileName: imageName) {
                    image = loadedImage
                }
            }
        }
    }
    
    private func saveCriminal() {
        if let existingCriminal = existingCriminal {
            existingCriminal.name = name
            existingCriminal.crime = crime
            existingCriminal.articles = articles
            existingCriminal.additionalInfo = additionalInfo
            if let image = image {
                if let imageName = saveImageToDocuments(image: image) {
                    existingCriminal.imageName = imageName
                }
            }
        } else {
            let newCriminal = Criminal(context: viewContext)
            newCriminal.name = name
            newCriminal.crime = crime
            newCriminal.articles = articles
            newCriminal.additionalInfo = additionalInfo
            if let image = image {
                if let imageName = saveImageToDocuments(image: image) {
                    newCriminal.imageName = imageName
                }
            }
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Ошибка при сохранении: \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func saveImageToDocuments(image: UIImage) -> String? {
        let imageName = UUID().uuidString
        if let data = image.jpegData(compressionQuality: 0.8) {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(imageName + ".jpg")
            do {
                try data.write(to: url)
                return imageName
            } catch {
                return nil
            }
        }
        return nil
    }
}

struct LawPickerView: View {
    let laws: [String]
    @Binding var selectedLaw: String
    
    var body: some View {
        List(laws, id: \.self) { law in
            Button(action: {
                selectedLaw = law
            }) {
                HStack {
                    Text(law)
                    if selectedLaw == law {
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .navigationTitle("Выберите статью")
    }
}

private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}

struct AddCriminalView_Previews: PreviewProvider {
    static var previews: some View {
        AddCriminalView()
    }
}
