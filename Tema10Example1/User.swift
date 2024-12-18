//
//  User.swift
//  Tema10Example1
//
//clase User que se va a mostrar en la base de datos de firebase
class User {
    let name: String? //nombre
    let phone: String? //celular
    let id: String? //id
    
    //inicializador
    init(name: String?, phone: String?, id: String?) {
        self.name = name //le pasamos el nombre
        self.phone = phone //le pasamos el celular
        self.id = id //le pasamos el id
    }
}
