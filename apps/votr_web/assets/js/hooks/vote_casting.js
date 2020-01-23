import Sortable from "sortablejs"

function createSortable(elem, groupName, pushEventToSelf) {
  return new Sortable(elem, {
    // No server-side handling until we send the full voting results.
    // onAdd(e) {
    //   const { from, to, item } = e
    //   pushEventToSelf("move_vote", {
    //     from: from.dataset.id,
    //     to: to.dataset.id,
    //     voteOptionId: item.dataset.optionId
    //   })
    // },
    sort: false,
    animation: 150,
    pull: true,
    put: true,
    ghostClass: "sortable-ghost", // Class name for the drop placeholder
    chosenClass: "sortable-chosen", // Class name for the chosen item
    dragClass: "sortable-drag", // Class name for the dragging item
    group: { name: groupName, put: true }
  })
}

export const voteCasting = {
  mounted() {
    const pushEventToSelf = (event, payload) =>
      this.pushEventTo(this.selector, event, payload)

    const optionsList = document.getElementById("vote-options-list")
    createSortable(optionsList, "options-list", pushEventToSelf)

    const numOptions = optionsList.childElementCount

    for (let i = 1; i <= numOptions; i++) {
      const groupName = `group-${i}`
      const rankGroup = document.getElementById(groupName)
      createSortable(rankGroup, groupName, pushEventToSelf)
    }
  },
  selector: "#vote-casting-component"
}
