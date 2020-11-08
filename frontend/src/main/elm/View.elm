module View exposing (channelPanel, chatPanel, grey, view, white)

import Element exposing (Color, Element, alignBottom, alignRight, column, el, fill, fillPortion, height, layout, minimum, mouseOver, none, padding, paddingXY, paragraph, px, rgb255, rgba255, row, scrollbarY, spacingXY, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Model exposing (Message, Model)
import Msg exposing (Msg(..))
import RemoteData exposing (RemoteData(..), WebData)
import TimeUtil


view : Model -> Html Msg
view model =
    layout [ height fill ] <|
        row [ width <| minimum 600 fill, height fill, Font.size 16 ]
            [ channelPanel model.channels model.activeChannel
            , chatPanel model.activeChannel model.channelMessages
            ]


grey : Color
grey =
    rgb255 0xC0 0xC0 0xC0


white : Color
white =
    rgb255 0xFF 0xFF 0xFF


channelPanel : WebData (List String) -> String -> Element Msg
channelPanel channelData activeChannel =
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
    case channelData of
        NotAsked ->
            column [] [ el [] <| text "Not asked for it yet." ]

        Success channels ->
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

        Loading ->
            column [] [ el [] <| text "Loading channels." ]

        Failure _ ->
            column [] [ el [] <| text "Failed in loading channels." ]


chatPanel : String -> WebData (List Message) -> Element Msg
chatPanel channel messages =
    let
        header : Element msg
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
        , messagePanel messages
        , footer
        ]


messagePanel : WebData (List Message) -> Element Msg
messagePanel webMessages =
    case webMessages of
        NotAsked ->
            el [] <| text "Not asked"

        Loading ->
            el [] <| text "Loading"

        Failure _ ->
            el [] <| text "Failed"

        Success messages ->
            column [ padding 10, spacingXY 0 20, height fill, scrollbarY ] <|
                List.map messageEntry messages


messageEntry : Message -> Element msg
messageEntry message =
    column
        [ width fill, spacingXY 0 5 ]
        [ row [ spacingXY 10 0 ]
            [ el [ Font.bold ] <| text message.author, text (TimeUtil.timeToString TimeUtil.defaultZone message.created) ]
        , paragraph [] [ text message.content ]
        ]
