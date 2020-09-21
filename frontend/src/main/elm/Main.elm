module Main exposing (main)

import Browser
import Data exposing (Message, sampleActiveChannel, sampleChannels, sampleMessages)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Time


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type Msg
    = Tick Time.Posix
    | SelectChannel String


type alias Model =
    { channels : List String
    , activeChannel : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    { channels = sampleChannels
    , activeChannel = sampleActiveChannel
    }


grey : Color
grey =
    rgb255 0xC0 0xC0 0xC0


white : Color
white =
    rgb255 0xFF 0xFF 0xFF


channelPanel : List String -> String -> Element Msg
channelPanel channels activeChannel =
    let
        activeChannelAttrs =
            [ Background.color <| rgba255 0 0 0 0.4, Font.bold ]

        channelAttrs =
            [ width fill, height <| px 30, paddingXY 10 5 ]

        channelEl channel =
            Input.button []
                { onPress = Just <| SelectChannel channel
                , label =
                    el
                        (if channel == activeChannel then
                            activeChannelAttrs ++ channelAttrs

                         else
                            channelAttrs
                        )
                    <|
                        text ("# " ++ channel)
                }
    in
    column
        [ height fill
        , width <| fillPortion 1
        , paddingXY 0 10
        , scrollbarY
        , Background.color <| rgb255 0xD0 0xD0 0xD0
        , Font.color white
        ]
    <|
        List.map channelEl channels


chatPanel : String -> List Message -> Element msg
chatPanel channel messages =
    let
        header =
            row
                [ width fill
                , height <| px 50
                , paddingXY 20 5
                , Border.widthEach { bottom = 2, top = 0, left = 0, right = 0 }
                , Border.color grey
                ]
                [ el [] <| text ("#" ++ channel)
                , Input.button
                    [ padding 5
                    , alignRight
                    , Border.width 2
                    , Border.rounded 6
                    , Border.color grey
                    ]
                    { onPress = Nothing
                    , label = text "Search"
                    }
                ]

        messageEntry message =
            column
                [ width fill, spacingXY 0 5 ]
                [ row [ spacingXY 10 0 ]
                    [ el [ Font.bold ] <| text message.author, text message.time ]
                , paragraph [] [ text message.text ]
                ]

        messagePanel =
            column [ padding 10, spacingXY 0 20, height fill, scrollbarY ] <|
                List.map messageEntry messages

        footer =
            el [ alignBottom, padding 20, width fill ] <|
                row
                    [ spacingXY 2 0
                    , width fill
                    , Border.width 2
                    , Border.rounded 6
                    , Border.color grey
                    ]
                    [ el
                        [ padding 5
                        , Border.widthEach { right = 2, left = 0, top = 0, bottom = 0 }
                        , Border.color grey
                        , Font.bold
                        , mouseOver [ Background.color <| rgb255 86 182 139 ]
                        ]
                      <|
                        text " + "
                    , el [ Background.color white ] none
                    ]
    in
    column [ height fill, width <| fillPortion 3 ]
        [ header
        , messagePanel
        , footer
        ]



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( model, Cmd.none )

        SelectChannel channel ->
            ( { model | activeChannel = channel }, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    layout [ height fill ] <|
        row [ width <| minimum 600 fill, height fill, Font.size 16 ]
            [ channelPanel model.channels model.activeChannel
            , chatPanel model.activeChannel sampleMessages
            ]



-- Subscription


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every second Tick


second =
    60000
