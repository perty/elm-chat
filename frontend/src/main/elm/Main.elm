module Main exposing (main)

import Api exposing (loadChannelMessages, loadChannels, sendMessage)
import Browser
import Model exposing (Message, Model, initialModel)
import Msg exposing (Msg(..))
import RemoteData exposing (RemoteData(..))
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



-- Subscription


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every second Tick


second =
    60000
