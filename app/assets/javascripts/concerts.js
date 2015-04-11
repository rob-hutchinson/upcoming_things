
$(function() {
  $("button.add-concert").click(function(e) {
    e.preventDefault();
    var $this = $(this);
    console.log("FUUUUUUUUUUU");

    var $that = $this;
      $.ajax("/albums/concert/add", {
        method: "POST",
        success: function() {
          head :ok
        }
        error: function() { alert("ERROR...ERROR"); }
      }
    };
});