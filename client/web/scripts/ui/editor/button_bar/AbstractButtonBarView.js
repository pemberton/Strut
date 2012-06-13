// Generated by CoffeeScript 1.2.1-pre

define(["vendor/backbone"], function(Backbone) {
  return Backbone.View.extend({
    initialize: function(callbacks) {
      return this.buttonBarOptions = callbacks;
    },
    optionChosen: function(e) {
      var option;
      option = $(e.currentTarget).attr("data-option");
      return this.buttonBarOptions[option].call(this, e);
    }
  });
});
