module NoImportAs exposing (rule)

{-|

@docs rule

-}

import Elm.Syntax.Import exposing (Import)
import Elm.Syntax.Node exposing (Node)
import Review.Rule exposing (Error, Rule)


{-| Reports...

    config =
        [ NoImportAs.rule
        ]


## Fail

    import Json.Decode as JD


## Success

    import Json.Decode


## When (not) to enable this rule

This rule is useful when you want to forbid the use of import aliases.
THis rule is not useful when you don't.

-}
rule : Rule
rule =
    Review.Rule.newModuleRuleSchema "NoImportAs" ()
        |> Review.Rule.withSimpleImportVisitor importVisitor
        |> Review.Rule.fromModuleRuleSchema


importVisitor : Node Import -> List (Error {})
importVisitor node =
    case (Elm.Syntax.Node.value node).moduleAlias of
        Just _ ->
            Elm.Syntax.Node.range node
                |> Review.Rule.error
                    { message = "Remove the import alias."
                    , details = [ "Having (inconsistent) import aliases across files and projects confuses tools and humans. (Explicit is better than implicit.)" ]
                    }
                |> List.singleton

        Nothing ->
            []
