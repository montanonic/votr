import { voteCasting } from "./hooks/vote_casting"

export const Hooks = {}
Hooks.VoteCasting = voteCasting
// Hooks.DeleteButton = {
//   updated() {
//     console.log(this.viewName, this.el)
//   }
// }

/**
 * Hook for handling localstorage authentication of the current user.
 */
// Hooks.AuthUser = {
//   mounted() {},
//   checkLogin() {
//     if (getUserToken()) {
//     } else {
//       pushEvent()
//     }
//   },
//   getUserToken() {
//     localStorage.getItem(userToken())
//   },
//   userTokenKey: "votrUserToken"
// }
