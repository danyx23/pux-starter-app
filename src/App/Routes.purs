module App.Routes where

import Prelude

import Data.Foreign (Foreign, F, readString, toForeign)
import Data.Foreign.Class (class Decode, class Encode)
import Data.Foreign.Generic (defaultOptions, genericDecode, genericEncode)
import Data.Function (($))
import Data.Functor ((<$))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Maybe (fromMaybe)
import Data.Show (class Show)
import Pux.Router (end, router)
import Simple.JSON (class ReadForeign, readImpl, class WriteForeign)
import Simple.JSON as Simple.JSON

data Route = Home | NotFound String

derive instance genericRoute :: Generic Route _
instance showRoute :: Show Route where show = genericShow
instance decodeRoute :: Decode Route where
  decode = genericDecode $ defaultOptions { unwrapSingleConstructors = true }
instance encodeRoute :: Encode Route where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

match :: String -> Route
match url = fromMaybe (NotFound url) $ router url $
  Home <$ end

toURL :: Route -> String
toURL (NotFound url) = url
toURL (Home) = "/" 

instance readFRoute :: ReadForeign Route where
  readImpl :: Foreign -> F Route
  readImpl f = do
    routeString <- readString f
    pure (match routeString )  

instance writeFRoute :: WriteForeign Route where
  writeImpl :: Route -> Foreign
  writeImpl =
    toForeign <<< toURL