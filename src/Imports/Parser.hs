module Imports.Parser (
    parse_module_header
) where

import Data.Text (Text)
import qualified Data.Text as Text
import Text.Parsec hiding (string, space, spaces, newline)
import qualified Text.Parsec (string)

import Common
import Common.Parsing
import Parser.SouC_Expr  (Raw_Expr(..), raw_expr)
import Parser.SouC_Stmts (stmt_block)
import Parser.ExprParser (parse_expression)
import Parser.TabChecker (check_tabs)

import Debug.Trace

type HeaderParser a = Parsec Text [ImportDecl] a

add_to_imports :: ImportDecl -> HeaderParser ()
add_to_imports name = modifyState (\l -> name:l)

parse_module_header :: SourceName -> Text -> Either ParseError (SoucModule, [ImportDecl], Text)
parse_module_header name input = runParser module_header_and_imports [] name input

module_header_and_imports :: HeaderParser (SoucModule, [ImportDecl], Text)
module_header_and_imports = do
    m_header <- optionMaybe module_header

    _ <- many (pragma) *> skipMany endline -- FIXME do something with pragmas
    imps <- import_list
    rest <- getInput
    pure (spoof_module m_header, imps, rest)

spoof_module :: Maybe SoucModule -> SoucModule
spoof_module = \case
    Just m -> m
    Nothing -> SoucModule "anonymous_main_module" []


module_header :: HeaderParser SoucModule
module_header = do
    name <- string "module" *> space *> raw_identifier
    decls <- optionMaybe export_decls
    case decls of
        Just exports ->
            pure $ SoucModule name exports
        Nothing -> do
            endline <* many pragma <* endline
            pure $ SoucModule name []

export_decls :: HeaderParser [ExportDecl]
export_decls = do
    try (space *> reserved "where") *> endline
    many1 (tab *> export_decl)

export_decl :: HeaderParser ExportDecl
export_decl = do
    i <- raw_identifier <* optional spaces
    t <- type_signature <* endline
    pure (ExportDecl (Identifier i) t)


import_list :: HeaderParser [ImportDecl]
import_list = many souc_import
    -- FIXME a blank line is required before any code


souc_import :: HeaderParser ImportDecl
souc_import = do
    name <- reserved "import" *> spaces *> module_path <* skipMany1 endline
    pure (LibImport name)


module_path :: HeaderParser Text
module_path = do
    leading_slash <- option "" slash
    dir <- many $ lookAhead (try (name <> slash)) *> (name <> slash)
    path <- raw_identifier
    pure (leading_slash <> Text.concat dir <> path)
        where
            dot = string "."
            dotdot = string ".."
            slash = string "/"
            name :: HeaderParser Text
            name = Text.pack <$> (many1 identifier_char) <|> dotdot <|> dot
