module CodeGen.Runtime.SubrDefs (subrdefs) where

import Data.List (intercalate)

subrdefs :: String
subrdefs = intercalate "\n" [writey, abort]

writey :: String
writey = "void _souc_writey(struct _souc_obj obj) { puts(obj.val._souc_str); } "

abort :: String
abort = "void _souc_abort(void) { abort(); } "