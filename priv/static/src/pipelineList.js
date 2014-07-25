/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  var PipelinePreview = app.PipelinePreview;
  var NewPipeline = app.NewPipeline;
  app.PipelineList = React.createClass({
    mixins: [FluxChildMixin, StoreWatchMixin("PipelineStore")],
    getInitialState: function() {
      return {pipelines: []};
    },
    getStateFromFlux: function() {
      console.log("got state from flux.");
      this.setState(app.Flux.store("PipelineStore").getState());
    },
    render: function() {
      var pipelineNodes = this.state.pipelines.map(function(pipeline) {
        return <PipelinePreview pipeline={pipeline}/>
      });
      return (
        <div className="tasks">
        { pipelineNodes }
        <div>
          <NewPipeline text="New pipeline"/>
        </div>
        </div>
      );
    }
  });
})();
