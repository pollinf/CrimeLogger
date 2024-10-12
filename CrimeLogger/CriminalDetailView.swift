//
//  CriminalDetailView.swift
//  CrimeLogger
//
//  Created by polina on 01.10.2024.
//
import SwiftUI
import CoreData
struct CriminalDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var criminal: Criminal
    @State private var showingEditView = false // Статус показа Edit View

    var body: some View {
        ScrollView { // Добавляем ScrollView для прокрутки
            VStack {
                if let imageName = criminal.imageName,
                   let image = loadImageFromDocuments(fileName: imageName) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill() // Используем scaledToFill для квадратного отображения
                        .frame(width: 200, height: 200) // Размеры для аватара
                        .clipShape(Rectangle()) // Прямоугольник для детальной информации
                        .cornerRadius(10) // Скругление углов
                        .shadow(radius: 5)
                } else {
                    Image("defaultImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(Rectangle())
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }

                Text(criminal.name ?? "Без имени")
                    .font(.largeTitle)
                    .padding()

                Text(criminal.crime ?? "Неизвестное преступление")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding()

                // Дополнительная информация о преступнике
                Text("Статьи: \(criminal.articles ?? "Нет информации.")")
                    .padding()

                // Отображаем дополнительную информацию, если она доступна
                if let additionalInfo = criminal.additionalInfo, !additionalInfo.isEmpty {
                    Text("Дополнительная информация: \(additionalInfo)")
                        .padding()
                } else {
                    Text("Нет дополнительной информации.")
                        .padding()
                }

                // Разделитель
                Divider()

                // Кнопки для редактирования и удаления
                HStack {
                    Button(action: {
                        showingEditView = true // Показываем Edit View
                    }) {
                        Text("Редактировать")
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity) // Занять все доступное пространство
                    }
                    .padding()

                    Button(action: {
                        deleteCriminal()
                    }) {
                        Text("Удалить")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity) // Занять все доступное пространство
                    }
                    .padding()
                }
                .background(Color.gray.opacity(0.1)) // Фоновый цвет для кнопок
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .navigationTitle("Детали преступника")
            .navigationBarBackButtonHidden(true) // Скрываем стандартную кнопку "Назад"
            .toolbar {
                // Добавляем кнопку "Назад" в тулбар
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss() // Возврат на предыдущий экран
                    }) {
                        Text("Назад")
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingEditView) { // Модальное представление для редактирования
            AddCriminalView(existingCriminal: criminal) // Открываем AddCriminalView с существующим преступником
        }
    }

    private func deleteCriminal() {
        viewContext.delete(criminal)
        do {
            try viewContext.save()
            dismiss()
        } catch {
            let nsError = error as NSError
            print("Ошибка при удалении преступника: \(nsError), \(nsError.userInfo)")
        }
    }
}
