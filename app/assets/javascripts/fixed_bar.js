(function() {
  "use strict";
  App.FixedBar = {
    initialize: function() {
      $("[data-fixed-bar]").each(function() {
        var $this, fixedBarTopPosition;
        $this = $(this);
        fixedBarTopPosition = $this.offset().top;
      });
    }
  };
}).call(this);
