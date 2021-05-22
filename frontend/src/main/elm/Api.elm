module Api exposing (channelDecoder, channelMessageDecoder, channelMessagesDecoder, decodeTime, httpErrorToString, loadChannelMessages, loadChannels, sendMessage)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import Model exposing (Message, Model)
import Msg exposing (Msg(..))
import RemoteData
import RemoteData.Http
import Time


loadChannels : Cmd Msg
loadChannels =
    RemoteData.Http.get "http://localhost:8080/api/v1/channels" HandleChannelResponse channelDecoder


channelDecoder : Decode.Decoder (List String)
channelDecoder =
    Decode.list Decode.string


loadChannelMessages : String -> Cmd Msg
loadChannelMessages channel =
    let
        url =
            "http://localhost:8080/api/v1/channels/" ++ channel ++ "/messages"
    in
    RemoteData.Http.get url HandleChannelMessagesResponse channelMessagesDecoder


sendMessage : String -> String -> (RemoteData.WebData String -> msg) -> Cmd msg
sendMessage channel message msg =
    RemoteData.Http.post
        ("http://localhost:8080/api/v1/channels/" ++ channel ++ "/messages")
        msg
        Decode.string
        (encodeSendMessage message)


encodeSendMessage : String -> Encode.Value
encodeSendMessage message =
    Encode.string message


channelMessagesDecoder : Decode.Decoder (List Message)
channelMessagesDecoder =
    Decode.list channelMessageDecoder


channelMessageDecoder : Decode.Decoder Message
channelMessageDecoder =
    Decode.succeed Message
        |> required "author" Decode.string
        |> required "content" Decode.string
        |> required "created" decodeTime


decodeTime : Decode.Decoder Time.Posix
decodeTime =
    Decode.int
        |> Decode.andThen
            (\ms ->
                Decode.succeed <| Time.millisToPosix ms
            )


httpErrorToString : Http.Error -> String
httpErrorToString error =
    case error of
        Http.BadUrl string ->
            "Bad url: " ++ string

        Http.Timeout ->
            "time out"

        Http.NetworkError ->
            "network error"

        Http.BadStatus int ->
            "Bad status: " ++ String.fromInt int

        Http.BadBody string ->
            "Bad body: " ++ string
