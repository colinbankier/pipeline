/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  var PipelinePreview = app.PipelinePreview;
  var NewPipeline = app.NewPipeline;
  app.PipelineList = React.createClass({
    mixins: [FluxChildMixin, StoreWatchMixin("PipelinesStore")],
    getInitialState: function() {
      return {pipelines: []};
    },
    getStateFromFlux: function() {
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
