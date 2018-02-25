module App.State where

import App.Config (config)
import App.Routes
import Data.Foreign.Class (class Decode)
import Data.Foreign.Generic (genericDecode, defaultOptions)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Lens (_1)
import Data.Newtype (class Newtype)
import Data.Show (class Show)
import Prelude
import Simple.JSON (class ReadForeign, readImpl, class WriteForeign)
import Data.Newtype (class Newtype, unwrap) 
--import Data.Argonout (class DecodeJson, decodeJson, (.?))

newtype State = State StateRecord
type StateRecord =
  { title :: String 
  , route :: Route
  , loaded :: Boolean
  , collaborators :: Array Collaborator
  , persons :: Array Person
  , movies :: Array Movie
  }

newtype MovieId = MovieId String

newtype Movie = Movie MovieRecord
type MovieRecord =
  { id :: MovieId
  , title :: String
  , year :: Int
  }

newtype PersonId = PersonId String

newtype Person = Person PersonRecord
type PersonRecord =
  { id :: PersonId
  , firstName :: String
  , lastName :: String
  }

newtype CollaboratorId = CollaboratorId String

newtype Collaborator = Collaborator CollaboratorRecord
type CollaboratorRecord =
  { id :: CollaboratorId
  , personId :: PersonId
  , movieId :: MovieId
  }

derive instance ntMovieId :: Newtype MovieId _
derive instance ntPersonId :: Newtype PersonId _
derive instance ntCollaboratorId :: Newtype CollaboratorId _
derive instance ntMovie :: Newtype Movie _
derive instance ntPerson :: Newtype Person _
derive instance ntCollaborator :: Newtype Collaborator _
derive instance ntState :: Newtype State _

derive newtype instance showMovieId :: Show MovieId
derive newtype instance showPersonId :: Show PersonId
derive newtype instance showCollaboratorId :: Show CollaboratorId

init :: String -> State 
init url = State
  { title: config.title
  , route: match url
  , loaded: false
  , collaborators : []
  , persons : []
  , movies : []
  }



derive newtype instance readFMovieId :: ReadForeign MovieId
derive newtype instance readFPersonId:: ReadForeign PersonId
derive newtype instance readFCollaboratorId :: ReadForeign CollaboratorId
derive newtype instance readFMovie :: ReadForeign Movie
derive newtype instance readFPerson :: ReadForeign Person
derive newtype instance readFCollaborator :: ReadForeign Collaborator
derive newtype instance readFState :: ReadForeign State  

derive newtype instance writeFMovieId :: WriteForeign MovieId
derive newtype instance writeFPersonId:: WriteForeign PersonId
derive newtype instance writeFCollaboratorId :: WriteForeign CollaboratorId
derive newtype instance writeFMovie :: WriteForeign Movie
derive newtype instance writeFPerson :: WriteForeign Person
derive newtype instance writeFCollaborator :: WriteForeign Collaborator
derive newtype instance writeFState :: WriteForeign State  
