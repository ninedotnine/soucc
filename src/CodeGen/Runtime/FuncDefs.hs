module CodeGen.Runtime.FuncDefs (funcdefs) where

import qualified Prelude
import Prelude (String)

import Data.Text (Text)
import qualified Data.Text as Text


funcdefs :: Text
funcdefs = Text.intercalate "\n" [
    tuple,
    sum,
    difference,
    product,
    quotient,
    remainder,
    is_equal_integer,
    is_unequal_integer,
    is_equal_bool,
    is_unequal_bool,
    is_lesser,
    is_greater,
    conjunction,
    disjunction,
    increment
    ]

tuple = "union _souc_obj _souc_tuple(union _souc_obj x, union _souc_obj y) { struct _souc_pair * p = calloc(sizeof(*p), 1); p->first = x; p->second = y; return (union _souc_obj) { ._souc_pair = p }; }"
-- FIXME can this be done without calloc?

sum = "union _souc_obj _souc_sum(union _souc_obj x, union _souc_obj y) { return (union _souc_obj) { ._souc_int = x._souc_int + y._souc_int };}"

difference = "union _souc_obj _souc_difference(union _souc_obj x, union _souc_obj y) { return (union _souc_obj) { ._souc_int = x._souc_int - y._souc_int };}"

product = "union _souc_obj _souc_product(union _souc_obj x, union _souc_obj y) { return (union _souc_obj) { ._souc_int = x._souc_int * y._souc_int };}"

quotient = "union _souc_obj _souc_quotient(union _souc_obj x, union _souc_obj y) { return (union _souc_obj) { ._souc_int = x._souc_int / y._souc_int };}"

remainder = "union _souc_obj _souc_remainder(union _souc_obj x, union _souc_obj y) { return (union _souc_obj) { ._souc_int = x._souc_int % y._souc_int };}"

is_equal_integer = "union _souc_obj _souc_is_equal_integer(union _souc_obj x, union _souc_obj y) { union _souc_obj b; b._souc_bool = x._souc_int == y._souc_int; return b;}"

is_unequal_integer = "union _souc_obj _souc_is_unequal_integer(union _souc_obj x, union _souc_obj y) { union _souc_obj b; b._souc_bool = x._souc_int != y._souc_int; return b;}"

is_equal_bool = "union _souc_obj _souc_is_equal_bool(union _souc_obj x, union _souc_obj y) { union _souc_obj b; b._souc_bool = x._souc_bool == y._souc_bool; return b;}"

is_unequal_bool = "union _souc_obj _souc_is_unequal_bool(union _souc_obj x, union _souc_obj y) { union _souc_obj b; b._souc_bool = x._souc_bool != y._souc_bool; return b;}"

is_lesser = "union _souc_obj _souc_is_lesser(union _souc_obj x, union _souc_obj y) { union _souc_obj b; b._souc_bool = x._souc_int < y._souc_int; return b;}"

is_greater = "union _souc_obj _souc_is_greater(union _souc_obj x, union _souc_obj y) { union _souc_obj b; b._souc_bool = x._souc_int > y._souc_int; return b;}"

conjunction = "union _souc_obj _souc_conjunction(union _souc_obj x, union _souc_obj y) { union _souc_obj b; b._souc_bool = x._souc_bool && y._souc_bool; return b;}"

disjunction = "union _souc_obj _souc_disjunction(union _souc_obj x, union _souc_obj y) { union _souc_obj b; b._souc_bool = x._souc_bool || y._souc_bool; return b;}"

increment = "union _souc_obj _souc_increment(union _souc_obj n) { return (union _souc_obj) { ._souc_int = n._souc_int + 1 };}"
