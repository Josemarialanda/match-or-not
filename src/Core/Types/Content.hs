module Core.Types.Content
  ( Content (..)
  , ContentRepository (..)
  ) where

import Core.Types.Id    (Id)
import Core.Types.Owned (Owned)
import Core.Types.Tag   (Tag)
import Core.Types.User  (User)

import Data.Aeson       (FromJSON, ToJSON)
import Data.OpenApi     (ToSchema)
import Data.Text        (Text)

import GHC.Generics     (Generic)

-- |
-- A 'ContentRepository' represents a collection of 'Content's.
-- It is indexed by a context 'm' which wraps the results.
data ContentRepository m = ContentRepository
  { selectUserContentsByTags :: Id User -> [Tag] -> m [Owned (Content Tag)]
  -- ^ selects all the 'Content's 'Owned' by a 'User' with a given 'Id' and indexed by all the provided 'Tag's
  , addContentWithTags       :: Id User -> Content Tag -> m (Id (Content Tag))
  -- ^ adds a 'Content' indexed by some 'Tag's for a 'User' identified by a given 'Id'
  }

-- |
-- A 'Content' is just a text indexed by a list of 'tag's
data Content tag = Content
  { message :: Text
  , tags    :: [tag]
  }
  deriving stock (Eq, Show, Functor, Generic)

instance Foldable Content where
  foldMap :: Monoid m => (a -> m) -> Content a -> m
  foldMap f = foldMap f . tags

instance Traversable Content where
  traverse :: Applicative f => (a -> f b) -> Content a -> f (Content b)
  traverse f Content{message, tags} = Content message <$> traverse f tags

instance ToSchema tag => ToSchema (Content tag)

instance FromJSON tag => FromJSON (Content tag)

instance ToJSON tag => ToJSON (Content tag)
