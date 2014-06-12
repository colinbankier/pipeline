/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  var Pipeline = app.Pipeline;
  app.PipelineView = React.createClass({
    loadFromServer: function() {
      $.ajax({
        url: this.props.url,
        dataType: 'json',
        success: function(data) {
          this.setState({data: data});
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
      });
    },
    updatePipeline: function(task, path) {
      var pipeline = this.state.data;
      var childPipeline = pipeline;
      for (i = 0; i < path.length; i++) {
        var index = path[i];
        if (i == path.length - 1) {
          childPipeline.tasks[index] = task;
        } else {
          childPipeline = childPipeline.tasks[index];
        }
      }
      this.setState({data: pipeline});
    },
    getInitialState: function() {
      return {data: {name: "", tasks: []}};
    },
    componentWillMount: function() {
      this.loadFromServer();
    },
    render: function() {
      return (
        <Pipeline pipeline={this.state.data} path={[]} onUpdate={this.updatePipeline} />
      );
    }
  });
})();
