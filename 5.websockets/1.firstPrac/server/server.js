import e from "express";

const app = e();
const PORT = 3000;

app.route("/").get((req, res) => {
	res.send("Hello World");
});

app.listen(PORT, () => {
	console.log("The PORT is open at ", PORT);
});
