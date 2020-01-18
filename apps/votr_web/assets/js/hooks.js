import Sortable from "sortablejs"

const sortableOptions = {
  animation: 150,
  // easing: "cubic-bezier(1, 0, 0, 1)",
  // sort: true,
  pull: true,
  put: true,
  ghostClass: "sortable-ghost", // Class name for the drop placeholder
  chosenClass: "sortable-chosen", // Class name for the chosen item
  dragClass: "sortable-drag" // Class name for the dragging item
}

export const Hooks = {}
Hooks.VoteCasting = {
  mounted() {
    const optionsList = document.getElementById("vote-options-list")
    new Sortable(optionsList, {
      ...sortableOptions,
      group: { name: "options-list", put: true }
    })

    const numOptions = optionsList.childElementCount

    for (let i = 1; i <= numOptions; i++) {
      const groupName = `group-${i}`
      const optionGroup = document.getElementById(groupName)
      new Sortable(optionGroup, {
        ...sortableOptions,
        group: {
          name: groupName,
          put: true
        }
      })
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
