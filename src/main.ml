open BsPuppeteer
open Js.Promise


type typeOptions = { delay: float }  [@@bs.deriving jsConverter]

let makeTypeOptions d = typeOptionsToJs { delay=d }

(* XXX figure out viewport size.. *)

let clickButtonWithText page text =
  Page.waitForXPath page ~xpath:("//button[contains(., '"^text^"')]") ()
  |> then_(function button -> ElementHandle.click button ())

let login page =
  let options = Navigation.makeOptions ~timeout:5000.0 ~waitUntil:`domcontentloaded () in
  Page.goto page "https://instagram.com" ~options ()
  |> then_(fun _ -> Page.waitForSelector page "input[name=username]" ())
  |> then_(fun _ -> Page.type_ page "input[name=username]" Config.username ~options:(makeTypeOptions 100.) ())
  |> then_(fun _ -> Page.type_ page "input[name=password]" Config.password ~options:(makeTypeOptions 100.) ())
  |> then_(fun _ -> Page.click page "[type=submit]" ())
  |> then_(fun _ -> clickButtonWithText page "Not Now")


let openWindow () =
  let opt = Puppeteer.makeLaunchOptions ~headless: false () in
  Puppeteer.launch ~options:opt ()
  |> then_(fun browser -> Browser.newPage browser)
  |> then_(fun page ->
      let vp = Viewport.make ~width: 375 ~height: 667 () in
      Page.setViewport page ~viewport:vp
      |> (fun _ -> login page)
    )

let () =
  ignore (openWindow ())

let aa  = 11 + " asd"
