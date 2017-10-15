module App.Events where

import Prelude
import App.Routes (Route)
import App.State (State(..))
import Data.Maybe
import Data.Function (($))
import Network.HTTP.Affjax (AJAX)
import Pux (EffModel, noEffects)
import Control.Monad.Aff.Console (log, CONSOLE)

data Event
  = PageView Route
  | ShowSecret

type AppEffects fx = (ajax :: AJAX, console :: CONSOLE | fx)

foldp :: ∀ fx. Event -> State -> EffModel State Event (AppEffects fx)
foldp (PageView route) (State st) = noEffects $ State st { route = route, loaded = true }
foldp (ShowSecret) (State st) = { state: State st { title = "Secret title!"},
                                  effects: [ log "Secret button clicked" *> pure Nothing ]
                                }
