module App.View.Homepage where

import App.Events (Event(..))
import App.State (State(..))
import Control.Bind (discard)
import Data.Function (($))
import Prelude hiding (div)
import Pux.DOM.Events (onClick)
import Pux.DOM.HTML (HTML)
import Text.Smolder.HTML (a, button, div, h1)
import Text.Smolder.HTML.Attributes (href, className, style)
import Text.Smolder.Markup ((!), text, (#!))

view :: State -> HTML Event
view (State s) =
  div do
    h1 $ text s.title
    button #! onClick (const ShowSecret) $ text "Show secret...!"
    button #! onClick (const RequestMovies) $ text "fetch"
