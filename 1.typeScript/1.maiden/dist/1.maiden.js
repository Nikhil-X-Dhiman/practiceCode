console.log("hello World");
let a = 100;
console.log(a);
while (a > 10) {
    a /= 10;
}
console.log(a);
function greetings(name) {
    console.log("Hello, ", name);
}
greetings("Nikhil");
let number = [1, 2, 3, 4];
number.forEach((n) => n.toFixed);
let tup = [1, "Nik"];
console.log(tup);
var Size;
(function (Size) {
    Size[Size["Small"] = 0] = "Small";
    Size[Size["Medium"] = 1] = "Medium";
    Size[Size["Large"] = 2] = "Large";
})(Size || (Size = {}));
let mySize = Size.Medium;
console.log(mySize);
function greet(firstName, lastName, middleName = " ") {
    return "Hello, " + firstName + middleName + lastName;
}
greet("Abc");
greet("Abc", "Xyz");
greet("Abc", "Xyz", " ");
let profile = {
    id: 1,
    name: "Nikhil Dhiman",
    age: 27,
    email: "nikhil@mail.in",
    adult: true,
    job: (date) => {
        console.log(date);
    },
};
console.log(profile.name.split(" "));
const e1 = {
    id: 1,
    name: "A",
    age: 4,
    email: "k@gmail.com",
    adult: true,
    job: (date) => {
        console.log(date);
    },
};
console.log(e1);
function kgToLbs(weight) {
    if (typeof weight === "string") {
        return parseInt(weight) * 2.2;
    }
    else {
        return weight * 2.2;
    }
}
kgToLbs(10);
kgToLbs("10Kg");
let textBox = { drag: () => { }, resize: () => { } };
console.log(textBox);
function greeet(name) {
    if (name) {
        console.log(name);
    }
    else {
        console.log("Invalid Name");
    }
}
greeet("ND");
greeet(null);
greeet(undefined);
function getCustomer(id) {
    return id === 0 ? null : { birthday: new Date() };
}
let customer = getCustomer(1);
console.log(customer === null || customer === void 0 ? void 0 : customer.birthday);
let speed = null;
speed = 0;
let ride = {
    speed: speed !== null && speed !== void 0 ? speed : 30,
};
console.log(ride);
function ab(text) {
    console.log(text);
}
ab("hello");
function ba(text) {
    if (typeof text === "string") {
        text.split("");
        text.replace("d", "d");
    }
}
ba("hello");
console.log("hi there");
class Account {
    constructor(id, owner, _balance) {
        this.id = id;
        this.owner = owner;
        this._balance = _balance;
    }
    deposit(amount) {
        if (amount <= 0) {
            throw new Error("Insufficient Amount");
        }
        this._balance += amount;
    }
    withraw(amount) {
        if (amount > this._balance) {
            throw new Error("Insufficient Balance");
        }
        else if (amount <= 0) {
            throw new Error("Invalid Amount");
        }
        this._balance -= amount;
    }
    getBalance() {
        return this._balance;
    }
    get balance() {
        return this._balance;
    }
    set balance(value) {
        if (value < 0) {
            throw new Error("Invalid Value");
        }
        this._balance = value;
    }
}
let account = new Account(1, "ND", 0);
account.deposit(1000);
account.withraw(500);
account.deposit(1500);
console.log(typeof account);
console.log(account instanceof Account);
const reportCard = {
    Math: 90,
    Science: 99,
};
console.log(reportCard);
class SeatAssignment {
}
let seats = new SeatAssignment();
seats.A1 = "ND";
seats["A2"] = "DD";
class Number {
    incr() {
        Number._value++;
    }
    decr() {
        Number._value--;
    }
    get value() {
        return Number._value;
    }
}
Number._value = 0;
let num1 = new Number();
num1.incr();
let num2 = new Number();
num2.incr();
class Person {
    constructor(firstName, lastName) {
        this.firstName = firstName;
        this.lastName = lastName;
    }
    get name() {
        return this.firstName + " " + this.lastName;
    }
    walk() {
        console.log("Walking");
    }
    sleep() {
        console.log("i am sleeping");
    }
}
class Student extends Person {
    constructor(studentID, firstName, lastName) {
        super(firstName, lastName);
        this.studentID = studentID;
    }
    takeTest() {
        console.log("Taking a test");
        this.sleep();
    }
}
class Teacher extends Person {
    constructor(teacherID, firstName, lastName) {
        super(firstName, lastName);
        this.teacherID = teacherID;
    }
    teaching() {
        console.log("Teacher is teaching");
        this.sleep();
    }
    get name() {
        return "Professor" + super.name;
    }
}
let s1 = new Student(1, "N", "D");
s1.walk();
s1.takeTest();
let t1 = new Teacher(1, "H", "D");
t1.walk();
t1.teaching();
class Animal {
    sound() {
        console.log("Animal Making Sound");
    }
}
class Dog extends Animal {
    sound() {
        console.log("woff");
    }
}
class Cat extends Animal {
    sound() {
        console.log("meoww");
    }
}
const arr = [new Dog(), new Cat()];
makeSound(arr);
function makeSound(animal) {
    for (let animalObj of animal) {
        animalObj.sound();
    }
}
class Shape {
    constructor(color) {
        this.color = color;
    }
}
class Circle extends Shape {
    constructor(radius, color) {
        super(color);
        this.radius = radius;
    }
    render() {
        console.log("Circle is Drawing");
    }
}
class Square extends Shape {
    constructor(side, color) {
        super(color);
        this.side = side;
    }
    render() {
        console.log("Square is Drawing");
    }
}
let circle = new Circle(5, "black");
circle.render();
let square = new Square(10, "slate");
square.render();
class GoogleCalender {
    constructor(name) {
        this.name = name;
    }
    sync() {
        throw new Error("Method not implemented.");
    }
    addEvent() {
        console.log("Adding an Event");
    }
    removeEvent() {
        throw new Error("Method not implemented.");
    }
}
let c1 = new GoogleCalender("ND");
c1.addEvent();
class KeyValuePair {
    constructor(key, value) {
        this.key = key;
        this.value = value;
    }
}
let pair1 = new KeyValuePair("1", "ABC");
console.log(pair1.key, pair1.value);
let pair2 = new KeyValuePair(2, "XYZ");
console.log(pair2.key, pair2.value);
let pair3 = new KeyValuePair(3, "MNO");
console.log(pair3.key, pair3.value);
export {};
//# sourceMappingURL=1.maiden.js.map