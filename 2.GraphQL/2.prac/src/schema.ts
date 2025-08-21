export interface Game {
	id: number;
	name: string;
	price: number;
	platform: string[];
}

export interface Review {
	id: number;
	rating: number;
	content: string;
	gameID: number;
	authorID: number;
}

export interface Author {
	id: number;
	name: string;
	verified: boolean;
}

export let GamesData: Game[] = [
	{
		id: 1,
		name: "NFS Most Wanted",
		price: 850,
		platform: ["PC", "XBox", "Playstation", "Mobile"],
	},
	{
		id: 2,
		name: "Max Payne",
		price: 650,
		platform: ["PC", "XBox", "Playstation"],
	},
];

export let ReviewsData: Review[] = [
	{
		id: 1,
		rating: 5,
		content: "Best Game",
		gameID: 1,
		authorID: 2,
	},
	{
		id: 2,
		rating: 3,
		content: "Moderate Game",
		gameID: 2,
		authorID: 1,
	},
];

export let AuthorsData: Author[] = [
	{
		id: 1,
		name: "ABC",
		verified: false,
	},
	{
		id: 2,
		name: "XYZ",
		verified: true,
	},
];

export const typeDefs = `#graphql
  type Game {
    id: ID!
    name: String!
    price: Int!
    platform: [String!]
		review: [Review!]
		author: [Author!]
  }

  type Review {
    id: ID!
    rating: Int!
    content: String!
		author: Author
		game: Game
  }

  type Author {
    id: ID!
    name: String!
    verified: Boolean!
		review: [Review!]
		game: [Game!]
  }

  type Query {
    games: [Game!],
    reviews: [Review!],
    authors: [Author!],
    gameByID(id: ID!): Game,
    reviewByID(id: ID!): Review,
    authorByID(id: ID!): Author,
  }

	type Mutation {
		addGame(game: AddGameArgs!): Game,
    removeGame(id: ID!): Game,
    addReview(review: AddReviewArgs): Review,
    removeReview(id: ID!): Review,
    addAuthor(author: AddAuthorArgs): Author,
    removeAuthor(id: ID!): Author,
		updateGame(id: ID!, updates: UpdateGameArgs!): Game
	}
	input AddGameArgs {
		name: String!,
		price: Int!,
		platform: [String!],
	}
	input AddReviewArgs {
		rating: Int!,
		content: String!,
		gameID: Int!,
		authorID: Int!,
	}
	input AddAuthorArgs {
		name: String!,
		verified: Boolean!
	}
	input UpdateGameArgs {
		name: String,
		price: Int,
		platform: [String!],
	}
`;
