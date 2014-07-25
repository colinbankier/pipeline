/**
 * @jsx React.DOM
 */

var app = app || {};
var pipelinesEndpoint = "pipelines.json";
var FluxMixin = Fluxxor.FluxMixin(React),
    FluxChildMixin = Fluxxor.FluxChildMixin(React),
    StoreWatchMixin = Fluxxor.StoreWatchMixin;


(function() {
  var constants = {
    ADD_PIPELINE: "ADD_PIPELINE"
  };

  app.PipelineStore = Fluxxor.createStore({
    initialize: function() {
      this.state = {pipelines: []};
      this.bindActions(
        constants.ADD_PIPELINE, this.onAddPipeline
      );
      this.loadFromServer();
    },
    onAddPipeline: function(payload) {
      console.log("onAddPipeline");
      this.state.pipelines.push({name: payload.name, type: "pipeline"});
      this.emit("change");
    },
    setState: function(state) {
      this.state = state;
    },
    getState: function() {
      return this.state;
    },
    loadFromServer: function() {
      $.ajax({
        url: pipelinesEndpoint,
        dataType: 'json',
        success: function(data) {
          this.setState(data);
          console.log("Store loaded from server");
          this.emit("change");
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(pipelinesEndpoint, status, err.toString());
        }.bind(this)
      });
    }
  });

  var actions = {
    addPipeline: function(text) {
      this.dispatch(constants.ADD_PIPELINE, {text: text});
    }
  };

  var stores = {
    PipelineStore: new app.PipelineStore()
  };

  app.Flux = new Fluxxor.Flux(stores, actions);
})();
