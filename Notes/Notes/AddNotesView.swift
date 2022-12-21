//
//  AddNotesView.swift
//  Notes
//
//  Created by Dev Adnani on 20/12/22.
//

import SwiftUI

struct AddNotesView: View {
    
    @State var text = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack{
            TextField("Write A Note",text: $text)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .clipped()
            Button(action: addNotes, label: {
                Text("Add")
            }).padding(8)
        }
    }
    
    func addNotes()
    {
        let params = ["note":text] as [String:Any]
        let url = URL(string: "http://localhost:3000/notes")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
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
        
        self.text = ""
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddNotesView_Previews: PreviewProvider {
    static var previews: some View {
        AddNotesView()
    }
}
