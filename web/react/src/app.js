/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  app.PIPELINE_LIST = 'pipelines';
  app.DESIGN = 'design';

  var PipelineView = app.PipelineView;
  var PipelineList = app.PipelineList;

  var PipelineApp = React.createClass({
    componentDidMount: function () {
      var setState = this.setState;
      var target = this;
      var router = Router({
        '/': setState.bind(this, {nowShowing: app.PIPELINE_LIST}),
        '/design/:pipelineName': function(pipelineName) {
          target.setState({nowShowing: app.DESIGN, pipeline: pipelineName});
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
    render: function() {
      var element;
      console.log(this.state.nowShowing);
      switch (this.state.nowShowing) {
        case app.PIPELINE_LIST:
          element = <PipelineList url="pipelines.json"/>;
          break;
        case app.DESIGN:
          element = <PipelineView url="pipeline.json"/>;
          break;
        default:
          element = <div>Not Found</div>;
      }
      return (
        <div className="pipelineApp">
        {element}
        </div>
      );
    }
  });

  React.renderComponent(
    <PipelineApp/>,
    document.getElementById('content')
  );
})();
