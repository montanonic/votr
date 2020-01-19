// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
// For Phoenix LiveView support:
import "mdn-polyfills/CustomEvent"
import "mdn-polyfills/String.prototype.startsWith"
import "mdn-polyfills/Array.from"
import "mdn-polyfills/NodeList.prototype.forEach"
import "mdn-polyfills/Element.prototype.closest"
import "mdn-polyfills/Element.prototype.matches"
import "child-replace-with-polyfill"
import "url-search-params-polyfill"
import "formdata-polyfill"
import "classlist-polyfill"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
import LiveSocket from "phoenix_live_view"
import { Socket } from "phoenix"

import socket from "./socket"
import { Hooks } from "./hooks"

//
// Initialize LiveSocket on client.
//
const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content")

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  logger: (kind, msg, data) => {
    console.log(`LiveSocket ${kind}: ${msg}`, data)
  },
  params: { _csrf_token: csrfToken }
})
window.liveSocket = liveSocket
liveSocket.connect()

//
// Initialize UserSocket on client.
//
socket.connect()
const channel = socket.channel("user", {})
channel
  .join()
  .receive("ok", resp => {
    console.log("Joined successfully:", resp)
  })
  .receive("error", resp => {
    console.log("Unable to join:", resp)
  })
