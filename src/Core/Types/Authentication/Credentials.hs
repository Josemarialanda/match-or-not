module Core.Types.Authentication.Credentials
  ( Password (..)
  , Credentials (..)
  ) where

import Data.Aeson           (FromJSON (parseJSON), ToJSON (toJSON))
import Data.Aeson.Types     (Parser, Value)
import Data.ByteString      (ByteString)
import Data.OpenApi         (Definitions, NamedSchema, Schema, ToSchema (declareNamedSchema))
import Data.OpenApi.Declare (Declare)
import Data.Proxy           (Proxy (Proxy))
import Data.Text            (Text)
import Data.Text.Encoding   (decodeUtf8, encodeUtf8)

import GHC.Generics         (Generic)

-- |
-- A newtype wrapper over 'ByteString' to represent a non encrypted password
newtype Password = Password {asBytestring :: ByteString}

instance FromJSON Password where
  parseJSON :: Value -> Parser Password
  parseJSON json = Password . encodeUtf8 <$> parseJSON json

instance ToJSON Password where
  toJSON :: Password -> Value
  toJSON (Password s) = toJSON $ decodeUtf8 s

instance ToSchema Password where
  declareNamedSchema :: Proxy Password -> Declare (Definitions Schema) NamedSchema
  declareNamedSchema _ = declareNamedSchema (Proxy :: Proxy Text)

data Credentials = Credentials
  { username :: Text
  , password :: Password
  }
  deriving stock (Generic)
  deriving anyclass (FromJSON, ToJSON, ToSchema)
