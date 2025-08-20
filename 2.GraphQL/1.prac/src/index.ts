import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";

interface BookArgs {
	title: string;
}

interface AuthorArgs {
	name: string;
}

interface Book {
	title: string;
	price: number;
	author: string;
}

let bookData = [
	{
		title: "The Awakening",
		price: 400,
		author: "Kate Chopin",
	},
	{
		title: "City of Glass",
		price: 300,
		author: "Paul Auster",
	},
];

let authorData = [
	{ name: "Kate Chopin", age: 30, books: ["The Awakening"] },
	{ name: "Paul Auster", age: 34, books: ["City of Glass"] },
];

const typeDefs = `#graphql
  # Adding "#graphql apparently gives you syntax highlighting"
  type Book {
    title: String!
    price: Int!
    author: Author!
  }
  type Author {
    name: String!
    age: Int!
    books: [Book!]
  }
  # All the available queries are defined here with their return types
  type Query {
    # here, it means books query returns an array of 0 or more Books
    fetchBooks: [Book]
    fetchBook(title: String): Book!
    fetchAuthors: [Author]
    fetchAuthor(name: String) : Author!
  },
	type Mutation {
		deleteBook(title: String!): [Book!]
		addBook(book: AddBookArgs!): Book!
	},
	input AddBookArgs {
		title: String!
		price: Int!
		author: String!
	}
`;

// Resolvers define how to fetch the types defined in your schema.
// This resolver retrieves books from the "books" array above.
const resolvers = {
	Query: {
		fetchBooks: () => bookData,
		fetchBook: (_: unknown, args: BookArgs) =>
			bookData.find((book) => book.title === args.title),
		fetchAuthors: () => authorData,
		fetchAuthor: (_: unknown, args: AuthorArgs) =>
			authorData.find((author) => author.name === args.name),
	},
	Book: {
		author: (parent: { author: string }) =>
			authorData.find((author) => parent.author === author.name),
	},
	Author: {
		books: (parent: { books: string[] }) =>
			bookData.filter((book) => parent.books.includes(book.title)),
	},
	Mutation: {
		deleteBook: (_: unknown, args: { title: string }) => {
			bookData = bookData.filter((book) => book.title !== args.title);
			return bookData;
		},
		addBook: (_: unknown, args: { book: Book }) => {
			bookData.push(args.book);
			return args.book;
		},
	},
};

const server = new ApolloServer({ typeDefs, resolvers });

// Passing an ApolloServer instance to the `startStandaloneServer` function:
//  1. creates an Express app
//  2. installs your ApolloServer instance as middleware
//  3. prepares your app to handle incoming requests

const { url } = await startStandaloneServer(server, {
	listen: { port: 4000 },
});

console.log("Server is listening at ", url);
