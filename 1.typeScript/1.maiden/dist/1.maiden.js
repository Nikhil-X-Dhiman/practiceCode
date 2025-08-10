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
export {};
//# sourceMappingURL=1.maiden.js.map