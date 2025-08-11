console.log("hello World");
let a: number = 100;
console.log(a);
while (a > 10) {
	a /= 10;
}
console.log(a);

// let bigNum: number = 473_947_593;
// let name: string = "Nikhil";
// let isOk: boolean = true;
// parameter explicit annotation
function greetings(name: string) {
	console.log("Hello, ", name);
}
greetings("Nikhil");

let number: number[] = [1, 2, 3, 4];
number.forEach((n) => n.toFixed);

// tuples
let tup: [number, string] = [1, "Nik"];
console.log(tup);

// enums
const enum Size {
	Small, // default value is 0 given by compiler, if given 1 then others becomes
	Medium, // default value is 1 it becomes 2
	Large, // default value is 2 it becomes 3
}
// enum Size {
// 	Small = "s",
// 	Medium = "m",
// 	Large = "l",
// }

let mySize: Size = Size.Medium;
console.log(mySize);

// function
function greet(
	firstName: string,
	lastName?: string, // never use optional but allowed
	middleName: string = " "
): string {
	return "Hello, " + firstName + middleName + lastName;
}
greet("Abc");
greet("Abc", "Xyz");
greet("Abc", "Xyz", " ");

// Object
let profile: {
	readonly id: number;
	name: string;
	age: number;
	email: string;
	adult?: boolean; // but never use optional but is allowed
	job: (date: Date) => void; // this function has 1 parameter & returns void
} = {
	id: 1,
	name: "Nikhil Dhiman",
	age: 27,
	email: "nikhil@mail.in",
	adult: true,
	job: (date: Date) => {
		console.log(date);
	},
};

console.log(profile.name.split(" "));

// type Alias (to simplify above like object annotation to follow DRY Principal)
type Employee = {
	id: number;
	name: string;
	age: number;
	email: string;
	adult: boolean;
	job: (date: Date) => void;
};

const e1: Employee = {
	id: 1,
	name: "A",
	age: 4,
	email: "k@gmail.com",
	adult: true,
	job: (date: Date) => {
		console.log(date);
	},
};
console.log(e1);

// UNIONS
function kgToLbs(weight: number | string): number {
	if (typeof weight === "string") {
		return parseInt(weight) * 2.2;
	} else {
		return weight * 2.2;
	}
}
kgToLbs(10);
kgToLbs("10Kg");

// Intersection
type Dragable = {
	drag: () => void;
};
type Resizable = {
	resize: () => void;
};
type UIWidget = Dragable & Resizable;
let textBox: UIWidget = { drag: () => {}, resize: () => {} };
console.log(textBox);

// Literal Type (exact value)
// let num: 10 = 10; // it can't be other than 10
// type Allowed = 10 | 20; // using union with it
// let num1: Allowed = 20;

// Nullable Types
function greeet(name: string | null | undefined): void {
	if (name) {
		console.log(name);
	} else {
		console.log("Invalid Name");
	}
}
greeet("ND");
greeet(null);
greeet(undefined);

// Optional Chaining
type Customer = {
	birthday: Date;
};

function getCustomer(id: number): Customer | null | undefined {
	return id === 0 ? null : { birthday: new Date() };
}

let customer = getCustomer(1);
console.log(customer?.birthday);

// Nullish Coalescing Operator
let speed: number | null = null;
speed = 0;
let ride = {
	// speed: speed || 30, // not correct as 0 is also considered false value
	speed: speed ?? 30,
};
console.log(ride);

// Type Asssertions (when we know the type of object better than tsc)
// let phone = document.getElementById("phone"); // this returns HTMLElement which is a super class of elements but we know that what we want is a sub class of the element, here an input element which will have a value option which this super class does not have, So

// let phone1 = document.getElementById("phone") as HTMLInputElement;
// let phone2 = <HTMLInputElement>document.getElementById("phone"); // can also be written as this
// it enables you to do this...like getting input values

// console.log(phone.value); //Not available here..
// console.log(phone1.value); // available here same for phone2
// console.log(phone2.value); // available here

