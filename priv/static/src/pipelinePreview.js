/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  app.PipelinePreview = React.createClass({
    render: function() {
      var onUpdate = this.props.onUpdate;
      var parentPath = this.props.path;
      var index = 0;
      console.log(this.props.pipeline);
      var taskNodes = this.props.pipeline.tasks.map(function (task) {
        return <span className="taskName">{task.name}</span>;
      });
      var statusUrl = "#status/" + this.props.pipeline.name;
      return (
        <div className="pipeline">
        <a href={statusUrl}>
        <span className="pipelineName">
        {this.props.pipeline.name}
        </span>
        </a>
        <div className="taskList">
        {taskNodes}
        </div>
        </div>
      );
    }
  });
})();
