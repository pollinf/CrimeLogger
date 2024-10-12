//
//  Utilities.swift
//  CrimeLogger
//
//  Created by polina on 01.10.2024.
//

import UIKit

// Функция для загрузки изображения из директории документов
func loadImageFromDocuments(fileName: String) -> UIImage? {
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent(fileName + ".jpg")
    if let data = try? Data(contentsOf: url) {
        return UIImage(data: data)
    }
    return nil
}

// Функция для сохранения изображения в директории документов
func saveImageToDocuments(image: UIImage) -> String? {
    let imageName = UUID().uuidString // Генерация уникального имени
    if let data = image.jpegData(compressionQuality: 0.8) {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(imageName + ".jpg")
        
        do {
            try data.write(to: url)
            print("Изображение успешно сохранено по пути: \(url)")
            return imageName // Возвращаем имя файла при успехе
        } catch {
            print("Ошибка при сохранении изображения: \(error.localizedDescription)")
            return nil // Возвращаем nil при неудаче
        }
    }
    return nil
}
