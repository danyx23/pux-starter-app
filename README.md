# pux-starter-app

The [starter app](http://github.com/alexmingoia/pux-starter-app) is a pux
project configured with isomorphic rendering and routing, hot-reloading, and a


## PostgREST setup with docker

run the docker-compose file in ./server:

```bash
docker-compose -f ./server/docker-compose.yml up
```

This should bring up a postgres server and a postgREST server with a basic set of matching environment variables. The config is currently barebones, e.g. no persistent storage is configured etc.

To create the schema, copy the schema.psql file into the postgres container, then ingest it:

```bash
docker cp schema.psql server_db_1:/schema.psql
docker exec -it server_db_1 bash
# you should now be on a bash shell in the postgREST server
cat /schema.psql | gosu postgres psql
```

## Installation

Clone the repository and run `npm install` to get started:

```sh
git clone git://github.com/alexmingoia/pux-starter-app.git my-awesome-pux-app
cd my-awesome-pux-app
npm install
npm start
```

After compiling the app should be available at `http://localhost:3000`.

### Directory structure

- `src`: Application source code.
  - `src/App/Config.js`: Configuration values.
  - `src/App/Config.purs`: Configuration type.
  - `src/App/Events.purs`: Application event type and foldp function.
  - `src/App/Routes.purs`: Routes.
  - `src/App/State.purs`: Application state type and init function.
  - `src/App/View/HTMLWrapper.purs`: HTML document view.
  - `src/App/View/Homepage.purs`: Home page.
  - `src/App/View/Layout.purs`: App layout.
  - `src/App/View/NotFound.purs`: 404 page.
  - `src/Server.purs`: Server entry point.
  - `src/Client.purs`: Client entry point.
- `static`: Static files served with application.
- `support`: Support files for building.
  - `support/client.entry.js`: Webpack entry point. Handles hot reloading.
  - `support/server.entry.js`: Webpack entry point. Handles hot reloading.
- `bower.json`: Bower package configuration.
- `package.json`: Node package configuration.
- `webpack.config.client.js`: Webpack client configuration.
- `webpack.config.server.js`: Webpack server configuration.

### NPM scripts

#### watch

`npm start` or `npm run watch` will start a development server, which
hot-reloads your application when sources changes.

#### serve

`NODE_ENV=production npm run serve` builds your application and starts a
production server.

#### build

`npm run build` builds application client and server bundles.
