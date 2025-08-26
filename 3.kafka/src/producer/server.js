import { Kafka } from "kafkajs";
import readline from "readline";

const rl = readline.createInterface({
	input: process.stdin,
	output: process.stdout,
});
// Instance of kafka & pointed to atleast one kafta broker
const kafka = new Kafka({
	clientId: "keyRing",
	brokers: ["localhost:9092"],
});
const producer = kafka.producer();

await producer.connect();
console.log("Producer: Connected");

rl.setPrompt("> ");
rl.prompt();
rl.on("line", async (line) => {
	const [name, location] = line.split(" ");
	await producer.send({
		topic: "person-name",
		messages: [
			{
				value: JSON.stringify({ id: 1, name }),
				partition: location.toLocaleLowerCase() === "north" ? 0 : 1,
			},
		],
	});
	console.log("Producer: Event Msg sent");
}).on("close", async () => {
	await producer.disconnect();
});
