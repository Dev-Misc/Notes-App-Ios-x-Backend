//
//  UpdateNoteView.swift
//  Notes
//
//  Created by Dev Adnani on 20/12/22.
//

import SwiftUI

struct UpdateNoteView: View {
    
    @Binding var note:String
    @Binding var noteID:String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack{
            TextField("Edit A Note",text: $note)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .clipped()
            Button(action: editNote, label: {
                Text("Edit")
            }).padding(8)
        }
        
    }
    
    func editNote()
    {
        let params = ["note":note] as [String:Any]
        let url = URL(string: "http://localhost:3000/notes/\(noteID)")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "PATCH"
        do
        {
            request.httpBody = try JSONSerialization.data(withJSONObject: params,options: .prettyPrinted)
        }
        catch let error
        {
            print(error)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with:request) { data, res, err in
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
        
        self.note = ""
        presentationMode.wrappedValue.dismiss()
    }
}

