import { Kafka } from "kafkajs";
const group = process.argv[2];

// Instance of kafka & pointed to atleast one kafta broker
const kafka = new Kafka({
	clientId: "keyRing",
	brokers: ["localhost:9092"],
});

console.log("Consumer: Started");

const consumer = kafka.consumer({ groupId: group });

await consumer.connect();
console.log("Consumer: Connected");
await consumer.subscribe({ topic: "person-name", fromBeginning: true });
console.log("Consumer: Subscribed");
await consumer.run({
	eachMessage: async ({ topic, partition, message }) => {
		console.log({
			value: JSON.parse(message.value.toString()),
		});
	},
});
console.log("Consumer: Ended");
