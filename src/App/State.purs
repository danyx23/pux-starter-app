module App.State where

import App.Config (config)
import App.Routes (Route, match)
import Data.Foreign.Class (class Decode)
import Data.Foreign.Generic (genericDecode, defaultOptions)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Lens (_1)
import Data.Newtype (class Newtype)
import Data.Show (class Show)
import Prelude (($))
import Simple.JSON (class ReadForeign, readImpl)
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

{-
derive instance genericMovie :: Generic Movie _
derive instance genericMovieId :: Generic MovieId _
derive instance genericPerson :: Generic Person _
derive instance genericPersonId :: Generic PersonId _
derive instance genericCollaborator :: Generic Collaborator _
derive instance genericCollaboratorId :: Generic CollaboratorId _
derive instance genericState :: Generic State _

instance showMovie :: Show Movie where show = genericShow
instance showPerson :: Show Person where show = genericShow
instance showCollaborator :: Show Collaborator where show = genericShow
instance showState :: Show State where show = genericShow
-}

derive newtype instance readFMovieId :: ReadForeign MovieId
derive newtype instance readFPersonId:: ReadForeign PersonId
derive newtype instance readFCollaboratorId :: ReadForeign CollaboratorId

{-
derive instance readFPersonRecord :: ReadForeign PersonRecord
derive instance readFMovieRecord :: ReadForeign MovieRecord
derive instance readFCollaboratorRecord :: ReadForeign CollaboratorRecord



derive newtype instance readFMovie :: ReadForeign Movie
derive newtype instance readFPerson :: ReadForeign Person
-}
--derive newtype instance readFCollaborator :: ReadForeign Collaborator

--derive newtype instance readFState :: ReadForeign State


{--
instance decodeMovieId :: Decode MovieId where
  decode = genericDecode $ defaultOptions {unwrapSingleConstructors = true}

instance decodeMovie :: Decode Movie where
  decode = genericDecode $ defaultOptions {unwrapSingleConstructors = true}

instance decodePersonId :: Decode PersonId where
  decode = genericDecode $ defaultOptions {unwrapSingleConstructors = true}

instance decodePerson :: Decode Person where
  decode = genericDecode $ defaultOptions {unwrapSingleConstructors = true}

instance decodeCollaboratorId :: Decode CollaboratorId where
  decode = genericDecode $ defaultOptions {unwrapSingleConstructors = true}

instance decodeCollaborator :: Decode Collaborator where
  decode = genericDecode $ defaultOptions {unwrapSingleConstructors = true}

instance decodeState :: Decode State where
  decode = genericDecode $ defaultOptions {unwrapSingleConstructors = true}
--}


