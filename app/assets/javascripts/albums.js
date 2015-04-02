
$(function() {
  $("#favorite-album-table button").click(function(e) {
    e.preventDefault();
    var $this = $(this);

    var $that = $this;
    if ($this.data('action') === 'favorite') {
      $.ajax("/albums/" + $this.data('id') + "/favorite", {
        method: "POST",
        success: function() {
          $that.removeClass("btn-default").addClass("btn-danger")
          .text("Unfollow").data("action", "unfavorite");
        },
        error: function() { alert("ERROR...ERROR"); }
      });

    } else {
      $.ajax("/albums/" + $this.data('id') + "/unfavorite", {
        method: "DELETE",
        success: function() {
          $that.removeClass("btn-danger").addClass("btn-default")
          .text("Follow").data("action", "favorite");
        },
        error: function() { alert("ERROR...ERROR"); }
      });
    }
  });
});