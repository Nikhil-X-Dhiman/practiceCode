import { log } from "console";
import { AuthorsData, GamesData, ReviewsData } from "./schema.js";

interface GameArgs {
	name: string;
	price: number;
	platform: string[];
}

const getRandomID = () => {
	return Math.floor(Math.random() * 9999999);
};

export const resolvers = {
	Query: {
		games: () => GamesData,
		reviews: () => ReviewsData,
		authors: () => AuthorsData,
		gameByID: (_: unknown, args: { id: string }) =>
			GamesData.find((game) => game.id === parseInt(args.id)),
		reviewByID: (_: unknown, args: { id: string }) =>
			ReviewsData.find((review) => review.id === parseInt(args.id)),
		authorByID: (_: unknown, args: { id: string }) =>
			AuthorsData.find((author) => author.id === parseInt(args.id)),
	},
	Game: {
		review: (parent: { id: number }) =>
			ReviewsData.filter((review) => review.gameID === parent.id),
		author: (parent: { id: number }) => {
			const AuthorIDs = ReviewsData.filter(
				(review) => parent.id === review.gameID && review.authorID
			).map((review) => review.authorID);
			return AuthorsData.filter((author) => AuthorIDs.includes(author.id));
		},
	},
	Review: {
		author: (parent: { authorID: number }) =>
			AuthorsData.find((author) => author.id === parent.authorID),
		game: (parent: { gameID: number }) =>
			GamesData.find((game) => game.id === parent.gameID),
	},
	Author: {
		review: (parent: { id: number }) =>
			ReviewsData.filter((review) => review.authorID === parent.id),
		game: (parent: { id: number }) => {
			const GameIDs = ReviewsData.filter(
				(review) => review.authorID === parent.id
			).map((review) => review.gameID);
			return GamesData.filter((game) => GameIDs.includes(game.id));
		},
	},

	Mutation: {
		addGame: (_: unknown, args: { game: GameArgs }) => {
			const gameToAdd = { ...args.game, id: getRandomID() };
			GamesData.push(gameToAdd);
			return gameToAdd;
		},
		removeGame: (_: unknown, args: { id: string }) => {
			let GameID = parseInt(args.id);
			let gameToDeleteIndex = GamesData.findIndex((game) => game.id === GameID);
			let gameToDelete = GamesData[gameToDeleteIndex];
			GamesData.splice(gameToDeleteIndex, 1);
			return gameToDelete;
		},
		addReview: (
			// addition mutation is working on addgame...see that for changes to apply here
			_: unknown,
			args: {
				rating: number;
				content: string;
				gameID: number;
				authorID: number;
			}
		) => ReviewsData.push({ ...args, id: getRandomID() }),
		removeReview: (_: unknown, args: { id: number }) =>
			// not correct but remove game is correct
			ReviewsData.filter((review) => review.id !== args.id),
		addAuthor: (_: unknown, args: { name: string; verified: boolean }) =>
			// addition mutation is working on addgame...see that for changes to apply here
			AuthorsData.push({ ...args, id: getRandomID() }),
		removeAuthor: (_: unknown, args: { id: number }) =>
			// not correct but remove game is correct
			AuthorsData.filter((author) => author.id !== args.id),
	},
};