// any Type for unknown types if we were converting JavaScript code but never use it in new TS codebase
function ab(text: any): void {
	console.log(text);

	// text.hello();
	// text.bye();
	// as the text is any it allows us to call anything on the variable which is bad
}
ab("hello");
function ba(text: unknown): void {
	// text.hello(); // here it throws us error & won't allow us to use any function
	// we have to use narrowing to use the functions on the arguments
	if (typeof text === "string") {
		text.split("");
		text.replace("d", "d");
		// in this block we have access to all the string functions
	}
	// so unknown forces us to see the type of the argument for less errors
}
ba("hello");
// never type - less used but it tells that the function will not return anything...so the next code becomes un-rechable as the function is returning void without never keyword, writing never will tell the compiler of this & will show an error
// function reject(error: string){
// function reject(error: string): never {
// 	throw new Error(error);
// }

// reject("Something Went Wrong");
console.log("hi there");

// *************** CLASES (OOPS) ****************** //
// Intro to Clases, properties, methods, constructors, this, optional properties, readOnly, access controls: public (default), private & protected
class Account {
	// readonly id: number;
	// owner: string;
	// private _balance: number; // so no one can change the value directly from object but required them to go through methods & also prefix with "_" for private...only Account Class methods can access this propery & can't be accessed outside of this class
	nickname?: string; // optional property if any owner of account want to have
	// constructor(id: number, owner: string, balance: number) {
	// 	this.id = id;
	// 	this.owner = owner;
	// 	this._balance = balance;
	// }
	// Parameter Properties - this tell the compiler to create the properties & assign valies in one go making the code shorter
	constructor(
		public readonly id: number,
		public owner: string,
		private _balance: number
	) {}
	// methods
	deposit(amount: number): void {
		if (amount <= 0) {
			throw new Error("Insufficient Amount");
		}
		// Record a transaction
		this._balance += amount;
	}

	withraw(amount: number): void {
		if (amount > this._balance) {
			throw new Error("Insufficient Balance");
		} else if (amount <= 0) {
			throw new Error("Invalid Amount");
		}
		// Record a transaction
		this._balance -= amount;
	}
	// private calculateTax(): void {
	// 	console.log("abc");
	// }
	getBalance(): number {
		//due to private access modifies this is used to get access to the private property. But this is actually a method that need to be called as object.getBalance() but if we want previous behaviour like object.balance we use getter & setter for those things
		return this._balance;
	}
	// Getter
	get balance(): number {
		return this._balance;
	}
	// Setter - but here setting a balance is not what's required
	set balance(value: number) {
		if (value < 0) {
			throw new Error("Invalid Value");
		}
		this._balance = value;
	}
}

// creating an object, typeof, instanceof

let account = new Account(1, "ND", 0);
account.deposit(1000);
account.withraw(500);
account.deposit(1500);
console.log(typeof account); // this equals "object"
console.log(account instanceof Account); // this equals true

// Index Signature Property - create object property dynamically as TS does not allow for dynamic property creation
type Marks = {
	[key: string]: number; // str = "ND" && this means that it expects all the properties to have name string and value to be number
};
const reportCard: Marks = {
	Math: 90,
	Science: 99,
};
console.log(reportCard);

// but now you can't have property name to be number to do that you need to do is let property accept both string & number value
// type Marks = {
// 	fixed: number;  // in above ex. this would throw an error
// 	[key: string]: string | number; // but now the value can be string & number both...this makes the above property pass the test
// };
// Index Signature used in Class
class SeatAssignment {
	// assign seats & keep track of the customers
	// A1, A2, A3, ....
	[seatName: string]: string;
}

let seats = new SeatAssignment();
seats.A1 = "ND";
seats["A2"] = "DD";

// Static - A property that belongs to the class not the object, means every object will share the value of static property, otherwise every object of class has their own unique memory of the property..they don't share the values among one another...in static we now will be able to call the property or method withour any object, but just by class name

