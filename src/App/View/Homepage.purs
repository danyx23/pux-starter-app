module App.View.Homepage where

import Prelude hiding (div)
import App.Events (Event(..))
import App.State (State(..))
import Control.Bind (discard)
import Data.Function (($))
import Pux.DOM.HTML (HTML)
import Pux.DOM.Events (onClick)
import Text.Smolder.HTML (a, div, h1, button)
import Text.Smolder.HTML.Attributes (href, className)
import Text.Smolder.Markup ((!), text, (#!))

view :: State -> HTML Event
view (State s) =
  div do
    h1 $ text s.title
    button #! onClick (const ShowSecret) $ text "Show secret!"
