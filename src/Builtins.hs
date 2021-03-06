module Builtins (
    gen_builtin_identifier,
    gen_builtin_data,
    typeof_builtin_identifier,
    typeof_builtin_data,
    BuiltinsCtx(..),
) where

import qualified Data.HashMap.Strict as Map
import Data.Text (Text)
import qualified Data.Text as Text

import Common
import Parser.ExprParser


type Mapping = Map.HashMap Text (Text, SoucType)

newtype BuiltinsCtx = Builtins [Bound] deriving Show

gen_builtin_identifier :: Identifier -> Maybe Text
gen_builtin_identifier (Identifier i) = fst <$> Map.lookup i builtins where
    builtins = builtin_subroutines <>  builtin_functions <> builtin_constants

typeof_builtin_identifier :: Identifier -> Maybe SoucType
typeof_builtin_identifier (Identifier i) = snd <$> Map.lookup i builtins where
    builtins = builtin_subroutines <> builtin_functions <> builtin_constants


gen_builtin_data :: Text -> Maybe Text
gen_builtin_data s = fst <$> Map.lookup s builtin_data

typeof_builtin_data :: Text -> Maybe SoucType
typeof_builtin_data i = snd <$> Map.lookup i builtin_data

builtin_subroutines :: Mapping
builtin_subroutines = Map.fromList [
    ("puts", ("_souc_puts", (SoucRoutn (Just (SoucType "String")))))
    ,
    ("write", ("_souc_write", SoucRoutn (Just (SoucPair (SoucType "OutputStream") (SoucType "String")))))
    ,
    ("abort", ("abort", SoucRoutn Nothing))
    ]

builtin_functions :: Mapping
builtin_functions = Map.fromList [
    ("increment", ("_souc_increment", SoucFn (SoucType "Integer") (SoucType "Integer")))
    ]

builtin_constants :: Mapping
builtin_constants = Map.fromList [
    ("pi", ("(union _souc_obj) { ._souc_int = 3 }", SoucType "Integer")) -- biblical value
    ,
    ("i42", ("_souc_42", SoucType "Integer"))
    ,
    ("ok43", ("_souc_42", SoucType "Integer"))
    ]

builtin_data :: Mapping
builtin_data = Map.fromList [
    ("True", ("(union _souc_obj) { ._souc_bool = true }", SoucType "Bool"))
    ,
    ("False", ("(union _souc_obj) { ._souc_bool = false }", SoucType "Bool"))
    ,
    ("None", ("_souc_none", SoucMaybe (SoucType "Integer")))
    ,
    ("OK", ("_souc_ok", SoucFn (SoucType "Integer") (SoucMaybe (SoucType "Integer"))))
    ]
