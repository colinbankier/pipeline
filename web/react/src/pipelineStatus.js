/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  var TaskStatus = app.TaskStatus;
  var PipelineStatus = React.createClass({
    render: function() {
      var index = 0;
      var taskNodes = this.props.pipeline.taskResults.map(function (task) {
        var element;
        if (task.type == "pipeline") {
          element = <PipelineStatus pipeline={task}/>;
        } else {
          element = <TaskStatus task={task}/>;
        }
        return element;
      });
      return (
        <div className="pipeline">
        <span className="pipelineName">
        {this.props.pipeline.name}
        </span>
        <div className="taskList">
        {taskNodes}
        </div>
        </div>
      );
    }
  });
  app.PipelineStatus = PipelineStatus;
})();
