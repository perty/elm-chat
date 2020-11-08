module TimeUtil exposing (defaultZone, stringFromPosix, timeToDate, timeToHourMinute, timeToString, toIntMonth)

import Time exposing (Month(..))


defaultZone : Time.Zone
defaultZone =
    Time.utc


timeToString : Time.Zone -> Time.Posix -> String
timeToString zone timeStamp =
    timeToDate zone timeStamp
        ++ " "
        ++ timeToHourMinute zone timeStamp


timeToDate : Time.Zone -> Time.Posix -> String
timeToDate zone timeStamp =
    String.join "-" <| List.map (stringFromPosix zone timeStamp) [ Time.toYear, toIntMonth, Time.toDay ]


timeToHourMinute : Time.Zone -> Time.Posix -> String
timeToHourMinute zone timeStamp =
    String.join ":" <| List.map (stringFromPosix zone timeStamp) [ Time.toHour, Time.toMinute ]


stringFromPosix : Time.Zone -> Time.Posix -> (Time.Zone -> Time.Posix -> Int) -> String
stringFromPosix zone time fn =
    fn zone time |> twoCharacterInt


toIntMonth : Time.Zone -> Time.Posix -> Int
toIntMonth zone time =
    case Time.toMonth zone time of
        Jan ->
            1

        Feb ->
            2

        Mar ->
            3

        Apr ->
            4

        May ->
            5

        Jun ->
            6

        Jul ->
            7

        Aug ->
            8

        Sep ->
            9

        Oct ->
            10

        Nov ->
            11

        Dec ->
            12


twoCharacterInt : Int -> String
twoCharacterInt n =
    if n < 10 then
        "0" ++ String.fromInt n

    else
        String.fromInt n
