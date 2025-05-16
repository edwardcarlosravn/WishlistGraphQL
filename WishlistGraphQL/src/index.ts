import express from 'express';
import cors from 'cors';
import { createServer } from 'http';
import { ApolloServer } from '@apollo/server';
import { expressMiddleware } from '@apollo/server/express4';
import { ApolloServerPluginDrainHttpServer } from '@apollo/server/plugin/drainHttpServer';
import schema from './schema';
import { setupCsvExport } from './utils/csvExport'; // Add this import

const app = express();
app.use(express.json());
app.use(cors());
setupCsvExport(app);

const httpServer = createServer(app);

const server = new ApolloServer({
  schema,
  introspection: true,
  plugins: [ApolloServerPluginDrainHttpServer({ httpServer })]
});

async function startServer() {
  await server.start();
  
  app.use('/graphql', expressMiddleware(server));
  
  const PORT = process.env.PORT || 4000;
  httpServer.listen(
    { port: PORT },
    () => console.log(`WishlistGraphQL API running at http://localhost:${PORT}/graphql`)
  );
}

startServer();