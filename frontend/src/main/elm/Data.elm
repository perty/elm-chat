module Data exposing (Message, sampleActiveChannel, sampleMessages)


type alias Message =
    { author : String, time : String, text : String }


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
