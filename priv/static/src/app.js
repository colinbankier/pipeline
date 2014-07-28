/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  app.PIPELINE_LIST = 'pipelines';
  app.DESIGN = 'design';
  app.STATUS = 'status';

  var PipelineView = app.PipelineView;
  var PipelineList = app.PipelineList;
  var PipelineStatusView = app.PipelineStatusView;

  var PipelineApp = React.createClass({
    mixins: [FluxMixin, StoreWatchMixin("PipelineStore")],
    getStateFromFlux: function() {
      var flux = this.getFlux();
      return flux.store("PipelineStore").getState();
    },
    componentDidMount: function () {
      var setState = this.setState;
      var target = this;
      var router = Router({
        '/': setState.bind(this, {nowShowing: app.PIPELINE_LIST}),
        '/design/:pipelineName': function(pipelineName) {
          target.setState({nowShowing: app.DESIGN, pipeline: pipelineName});
        },
        '/status/:pipelineName': function(pipelineName) {
          target.setState({nowShowing: app.STATUS, pipeline: pipelineName});
        }
      });
      router.init('/');
    },
    getInitialState: function () {
      return {
        nowShowing: app.PIPELINE_LIST,
        editing: null
      };
    },
    displayedElement: function() {
      switch (this.state.nowShowing) {
        case app.PIPELINE_LIST:
          return <PipelineList />;
        case app.DESIGN:
          return <PipelineView pipelineId={this.state.pipeline}/>;
        case app.STATUS:
          return <PipelineStatusView url="pipelineStatus.json"/>;
        default:
          return <div>Not Found</div>;
      }
    },
    render: function() {
      return (
        <div className="pipelineApp">
        {this.displayedElement()}
        </div>
      );
    }
  });

  React.renderComponent(
    <PipelineApp flux={app.Flux}/>,
    document.getElementById('content')
  );
})();
