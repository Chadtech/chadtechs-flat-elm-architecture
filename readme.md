# Chadtechs Super Flat Elm Architecture

It looks like (to me at least) that many people in the Elm community are learning that nested state is a bad thing. Deep and heirarchal application structures can be difficult to work with. For me, learning this lesson has meant learning about how _not_ to nest. This project is just a practice run to try out "super flat" techniques.


### Live Link
(here)[http://flat-elm-architecture.surge.sh/]

### Getting Starts
```
npm install
gulp
```

```


├── Dashboard
│   ├── Model.elm
│   │        Model + helpers
│   └── Page.elm
│             view, update, Msg
├── Data
│   └── Event.elm
│             Event + helpers
├── Document.elm
├── Flags.elm
├── Header.elm
│         view, update, Msg
├── Main.elm
├── Model.elm
├── Msg.elm
├── Route.elm
├── Search
│   ├── Model.elm
│   │        Model + helpers
│   └── Page.elm
│             view, update, Msg
├── Session.elm
├── Style.elm
├── Util
│   ├── Array.elm
│   ├── Cmd.elm
│   ├── Css.elm
│   ├── Duration.elm
│   ├── Html.elm
│   └── String.elm
├── View
│   ├── Card.elm
│   │         view
│   ├── Input.elm
│   │         view
│   └── LogLines.elm
│             views, Model, model helpers
├── View.elm
└── app.js
```