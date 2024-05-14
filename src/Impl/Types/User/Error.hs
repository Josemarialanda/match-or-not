module Impl.Types.User.Error
  ( UserRepositoryError (..)
  ) where

import Hasql.Session                            (QueryError (..))

import Infrastructure.Types.Persistence.Queries (WrongNumberOfResults)

-- We want to distinguish the `QueryError` coming from the violation of the "users_name_key" unique constraints
data UserRepositoryError
  = DuplicateUserName QueryError
  | UnexpectedNumberOfRows WrongNumberOfResults
  | OtherError QueryError
  deriving (Show)
