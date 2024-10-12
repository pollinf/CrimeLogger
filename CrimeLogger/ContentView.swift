//
//  ContentView.swift
//  CrimeLogger
//
//  Created by polina on 09.09.2024.
import SwiftUI
import CoreData

struct ContentView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Criminal.name, ascending: true)],
        animation: .default
    ) private var criminals: FetchedResults<Criminal>
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Список преступников")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            NavigationLink(destination: AddCriminalView()) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(Color(red: 1.0, green: 0.5, blue: 0.4))
                                    .padding(.trailing, 10)
                            }
                        }
                        .padding([.top, .leading, .trailing], 15)
                        
                        Text("Самые недавние")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                            .padding([.leading, .bottom], 10)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(criminals.prefix(5)) { criminal in
                                    NavigationLink(destination: CriminalDetailView(criminal: criminal)) {
                                        VStack(alignment: .leading) {
                                            if isSimulator() {
                                                Image("defaultImage")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 80, height: 80)
                                                    .clipShape(Circle())
                                                    .shadow(radius: 3)
                                            } else {
                                                if let imageName = criminal.imageName,
                                                   let image = loadImageFromDocuments(fileName: imageName) {
                                                    Image(uiImage: image)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 80, height: 80)
                                                        .clipShape(Circle())
                                                        .shadow(radius: 3)
                                                } else {
                                                    Image("defaultImage")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 80, height: 80)
                                                        .clipShape(Circle())
                                                        .shadow(radius: 3)
                                                }
                                            }
                                            
                                            Text(criminal.name ?? "Без имени")
                                                .font(.caption)
                                                .frame(width: 90, alignment: .leading)
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 15)
                        }
                        .frame(height: 120)
                        
                        Divider()
                        Text("Общий список по алфавиту")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.black)
                            .padding(.top, 15)
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(groupedCriminals(), id: \.key) { letter, criminals in
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(String(letter))
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.gray)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 15)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(white: 0.9))
                                    ForEach(criminals) { criminal in
                                        VStack(alignment: .leading) {
                                            NavigationLink(destination: CriminalDetailView(criminal: criminal)) {
                                                HStack {
                                                    if isSimulator() {
                                                        Image("defaultImage")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 50, height: 50)
                                                            .clipShape(Circle())
                                                            .padding(.trailing, 10)
                                                    } else {
                                                        if let imageName = criminal.imageName,
                                                           let image = loadImageFromDocuments(fileName: imageName) {
                                                            Image(uiImage: image)
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 50, height: 50)
                                                                .clipShape(Circle())
                                                                .padding(.trailing, 10)
                                                        } else {
                                                            Image("defaultImage")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 50, height: 50)
                                                                .clipShape(Circle())
                                                                .padding(.trailing, 10)
                                                        }
                                                    }
                                                    
                                                    VStack(alignment: .leading) {
                                                        Text(criminal.name ?? "Без имени")
                                                            .font(.headline)
                                                            .foregroundColor(.black)
                                                        Text(criminal.crime ?? "Неизвестное преступление")
                                                            .font(.subheadline)
                                                            .foregroundColor(.gray)
                                                    }
                                                }
                                                .padding(.vertical, 15)
                                            }
                                            Divider()
                                                .background(Color.gray)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(white: 0.95))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .preferredColorScheme(.light)
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
    }
    
    func groupedCriminals() -> [(key: Character, value: [Criminal])] {
        let grouped = Dictionary(grouping: criminals) { criminal in
            criminal.name?.first?.uppercased().first ?? "#"
        }
        return grouped.sorted { $0.key < $1.key }
    }
    
    func isSimulator() -> Bool {
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 15")
    }
}