class Number {
	// value: number = 0;
	private static _value: number = 0;
	incr(): void {
		// this.value++;
		Number._value++;
	}
	decr(): void {
		Number._value--;
	}
	get value(): number {
		return Number._value;
	}
}

let num1 = new Number();
num1.incr(); // if not static number => 1
let num2 = new Number();
num2.incr(); // if not static number still => 1
// if we want to access number as it tracks for every object created prefix it with static
// after making it static, it has one flaw that now anybody can change the value of static value making more bugs like
// Number.value = 0; // this is not good, so we will make it private so this does not happen
// also make getter to get the value but not set it from the outside of class...not after private this will throw an error

// Inheritance
// Method Overriding: Implement the get name() to prefix "Professor" for Teacher Class
// Protected: this access modifies works exactly like private but the difference is it can be inherited by subclasses, just like private the objects can't access it
class Person {
	constructor(public firstName: string, public lastName: string) {}
	get name(): string {
		return this.firstName + " " + this.lastName;
	}
	walk(): void {
		console.log("Walking");
	}
	protected sleep(): void {
		console.log("i am sleeping");
	}
}

class Student extends Person {
	constructor(public studentID: number, firstName: string, lastName: string) {
		super(firstName, lastName);
	}
	takeTest(): void {
		console.log("Taking a test");
		this.sleep(); // calling protected method
	}
}

class Teacher extends Person {
	constructor(public teacherID: number, firstName: string, lastName: string) {
		super(firstName, lastName);
	} // constructor can be skipped if not new property has to be made like teacherID...so this class will inherit exactly the Person constructor
	teaching(): void {
		console.log("Teacher is teaching");
		this.sleep();
	}
	override get name(): string {
		return "Professor" + super.name;
	}
}

let s1 = new Student(1, "N", "D");
s1.walk();
s1.takeTest();

let t1 = new Teacher(1, "H", "D");
t1.walk();
t1.teaching();

// Polymorphism ----------------------------
class Animal {
	sound(): void {
		console.log("Animal Making Sound");
	}
}
class Dog extends Animal {
	override sound(): void {
		console.log("woff");
	}
}
class Cat extends Animal {
	override sound(): void {
		console.log("meoww");
	}
}
const arr: Animal[] = [new Dog(), new Cat()];

makeSound(arr);
function makeSound(animal: Animal[]): void {
	for (let animalObj of animal) {
		animalObj.sound();
	}
}

// Abstract Class : means incomplete class & we have to block the creation of the object of this incomplete class therefore we prefix the class with abstract & the function that are incomplete are too prefixed with abstract keyword.

abstract class Shape {
	constructor(public color: string) {}

	abstract render(): void;
}

class Circle extends Shape {
	constructor(public radius: number, color: string) {
		super(color);
	}
	override render(): void {
		console.log("Circle is Drawing");
	}
}

class Square extends Shape {
	constructor(public side: number, color: string) {
		super(color);
	}
	override render(): void {
		console.log("Square is Drawing");
	}
}

// const shape = new Shape("red");	// we cannot nake object of the abstract class like this & prevent a bug
// shape.render();
let circle = new Circle(5, "black");
circle.render();
let square = new Square(10, "slate");
square.render();

// Interface -----------------
// it is similar to abstract & type in some way...it cannot have any login in it...it is not extend by class but is implements by class...
// this Calender class can also be implemented by Abstract but interface is minimal to write & also if this class has any login in it then we will use abstract class as interface can't have method defination
interface Calender {
	name: string;
	addEvent(): void;
	removeEvent(): void;
}

interface CloudCalender extends Calender {
	sync(): void;
}

class GoogleCalender implements CloudCalender {
	// name: string;
	// constructor(name: string){
	// 	this.name = name;
	// }
	constructor(public name: string) {}
	sync(): void {
		throw new Error("Method not implemented.");
	}
	addEvent(): void {
		// throw new Error("Method not implemented.");
		console.log("Adding an Event");
	}
	removeEvent(): void {
		throw new Error("Method not implemented.");
	}
}

let c1 = new GoogleCalender("ND");
c1.addEvent();
