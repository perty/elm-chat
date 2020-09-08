module Main exposing (Message, channelPanel, chatPanel, grey, main, sampleActiveChannel, sampleChannels, sampleMessages, white)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (..)
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


type alias Message =
    { author : String, time : String, text : String }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    { channels = sampleChannels
    , activeChannel = sampleActiveChannel
    }


sampleChannels : List String
sampleChannels =
    [ "beginners"
    , "core-coordination"
    , "ellie"
    , "elm-community"
    , "elm-discuss"
    , "elm-format"
    , "elm-markdown"
    , "elm-ui"
    , "general"
    , "jobs"
    , "news-and-links"
    ]


sampleActiveChannel : String
sampleActiveChannel =
    "elm-ui"


sampleMessages : List Message
sampleMessages =
    [ { author = "augustin82", time = "6:09AM", text = "@gampleman I think you need to `clip` the `scrollable` element, and that that element should be larger than its parent, which (I think) means that the containing parent should have a fixed width" }
    , { author = "u0421793", time = "6:22AM", text = "I’ve been trying to make a few links on a page in elm and elm-ui but I’ve not found a way to make it work because I haven’t found any examples of elm-ui which incorporate an anchor element" }
    , { author = "augustin82", time = "6:27AM", text = "@u0421793 what are you looking for exactly? do you have an Ellie where you've tried  doing some stuff?" }
    , { author = "icepac", time = "7:53 AM", text = "Anybody replied to @lango https://elmlang.slack.com/archives/C4F9NBLR1/p1541911789377400 About Animation vs Element ?" }
    , { author = "mgriffith", time = "8:00 AM", text = "You can use them together, for sure :smile: You just need to use `Element.htmlAttribute` to render the style attribute." }
    , { author = "duncan", time = "9:32 AM", text = "so ideally, it'd be nice to get the r,g,b,a components from a `Color` so that I could do the string interp (edited)" }
    , { author = "lango", time = "1:23 PM", text = "@mgriffith But that isn't really them 'working together' is it, its more they just happen to be together? For example, `elm-ui` has `background.gradient` but `elm-style-animation` only has `backgroundColor`. It's not clear to me how I could animation `elm-ui`'s `background.gradient` using `elm-animation`?" }
    , { author = "mgriffith", time = "4:28 PM", text = "@lango Oh, yeah I totally agree it isn’t seamless :smile: That’s why I’ve been putting a lot of time towards an API for animation for elm-ui.  But technically `elm-style-animation` and `elm-ui` can work together." }
    , { author = "eniac314", time = "6:49 AM", text = "It seems it it possible to press buttons without the event handler associated being fired when one clicks the thin area along the top border. In this example: https://ellie-app.com/3T4KLBKbnTQa1 it's possible to see the button moving without the counter increasing or decreasing. Is this due to the way I did the styling for the buttons? It seems to be related to the shadow (edited)" }
    , { author = "anthony.deschamps", time = "10:24 AM", text = "What's the most recent version of elm-ui/stylish-elephants that works on 0.18?" }
    , { author = "progger", time = "10:46 AM", text = "I've got some text that I'm laying out in a paragraph, and I want to put a link in there too.  Paragraph put the link on its own line though.  Shouldn't it all flow together?" }
    , { author = "progger", time = "11:22 AM", text = "Ha, I filed an issue about this back in oct.  Used my own workaround!" }
    ]


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
