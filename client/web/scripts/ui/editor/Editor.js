// Generated by CoffeeScript 1.2.1-pre
/*
@author Matt Crinklaw-Vogt
*/

define(["vendor/backbone", "./SlideEditor", "./transition_editor/TransitionEditor", "./Templates", "ui/impress_renderer/ImpressRenderer", "ui/widgets/RawTextImporter", "ui/widgets/OpenDialog", "ui/widgets/SaveAsDialog", "storage/FileStorage", "ui/widgets/BackgroundPicker", "css!./res/css/Editor.css"], function(Backbone, SlideEditor, TransitionEditor, Templates, ImpressRenderer, RawTextModal, OpenDialog, SaveAsDialog, FileStorage, BackgroundPicker, empty) {
  var editorId, menuOptions;
  editorId = 0;
  menuOptions = {
    "new": function(e) {},
    open: function(e) {
      var _this = this;
      return this.openDialog.show(function(fileName) {
        var data;
        console.log("Attempting to open " + fileName);
        data = FileStorage.open(fileName);
        console.log(data);
        if (data != null) return _this.model["import"](data);
      });
    },
    openRecent: function(e) {},
    save: function(e) {
      var fileName;
      fileName = this.model.get("fileName");
      if (!(fileName != null)) {
        return menuOptions.saveAs.call(this, e);
      } else {
        return FileStorage.save(fileName, this.model.toJSON(false, true));
      }
    },
    saveAs: function(e) {
      var _this = this;
      return this.saveAsDialog.show(function(fileName) {
        if ((fileName != null) && fileName !== "") {
          console.log("Attempting to save " + fileName);
          _this.model.set("fileName", fileName);
          return FileStorage.save(fileName, _this.model.toJSON(false, true));
        }
      });
    },
    undo: function(e) {
      return this.model.undo();
    },
    redo: function(e) {
      return this.model.redo();
    },
    cut: function(e) {
      var perspective;
      perspective = this.perspectives[this.activePerspective];
      if (perspective != null) return perspective.cut();
    },
    copy: function(e) {
      var perspective;
      perspective = this.perspectives[this.activePerspective];
      if (perspective != null) return perspective.copy();
    },
    paste: function(e) {
      var perspective;
      perspective = this.perspectives[this.activePerspective];
      if (perspective != null) return perspective.paste();
    },
    transitionEditor: function(e) {
      return this.changePerspective(e, {
        perspective: "transitionEditor"
      });
    },
    slideEditor: function(e) {
      return this.changePerspective(e, {
        perspective: "slideEditor"
      });
    },
    preview: function(e) {
      return this.$el.trigger("preview");
    },
    exportJSON: function(e) {
      return this.rawTextModal.show(null, JSON.stringify(this.model.toJSON(false, true)));
    },
    importJSON: function(e) {
      var _this = this;
      return this.rawTextModal.show(function(json) {
        return _this.model["import"](JSON.parse(json));
      });
    },
    changeBackground: function() {
      var _this = this;
      return this.backgroundPickerModal.show(function(bgState) {
        return _this.model.set("background", bgState);
      });
    }
  };
  return Backbone.View.extend({
    className: "editor",
    events: {
      "click .menuBar .dropdown-menu > li": "menuItemSelected",
      "changePerspective": "changePerspective",
      "preview": "renderPreview"
    },
    initialize: function() {
      this.id = editorId++;
      this.perspectives = {
        slideEditor: new SlideEditor({
          model: this.model
        }),
        transitionEditor: new TransitionEditor({
          model: this.model
        })
      };
      this.activePerspective = "slideEditor";
      this.model.undoHistory.on("updated", this.undoHistoryChanged, this);
      return this.model.on("change:background", this._backgroundChanged, this);
    },
    undoHistoryChanged: function() {
      var $lbl, redoName, undoName;
      undoName = this.model.undoHistory.undoName();
      redoName = this.model.undoHistory.redoName();
      if (undoName !== "") {
        $lbl = this.$el.find(".undoName");
        $lbl.text(undoName);
        $lbl.removeClass("disp-none");
      } else {
        this.$el.find(".undoName").addClass("disp-none");
      }
      if (redoName !== "") {
        $lbl = this.$el.find(".redoName");
        $lbl.text(redoName);
        return $lbl.removeClass("disp-none");
      } else {
        return this.$el.find(".redoName").addClass("disp-none");
      }
    },
    renderPreview: function() {
      var newWind, showStr;
      showStr = ImpressRenderer.render(this.model.attributes);
      return newWind = window.open("data:text/html;charset=utf-8," + escape(showStr));
    },
    changePerspective: function(e, data) {
      var _this = this;
      this.activePerspective = data.perspective;
      return _.each(this.perspectives, function(perspective, key) {
        if (key === _this.activePerspective) {
          return perspective.show();
        } else {
          return perspective.hide();
        }
      });
    },
    _backgroundChanged: function(model, value) {
      var key, persp, _ref, _results;
      console.log("WTF");
      _ref = this.perspectives;
      _results = [];
      for (key in _ref) {
        persp = _ref[key];
        _results.push(persp.backgroundChanged(value));
      }
      return _results;
    },
    menuItemSelected: function(e) {
      var $target, option;
      $target = $(e.currentTarget);
      option = $target.attr("data-option");
      return menuOptions[option].call(this, e);
    },
    render: function() {
      var $perspectivesContainer, perspectives,
        _this = this;
      perspectives = _.map(this.perspectives, function(perspective, key) {
        return {
          perspective: key,
          name: perspective.name
        };
      });
      this.$el.html(Templates.Editor({
        id: this.id,
        perspectives: perspectives
      }));
      this.$el.find(".dropdown-toggle").dropdown();
      $perspectivesContainer = this.$el.find(".perspectives-container");
      _.each(this.perspectives, function(perspective, key) {
        $perspectivesContainer.append(perspective.render());
        if (key === _this.activePerspective) {
          return perspective.show();
        } else {
          return perspective.$el.addClass("disp-none");
        }
      });
      this.undoHistoryChanged();
      this.rawTextModal = new RawTextModal();
      this.$el.append(this.rawTextModal.render());
      this.openDialog = new OpenDialog();
      this.saveAsDialog = new SaveAsDialog();
      this.$el.append(this.openDialog.render());
      this.$el.append(this.saveAsDialog.render());
      this.backgroundPickerModal = new BackgroundPicker({
        bgOpts: {
          type: "radial",
          controlPoints: ["#F0F0F0 0%", "#BEBEBE 100%"]
        }
      });
      this.$el.append(this.backgroundPickerModal.render());
      return this.$el;
    }
  });
});
