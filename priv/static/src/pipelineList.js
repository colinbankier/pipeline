/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  var PipelinePreview = app.PipelinePreview;
  app.PipelineList = React.createClass({
    loadFromServer: function() {
      $.ajax({
        url: this.props.url,
        dataType: 'json',
        success: function(data) {
          this.setState({pipelines: data.pipelines});
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
      });
    },
    getInitialState: function() {
      return {pipelines: []};
    },
    componentWillMount: function() {
      this.loadFromServer();
    },
    render: function() {
      var pipelineNodes = this.state.pipelines.map(function(pipeline) {
        return <PipelinePreview pipeline={pipeline}/>
      });
      return (
        <div className="tasks">
        { pipelineNodes }
        </div>
      );
    }
  });
})();
