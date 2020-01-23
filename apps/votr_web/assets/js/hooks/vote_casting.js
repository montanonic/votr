import Sortable from "sortablejs"

export const voteCasting = {
  mounted() {
    const pushEventToSelf = (event, payload) =>
      this.pushEventTo(this.selector, event, payload)

    // Make the options list sortable.
    const optionsList = document.getElementById("vote-options-list")
    createSortable(optionsList, "options-list", pushEventToSelf)

    // Make each rank group sortable.
    const numOptions = optionsList.childElementCount
    for (let rankGroup of getRankGroups(numOptions)) {
      createSortable(rankGroup, rankGroup.dataset.id, pushEventToSelf)
    }

    // addSubmitVotesListener(numOptions, pushEventToSelf)
  },
  selector: "#vote-casting-component"
}

function getRankGroups(numOptions) {
  const rankGroups = []
  for (let i = 1; i <= numOptions; i++) {
    const groupName = `group-${i}`
    const rankGroup = document.getElementById(groupName)
    rankGroups.push(rankGroup)
  }
  return rankGroups
}

function createSortable(elem, groupName, pushEventToSelf) {
  return new Sortable(elem, {
    onAdd(e) {
      const { from, to, item, newDraggableIndex } = e
      pushEventToSelf("move_vote", {
        from: from.dataset.id,
        to: to.dataset.id,
        new_index: newDraggableIndex,
        option_id: Number(item.dataset.id)
      })
    },
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
