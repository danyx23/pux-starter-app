module App.Events where

import Prelude
import App.Routes (Route)
import App.State (State(..)) 
import Data.Maybe
import Data.Function (($))
import Network.HTTP.Affjax (AJAX, get, AffjaxResponse)
import Pux (EffModel, noEffects)
import Control.Monad.Aff.Console (log, CONSOLE)
import Control.Monad.Aff (attempt) 
import Control.Monad.Except(runExcept)
import Control.Monad.Eff.Exception (Error)
import Control.Monad.Trans.Class (lift)
import Data.List (List)
import Data.Either (Either(Left, Right), either)
import App.State (Collaborator)
import Simple.JSON (readJSON) 
import Data.Foreign.Generic (genericDecodeJSON)
import Data.Foreign (F, ForeignError) 
import Data.List.Types (NonEmptyList)
import Data.Generic.Rep
import Data.Generic.Rep.Show

data CombinedError
  = NetworkError Error
  | DecodeError (NonEmptyList ForeignError) 

derive instance ceGeneric :: Generic CombinedError _
instance showCombinedError :: Show CombinedError where
  show = genericShow
 
data Event
  = PageView Route 
  | ShowSecret
  | RequestCollaborators
  | ReceiveCollaborators (Either (CombinedError) (Array Collaborator))



type AppEffects fx = (ajax :: AJAX, console :: CONSOLE | fx)

foldp :: ∀ fx. Event -> State -> EffModel State Event (AppEffects fx)
foldp (PageView route) (State st) = noEffects $ State st { route = route, loaded = true } 

foldp (ShowSecret) (State st) = { state: State st { title = "Secret title!"},
                                  effects: [ log "Secret button clicked" *> pure Nothing ] 
                                }

foldp (RequestCollaborators) (State st) =
  { state: State st { title = "Fetching actors and movies..." }
  , effects: [ do
      eitherRes :: Either Error (AffjaxResponse String) <- attempt $ get "http://localhost:4000/collaborator?select=*"
      
      let collaborators = case eitherRes of 
                                Left err -> Left $ NetworkError err
                                Right res -> either (\decodeErr -> Left $ DecodeError decodeErr) (\collaborators -> Right collaborators) (readJSON (res.response) :: Either (NonEmptyList ForeignError) (Array Collaborator))
      
      pure $ Just $ ReceiveCollaborators collaborators 
    ]
  }

foldp (ReceiveCollaborators collaboratorsOrErrors) (State st) =
  noEffects $ case collaboratorsOrErrors of
    Left err -> State st { title = "Error fetching todos: " <> show err }
    Right collaborators -> State st { collaborators = collaborators, title = "Collaborators fetched" }