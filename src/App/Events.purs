module App.Events where

import Data.Maybe
import Prelude

import App.Routes (Route)
import App.State (State(..), Movie(..))
import Control.Monad.Aff (attempt)
import Control.Monad.Aff.Console (log, CONSOLE)
import Data.Argonaut (decodeJson, class DecodeJson, (.?))
import Data.Either (Either(..), either)
import Data.Function (($))
import Data.List (List)
import Data.Show (show)
import Network.HTTP.Affjax (AJAX, get)
import Pux (EffModel, noEffects)

data Event
  = PageView Route
  | RequestMovies
  | ReceiveMovies (Either String Movies)
  | ShowSecret

type AppEffects fx = (ajax :: AJAX, console :: CONSOLE | fx)

type Movies = Array Movie

foldp :: ∀ fx. Event -> State -> EffModel State Event (AppEffects fx)
foldp (PageView route) (State st) = noEffects $ State st { route = route, loaded = true }
foldp (ShowSecret) (State st) = {
  state: State st { title = "Secret title!"},
  effects: [ log "Secret button clicked" *> pure Nothing ]
  }
-- https://github.com/alexmingoia/purescript-pux/blob/master/examples/ajax/Todos.purhttps://github.com/alexmingoia/purescript-pux/blob/master/examples/ajax/Todos.purss
foldp (RequestMovies) (State st) =
  {
    state: State st,
    effects: [ do
                  res <- attempt $ get "http://localhost:4000/movie"
                  let decode r = decodeJson r.response :: Either String Movies
                  let movies = either (Left <<< show) decode res
                  pure $ Just $ ReceiveMovies movies
      ]
  }
foldp (ReceiveMovies (Right movies)) (State state) = {
  state: State state { movies = movies }
  , effects: []
  -- , effects: [ log (show movies) *> pure Nothing ]
  }
foldp (ReceiveMovies (Left err)) (State state) = {
  state: State state,
  effects: [ log ("error: " <> err) *> pure Nothing ]
  }

-- TODO: errors on isomorphic branch
