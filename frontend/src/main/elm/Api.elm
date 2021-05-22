module Api exposing (channelDecoder, channelMessageDecoder, channelMessagesDecoder, decodeTime, loadChannelMessages, loadChannels)

import Json.Decode
import Json.Decode.Pipeline exposing (required)
import Model exposing (Message, Model)
import Msg exposing (Msg(..))
import RemoteData.Http
import Time


loadChannels : Cmd Msg
loadChannels =
    RemoteData.Http.get "http://localhost:8080/api/v1/channels" HandleChannelResponse channelDecoder


channelDecoder : Json.Decode.Decoder (List String)
channelDecoder =
    Json.Decode.list Json.Decode.string


loadChannelMessages : String -> Cmd Msg
loadChannelMessages channel =
    let
        url =
            "http://localhost:8080/api/v1/channels/" ++ channel ++ "/messages"
    in
    RemoteData.Http.get url HandleChannelMessagesResponse channelMessagesDecoder


channelMessagesDecoder : Json.Decode.Decoder (List Message)
channelMessagesDecoder =
    Json.Decode.list channelMessageDecoder


channelMessageDecoder : Json.Decode.Decoder Message
channelMessageDecoder =
    Json.Decode.succeed Message
        |> required "author" Json.Decode.string
        |> required "content" Json.Decode.string
        |> required "created" decodeTime


decodeTime : Json.Decode.Decoder Time.Posix
decodeTime =
    Json.Decode.int
        |> Json.Decode.andThen
            (\ms ->
                Json.Decode.succeed <| Time.millisToPosix ms
            )
