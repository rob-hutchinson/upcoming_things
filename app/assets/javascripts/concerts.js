
$(function() {
  $("button.add-concert").click(function(e) {
    e.preventDefault();
    var $this = $(this);

    var $that = $this;
      $.ajax("/albums/concert/add", {
        method: "POST",
        success: function() { console.log("worked") },
        error: function() { alert("ERROR...ERROR"); }
      });
    }