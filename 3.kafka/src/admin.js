import { Kafka } from "kafkajs";

// Instance of kafka & pointed to atleast one kafta broker
const kafka = new Kafka({
	clientId: "keyRing",
	brokers: ["localhost:9092"],
});
const admin = kafka.admin();

await admin.connect();

await admin.createTopics({
	topics: [
		{
			topic: "person-name",
			numPartitions: 2,
		},
	],
});

const topics = await admin.listTopics();
console.log("Admin: ", topics);

await admin.disconnect();
