module NoImportAsTest exposing (all)

import NoImportAs exposing (rule)
import Review.Test
import Test exposing (Test, describe, test)


all : Test
all =
    describe "NoImportAs"
        [ test "should report an error when import aliases are used" <|
            \() ->
                """module A exposing (..)
import JSON.Decode as JD
import JSON.Encode as JE"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Remove the import alias."
                            , details = [ "Having (inconsistent) import aliases across files and projects confuses tools and humans. (Explicit is better than implicit.)" ]
                            , under = "import JSON.Decode as JD"
                            }
                        , Review.Test.error
                            { message = "Remove the import alias."
                            , details = [ "Having (inconsistent) import aliases across files and projects confuses tools and humans. (Explicit is better than implicit.)" ]
                            , under = "import JSON.Encode as JE"
                            }
                        ]
        ]
