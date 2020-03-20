open BsPuppeteer
open Js.Promise
open Webapi.Dom

(*

Lurking:

   goal:
     - Like post of many profiles
     - Like 2nd, 3rd post (if exist)
     - Like only once
     - get all profiles that like or comment latest posts
     - Skip no posts, private
     - Skip already followers

Classes for elements of interest
   Likers:
   11 likes
   Liked by X and 12 others
   button class: sqdOP yWX7d _8A5w5

   Dialog with likers:
   nickname: Igw0E rBNOH eGOV_ ybXk5 _4EzTm
[role="dialog"] >div.Igw0E >div >div >div >div.vwCYk
   

*)

let getNicknames page = 
  let contSel = "[role=dialog]" in
  let nickSel = contSel ^ " a[title]" in
  Page.waitForSelector page contSel ~options:(Page.makeSelectorOptions ~visible:true ()) ()
  |> then_(fun _ ->
      Page.selectAllEval page nickSel (fun node_list ->
          [%raw {|
            [...node_list].map(n => { console.log(n.parentNode); return n.href })
          |}]
        )
    )
  |> then_(fun nick_arr ->
      nick_arr |> Array.iter (fun x -> Js.Console.log x)
      |> resolve
    )

let findLikers page =
  let likersSel = "button.sqdOP" in 
  Page.waitForSelector page likersSel ()
  |> then_(fun _ -> Page.selectAll page ~selector:likersSel)
  |> then_(fun button_arr ->
      let but1 = Array.get button_arr 0 in
      ElementHandle.click but1 ()
    )
|> then_(fun _ -> getNicknames page)

