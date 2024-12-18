//
//  HomeViewController.swift
//  Tema10Example1
//

import UIKit //importamos la UI
import FirebaseAuth //importamos a Firebase para autenticarnos
import Firebase //importamos a Firebase para la base de datos fire store

//clase padre
class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    //componentes de la UI
    @IBOutlet weak var nameTextField: UITextField! //nombre
    @IBOutlet weak var phoneTextField: UITextField! //celular
    @IBOutlet weak var userTableView: UITableView! //tabla de registro de usuarios
    
    //variables
    var ref: DocumentReference? //lo que viene del firebase
    var getRef: Firestore? //para llamar al firestore de la base de datos
    var userData = [User]() //arreglo de tipo user para mostrar a las personas
    
    //carga en memoria
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView() //llamamos a la función para configurar la tabla
        getUser() //llamamos a la función para obtener al usuario con una sesión abierta
        getRef = Firestore.firestore() //instanciamos a firestore. Si o si debe de hacerse eso para poder hacer uso de esta variable
        getUserFirebase() //llamamos a la función para obtener los datos de firebase
    }
    
    //función para configurar la tabla
    func configureTableView() {
        userTableView.delegate = self //delegado
        userTableView.dataSource = self //dataSource
        userTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell") //registramos el nombre de la celda en la tabla
        userTableView.rowHeight = 130 //tamaño de la celda
        userTableView.showsVerticalScrollIndicator = false //esconder la barra del scroll vertical
        userTableView.separatorStyle = .none //hacemos un separador
    }
    
    //función para crear una alerta
    func configureAlert() {
        //creamos una alerta simple pasandole título y mensajes
        let alertController = UIAlertController(title: "Mensaje de error", message: "Debes ingresar datos en los campos", preferredStyle: .alert)
        //agregamos los botones a la alerta
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        //presentamos la alerta
        self.present(alertController, animated: true, completion: nil)
    }
    
    //función para obtener al usuario con una sesión abierta
    func getUser() {
        let _ = Auth.auth().currentUser?.email //librería para hacer el llamado si hay una sesión abierta
    }
    
    //función para registrar al cliente
    func registerClient() {
        let name = nameTextField.text ?? "" //le pasamos el nombre que escribimos a la varialbe nombre
        let phone = phoneTextField.text ?? "" //le pasamos el celular que escribimos a la varialbe celular
        let fields: [String: Any] = ["name": name, "phone": phone] //llamamos a los campos nombre y celular para poder ser enviados a la base de datos de firebase
        if name.count > 0 && phone.count > 0 { //validamos que tenga si o si datos los campos de texto nombre y celular
            ref = getRef?.collection("users").addDocument(data: fields, completion: { (error) in //llamamos a la base de datos de firebase
                if let error = error?.localizedDescription { //si es que hay error
                    print("Error de firebase al guardar: \(error)") //imprimimos el error
                } else {
                    self.updateUserData(name: name, phone: phone) //llamamos a la función para poder actualizar los datos y le pasamos el nombre y celular
                    print("Se guardó correctamente") //imprimos el guardado por consola
                }
            })
            clearTextField() //llamamos a al función de limpiar campos
        } else {
            configureAlert() //llamamos a la función de alerta
        }
        
    }
    
    //función para limpiar los campos
    func clearTextField() {
        nameTextField.text = "" //nombre
        phoneTextField.text = "" //celular
        nameTextField.becomeFirstResponder() //focus al campo nombre
    }
    
    //función para poder actualizar al usuario e insertar en el arreglo de usuarios y actualizar la tabla
    //le pasamos 3 parámteros: uno que sea del nombre, otro del celular y el otro puede que contenga o no el id (no registraremos el id, firebase ya lo hace por nosotros. El id del usuario lo vamos a obtener del mismo firebase)
    func updateUserData(name: String, phone: String, id: String? = nil) {
        //en el hilo principal de la aplicación
        DispatchQueue.main.async {
            let users = User(name: name, phone: phone, id: id) //llamamos a la clase User y le pasamos sus 3 parámetros
            self.userData.insert(users, at: 0) //insertamos al usuario en el arreglo de usuario en posición 0
            self.userTableView.reloadData() //actualizamos la tabla de registro de usuarios
        }
    }
    
    //función para cerrar sesión en firebase
    func logOut() {
        try? Auth.auth().signOut() //llamar a la librería para hacer el logOut
        self.dismiss(animated: true, completion: nil) //hacemos un retorno a la vista anterior
    }
    
    //función para obtener los datos del usuario en firebase
    func getUserFirebase() {
        getRef?.collection("users").getDocuments { (querySnapshot, error) in //llamamos a la base de datos que se ha creado en firebase
            if let error = error { //si se presenta algún error
                print("hubo un error al traer los datos: \(error)") //si se presenta algún error
            } else {
                self.userData.removeAll() //removemos al usuario repetido
                guard let query = querySnapshot else { return } //opcional del querySnapshot
                for document in query.documents { //recorremos los documentos que hay en base de datos
                    let id = document.documentID //obtenemos el id del usuario
                    let valueDocument = document.data() //obtenemos la data del usuario para ser llamada
                    let name = valueDocument["name"] as? String ?? "" //obtenemos el nombre del usuario de la base de datos de firebase y le pasamos a la variable nombre
                    let phone = valueDocument["phone"] as? String ?? "" //obtenemos el celular del usuario de la base de datos de firebase y le pasamos a la variable celular
                    self.updateUserData(name: name, phone: phone, id: id) //llamamos a la función para poder actualizar la información y le pasamos el nombre y celular
                }
            }}
    }
    
    // UITableViewDelegate - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        //retornamos uno porque solo hay un table view
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //retornamos la cantidad del arreglo de la lista
        return userData.count
    }
    
    //para eliminar los datos de una lista
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { //validamos que sea el de eliminar
            let user: User //llamamos a la clase User
            user = self.userData[indexPath.row] //pasamos lo que hay en el arreglo de la lista
            let id = user.id ?? "" //obtenemos el id
            self.getRef?.collection("users").document(id).delete() //eliminamos de la base de datos pasandole el id del usuario
        }
        reloadData() //llamamos a la función para actualizar los datos de la tabla
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //llamamos a la celda
        let cell = userTableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell
        let user: User //llamamos a la clase User
        user = userData[indexPath.row] //pasamos lo que hay en el arreglo de la lista
        cell?.nameLabel.text = "Nombre: \(user.name ?? "") 🙌" //le pasamos el nombre
        cell?.phoneLabel.text = "Email: \(user.phone ?? "") 🧑🏻‍💻" //le pasamos el celular
        cell?.selectionStyle = .none //ningún estilo
        return cell ?? UITableViewCell() //retornamos la celda
    }
    
    //para seleccionar una celda
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "update", sender: self) //le pasamos el segue con el identificador "update"
    }
    
    //creamos a la función del segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "update" { //le pasamos su identificador "update"
            if let id = userTableView.indexPathForSelectedRow { //seleccionamos el id de la celda seleccionada
                let selectedUser = userData[id.row] //le pasamos el id de la celda a la variable selectedUser
                let router = segue.destination as? UpdateUserViewController //para poder navegamos al destino UpdateUserViewController
                router?.delegate = self //llamamos a la variable delegado del protocolo creado en dicha clase
                router?.updateUser = selectedUser //le pasamos el id de usuario a la vista UpdateUserViewController para que pueda ser editado siempre y cuando el usuario desea hacerlo
            }
        }
    }
    
    //acciones
    //acción para registrar usuarios
    @IBAction func didTapRegister(_ sender: UIButton) {
        registerClient() //llamamos a la función para registrar usuario
    }
    
    //acción para cerrar sesión
    @IBAction func didTapClose(_ sender: UIButton) {
        logOut() //llamamos a la función para cerrar sesión de firebase
    }
}

//extendemos al protocolo que habiamos creado anteriormente y llamamos a su función para poder ser implementada cuando actualizamos los datos
extension HomeViewController: UpdateUserViewControllerDelegate {
    //llamamos a la función
    func reloadData() {
        self.getUserFirebase() //obtenemos otra ves la información de los datos que viene de firebase
        self.userTableView.reloadData() //actualizamos la tabla de registro de usuarios
    }
}
