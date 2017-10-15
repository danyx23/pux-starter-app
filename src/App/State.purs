module App.State where

import App.Config (config)
import App.Routes (Route, match)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype)
import Data.Show (class Show)

newtype State = State
  { title :: String
  , route :: Route
  , loaded :: Boolean
  }

newtype MovieId = MovieId String

newtype Movie = Movie
  { id :: MovieId
  , title :: String
  , year :: Int
  }

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

instance showState :: Show State where show = genericShow

init :: String -> State
init url = State
  { title: config.title
  , route: match url
  , loaded: false
  }
