//
//  ContentView.swift
//  Notes
//
//  Created by Dev Adnani on 20/12/22.
//

import SwiftUI

struct Home: View {
    
    @State var notes = [Note]()
    @State var showAdd = false
    @State var showAlert = false
    @State var deleteItem : Note?
    @State var updateNote : String = ""
    @State var updateNoteID : String = ""
    @State var isEditMode:EditMode = .inactive
    
    
    var alert:Alert {
        Alert(title: Text("Delete"), message: Text("Are You Sure You Wanna Delete It ?") ,primaryButton: .destructive(Text("Delete"),action: deleteNote), secondaryButton: .cancel())
    }
    
    
    var body: some View {
        NavigationView{
            List(self.notes)
            {
                note in
                if (self.isEditMode == .inactive) {
                    Text(note.note).padding().onLongPressGesture {
                        self.showAlert.toggle()
                        deleteItem = note
                    }
                }
                else
                {
                    HStack{
                        Image(systemName: "pencil.circle.fill").foregroundColor(Color.cyan)
                        Text(note.note).padding()
                        
                    }.onTapGesture {
                        self.updateNote = note.note
                        self.updateNoteID = note._id
                        
                        self.showAdd.toggle()
                    }
                }
                
            }.alert(isPresented: $showAlert, content: { alert })
            .sheet(isPresented: $showAdd,onDismiss: fetchNotes , content: {
                if(self.isEditMode == .inactive)
                {
                    AddNotesView()
                }
                else
                {
                   UpdateNoteView(note: $updateNote, noteID: $updateNoteID)
                }
            })
            .onAppear(perform: {
                fetchNotes()
            })
            .navigationTitle("Notes")
            .navigationBarItems(leading:Button(action: {
                if (self.isEditMode == .inactive) {
                    self.isEditMode = .active
                }
                else
                {
                    self.isEditMode = .inactive
                }
            }, label: {
                if (self.isEditMode == .inactive) {
                    Text("Edit")
                }
                else
                {
                    Text("Done")
                }
            }),trailing: Button(action: {
                self.showAdd.toggle()
            }, label: {
                Text("Add")
            }))
        }
       
    }
    
    func fetchNotes()
    {
        let url = URL(string: "http://localhost:3000/getNotes")!
        
        let task = URLSession.shared.dataTask(with: url) { data, res, err in
            guard let data = data else { return }
            
            do{
                let notes = try JSONDecoder().decode([Note].self, from: data)
                self.notes =  notes
            }
            catch
            {
                print(error)
            }
            
        } 
        
        task.resume()
        if(self.isEditMode == .active)
        {
            self.isEditMode = .inactive
        }
        
    }
    
    func deleteNote()
    {
        guard let id = deleteItem?._id else {return}
    
        let url = URL(string: "http://localhost:3000/delete/\(id)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, res, err in
            guard err == nil else {return}
            guard let data = data else {return}
            
            do
            {
                _ = try JSONSerialization.jsonObject(with: data,options: .mutableContainers) as? [String:Any]
            }
            catch
            {
                print(error)
            }
            
        }
        task.resume()
        fetchNotes()
    }
    
}

struct Note:Identifiable,Codable {
    var id: String { _id }
    var _id:String
    var note:String
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
 
