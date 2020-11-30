module Main exposing (main)

import Browser
import Json.Decode
import Json.Decode.Pipeline exposing (required)
import Model exposing (Message, Model, initialModel)
import Msg exposing (Msg(..))
import RemoteData.Http
import Time
import View exposing (view)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, loadChannels )


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



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Msg" msg of
        Tick _ ->
            ( model, Cmd.none )

        SelectChannel channel ->
            ( { model | activeChannel = channel }, loadChannelMessages channel )

        HandleChannelResponse channelList ->
            ( { model | channels = channelList }, loadChannelMessages model.activeChannel )

        HandleChannelMessagesResponse channelMessages ->
            ( { model | channelMessages = channelMessages }, Cmd.none )

        ToggleSearching ->
            ( { model | searching = not model.searching }, Cmd.none )



-- Subscription


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every second Tick


second =
    60000
