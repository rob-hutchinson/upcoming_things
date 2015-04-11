
$(function() {
  $("#albums_list button").click(function(e) {
    e.preventDefault();
    var $this = $(this);

    var $that = $this;
    if ($this.data('action') === 'favorite') {
      $.ajax("/albums/" + $this.data('id') + "/favorite", {
        method: "POST",
        success: function() {
          $that.removeClass("btn-success").addClass("btn-danger")
          .text("Unfollow").data("action", "unfavorite");
        },
        error: function() { alert("ERROR...ERROR"); }
      });

    } else {
      $.ajax("/albums/" + $this.data('id') + "/unfavorite", {
        method: "DELETE",
        success: function() {
          $that.removeClass("btn-danger").addClass("btn-success")
          .text("Follow").data("action", "favorite");
        },
        error: function() { alert("ERROR...ERROR"); }
      });
    }
  });
});

$(function() {
  $("#concert button").click(function(e) {
    e.preventDefault();
    var $this = $(this);
    console.log("FUUUUUUUUUUU")

    var $that = $this;
    if ($this.data('action') === 'add') {
      $.ajax("/albums/concert/add", {
        method: "POST",
        success: function() {
        },
        error: function() { alert("ERROR...ERROR"); }
      });
    }
  });
});