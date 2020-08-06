(function() {
  "use strict";
  App.ModeratorProposals = {
    add_class_faded: function(id) {
      $("#" + id).addClass("faded");
      $("#comments").addClass("faded");
    },
    hide_moderator_actions: function(id) {
      $("#" + id + " .js-moderator-proposals-actions:first").hide();
    },
    redirect_to_proposals: function() {
      window.location.href = '/proposals';
    }
  };
}).call(this);
