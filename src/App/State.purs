module App.State where

import App.Config (config)
import App.Routes (Route, match)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype)
import Data.Show (class Show)
import Data.Argonaut (decodeJson, class DecodeJson, (.?))

import Prelude (bind, ($), pure)

-- data Movie = Movie {
--   id :: String,
--   title :: String,
--   year :: Int
-- }

newtype State = State
  { title :: String
  , route :: Route
  , loaded :: Boolean
  , movies :: Array Movie
  }

newtype MovieId = MovieId String

newtype Movie = Movie
  { id :: String
  , title :: String
  , year :: Int
  }

instance decodeMovie :: DecodeJson Movie where
  decodeJson json = do
    obj <- decodeJson json
    title <- obj .? "title"
    pure $ Movie { id: "oij", title: title, year: 1900 }

newtype PersonId = PersonId String

newtype Person = Person
  { id :: PersonId
  , firstName :: String
  , lastName :: String
  }

newtype Collaborator = Collaborator
  { personId :: PersonId
  , movieId :: MovieId
  , role :: String
  }

derive instance genericState :: Generic State _
derive instance newtypeState :: Newtype State _

-- TODO: uncomment when genericShow works for Movie
-- instance showState :: Show State where show = genericShow

init :: String -> State
init url = State
  { title: config.title
  , route: match url
  , loaded: false
  , movies: []
  }
