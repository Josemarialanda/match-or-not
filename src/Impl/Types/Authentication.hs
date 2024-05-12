module Impl.Types.Authentication where

import Impl.User.Postgres (UserRepositoryError)
import Infrastructure.Persistence.Queries (WrongNumberOfResults)

-- |
-- How 'authenticateUser' can actually fail
data Error
  = -- | the provided 'Credentials' data do not correspond to a unique user
    SelectUserError WrongNumberOfResults
  | -- | the interaction with the database somehow failed
    QueryError UserRepositoryError
  | -- | the password provided in the 'Credentials' data is not correct
    PasswordVerificationFailed
  deriving (Show)