import Sortable from "sortablejs"

function createSortable(elem, groupName) {
  return new Sortable(elem, {
    onAdd(e) {
      if (e.to.dataset.id)
      console.log(e)
      window.e = e
      this.send
    },
    animation: 150,
    pull: true,
    put: true,
    ghostClass: "sortable-ghost", // Class name for the drop placeholder
    chosenClass: "sortable-chosen", // Class name for the chosen item
    dragClass: "sortable-drag", // Class name for the dragging item
    group: { name: groupName, put: true }
  })
}

export const Hooks = {}
Hooks.VoteCasting = {
  mounted() {
    const optionsList = document.getElementById("vote-options-list")
    createSortable(optionsList, "options-list")

    const numOptions = optionsList.childElementCount

    for (let i = 1; i <= numOptions; i++) {
      const groupName = `group-${i}`
      const rankGroup = document.getElementById(groupName)
      createSortable(rankGroup, groupName)
    }
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
