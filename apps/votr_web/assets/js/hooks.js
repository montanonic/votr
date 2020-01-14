export const Hooks = {}
Hooks.VoteLiveView = {
  mounted() {
    console.log("Mounted vote live view")
  }
}
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
