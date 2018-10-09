import UIKit

// normal syntax
var operacion: (Int, Int) -> Int

operacion = { (a:Int, b:Int) in return a + b }

let suma = operacion(1,2)

// sin inferencia
operacion = { (a: Int,b: Int) in return a * b }

// Swift deduce tipos: inferencia de tipos, linea 4
operacion = { a,b in return a * b }

// cmd + option [ ] move
operacion = { a,b in
    let suma = a + b
    return suma
}

// cuando un closure tiene una unica linea de codigo, podemos eliminar el estamento "return"
operacion = { a,b in a * 2 * b }

operacion(2,5)

// Swift ofrece una wildcard para utilizar como argumento
// usando el caracter dolar, y enumerandolos de 0 en adelante, estos son:
// $0, $1, $2, ... NESTED (anidadas)
// Swift interpretara $0 como el primer argumento de nuestro closure (como "a") y $1
// como el segundo (como "b"(, de esta forma nos ahorramos los argumentos y de regalo el "in",
// quedando la closure como:
operacion = { $0 + 2 * $1 }

operacion(1,6)

// Typealias: añadimos un alias al tipo primitivo
//
typealias IntToInt = (Int)->Int

typealias Longitude = Float

// parametro y parametro interno

// NO
//func getDistance(from: Longitude) {
//    _ = from * 2
//}

// SI
func getDistance(from longitude: Longitude) {
	_ = longitude * 2
}

// funcion interna de primer orden (funcion dentro otra fucnion)
// evitar funciones chiquititas dentro de una clase, utilizar dentro de la funcion que la usa
func adder(n: Int) -> IntToInt {
	func foo(x:Int) -> Int {
		return x + n
	}
	return foo
}

let g = adder(n: 57)
g(4)

// parametro entrada, (closure, Int)
func apply(f: IntToInt, n: Int) -> Int {
	return f(n)
}

apply(f: g, n: 99)

// clousure sintaxi
func f(_ n: Int) -> Int {
	return n + 1
}

// es 100% equivalente a
let f1 = { (n: Int) in  return n + 1 }

f(8)
f1(8)

// las funciones al ser tipos como cualquier otro, se pueden
//meter en colecciones

let funciones = [f,f1,g]

for fn in funciones {
	dump(fn(42))
}

// ventaja: rapido, no crea variable intermedia desventaja: pero no lo puedes parar
funciones.forEach({ dump($0(42))})

let clausuras = [f, // los tipos infieren
				 {(n: Int) in return n+1},
				 {n in return n*3 },
				 {n in n * 6},
				 {$0 + 99}
]
//sintaxis ultra-minimalista, se usa mucho en Swift, especialmente como clausuras de finalización, (callbacks)

// cuando el parametro termina siendo un clousure se le llama trailing-clousure (clausura cola)
//let ejemplo = operateTwoInts(a:2,b:6, operation: {$0,$1})

// podemos expresarlo tambien como: (mas corto)
//let result = operateTwoInts(a:2,b:6) {$0,$1}



// CLOUSURES ? ->mbloques en obj c
// argumento de funciones y metodos
// hay metodos que nos preguntan a traves de clousure
// Como lo hago: sort, filter
// Que hacer con: He descargado todo esto, que hago con el?
// otros dicen: Ya he acabado, hago algo mas?
//(estos le dan el nombre)

//sintaxis ultra-minimalista, se usa mucho en Swift, especialmente como clausuras de finalización, (callbacks)
let evens = [6,12,2,8,4,10]
// ciclo de retencion de codigo (cuidado con clousures)
                                // clousure
let result1 = evens.sorted(by: {(a:Int, b: Int) in a > b})
print(result1)
                            // trailing clousure (unique)
let result2 = evens.sorted { (a, b) in
	return (a>b)
}
print(result2)

let result3 = evens.sorted { $0 > $1 }
print(result3)

// Closure are ARC Objects, or just objects

// ARC RULES
// Struct y Enum son "value types", son tipos que se pasan por valores, cada vez que
// pasamos una variable Struct a una funcion esta crea su propia copia de valor. Cuando la
// funcion termina la copia del valor es eliminada

// Class es "reference type", se pasa por referencia, cada vez que pasamos una variable
// Class a una funcion esta crea una referencia que apunta a dicha clase. ARC cuenta
// automaticamente cuantas referencias estan apuntando a una variable tipo Class, cuando no
// hay ninguna, elimina la variable Class (el objeto)

// ARC Y la lista de captura
// referencia weak. lo resolveremos de forma analoga, usando la lista de captura
// (evitar memory leaks)
// la lista de captura tambien no servira para definir como queremos capturar las "value types"

// Genericos

func sum(a: Int, b: Int) -> Int { return a + b }

sum(a: 1, b: 2)

func sum(a: Double, b: Double) -> Double { return a + b }
sum(a: 1.1, b: 2.1)

protocol Summable {
	static func +(lhs: Self, rhs: Self) -> Self
}

extension Int: Summable {}
extension Double: Summable {}

func suma<T:Summable>(a:T, b:T) -> T { return a + b }

suma(a:1,b:1)
suma(a:2.1,b:2.1)

protocol Human {
	var name: String { get }
}

struct Teacher: Human {
	var name: String
}

struct Student: Human {
	var name: String
}

let student1 = Student(name: "Carlos")
let student2 = Student(name: "Jose")

let teacher = Teacher(name: "Charles")

struct StudentList {
	var students: [Student]
	mutating func add(student: Student) {
		students.append(student)
	}
}

var studentList1 = StudentList(students: [student1])
studentList1.add(student: student2)
print(studentList1)

struct TeacherList {
	var teachers: [Teacher]
	mutating func add(teacher: Teacher) {
		teachers.append(teacher)
	}
}

struct PeopleList<T> {
	var people: [T]
	mutating func add(person: T) {
		people.append(person)
	}
}

var studentList2 = PeopleList<Student>(people: [student1])
studentList2.add(person: student2)
print(studentList2)

var teacherList = PeopleList<Teacher>(people: [])

teacherList.add(person: teacher)
