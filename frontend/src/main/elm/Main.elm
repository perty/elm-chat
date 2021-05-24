port module Main exposing (main)

import Api exposing (loadChannelMessages, loadChannels, sendMessage)
import Browser
import Json.Decode exposing (Decoder, andThen, decodeString, errorToString, field, oneOf, string, succeed)
import Json.Decode.Pipeline exposing (required)
import Model exposing (ChatMessage, Model, initialModel)
import Msg exposing (Msg(..))
import RemoteData exposing (RemoteData(..), WebData)
import Time
import View exposing (view)


port websocketIn : (String -> msg) -> Sub msg



--port websocketOut : Json.Encode.Value -> Cmd msg
--port setStorage : String -> Cmd msg


type Message
    = NewChatMessage NewChatMessagePayload
    | UnknownMessage String


type alias NewChatMessagePayload =
    { channel : String
    , message : String
    }


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

        UpdateCurrentInputMessage string ->
            ( { model | currentInputMessage = string }, Cmd.none )

        SendMessage ->
            ( model, sendMessage model.activeChannel model.currentInputMessage SendMessageResult )

        SendMessageResult webData ->
            case webData of
                Success _ ->
                    ( { model | sendMessageState = webData, currentInputMessage = "" }, Cmd.none )

                _ ->
                    ( { model | sendMessageState = webData }, Cmd.none )

        WebsocketIn message ->
            updateBasedOnMessage message model


updateBasedOnMessage : String -> Model -> ( Model, Cmd Msg )
updateBasedOnMessage message model =
    case decodeMessage message of
        NewChatMessage payload ->
            ( { model | lastMessageReceived = message }, Cmd.none )

        UnknownMessage string ->
            ( { model | lastMessageReceived = string }, Cmd.none )


decodeMessage : String -> Message
decodeMessage messageToDecode =
    case
        decodeString
            (oneOf
                [ newChatMessageDecoder
                ]
            )
            messageToDecode
    of
        Ok message ->
            message

        Err error ->
            UnknownMessage (errorToString error)


newChatMessageDecoder : Decoder Message
newChatMessageDecoder =
    field "newChatMessage" newChatMessagePayloadDecoder |> andThen (\payload -> succeed (NewChatMessage payload))


newChatMessagePayloadDecoder : Decoder NewChatMessagePayload
newChatMessagePayloadDecoder =
    succeed NewChatMessagePayload
        |> required "channel" string
        |> required "message" string



-- Subscription


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ websocketIn WebsocketIn
        , Time.every second Tick
        ]


second =
    60000
