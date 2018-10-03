import UIKit

// sintaxis normal
var operacion: (Int, Int) -> Int

operacion = { (a:Int, b:Int) in return a + b }

let suma = operacion(1,2)

// como es variable se puede cambiar

operacion = { a,b in return a * b }

operacion = { a,b in
	let suma = a + b
	return suma
}

operacion = { a,b in a * 2 * b }

operacion(2,5)

operacion = { $0 + 2 * $1 }

operacion(1,6)

// Typealias

typealias IntToInt = (Int)->Int

typealias Longitude = Float

func getDistance(from longitude: Longitude) {
	_ = longitude * 2
}

func adder(n: Int) -> IntToInt {
	func foo(x:Int) -> Int {
		return x + n
	}
	return foo
}

let g = adder(n: 57)
g(4)

func apply(f: IntToInt, n: Int) -> Int {
	return f(n)
}

apply(f: g, n: 99)

// sintaxis de clausuras
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

funciones.forEach({ dump($0(42))})

let clausuras = [f,
				 {(n: Int) in return n+1},
				 {n in return n*3 },
				 {n in n * 6},
				 {$0 + 99}
]

//sintaxis ultra-minimalista, se usa mucho en Swift, especialmente como clausuras de finalización, (callbacks)

let evens = [6,12,2,8,4,10]

let result1 = evens.sorted(by: {(a:Int, b: Int) in a > b})
print(result1)

let result2 = evens.sorted { (a, b) in
	return (a>b)
}
print(result2)

let result3 = evens.sorted { $0 > $1 }
print(result3)

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
