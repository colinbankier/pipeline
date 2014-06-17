/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  var Task = app.Task;
  var AddTask = app.AddTask;
  var Pipeline = React.createClass({
    render: function() {
      var onUpdate = this.props.onUpdate;
      var parentPath = this.props.path;
      var index = 0;
      var taskNodes = this.props.pipeline.tasks.map(function (task) {
        var element;
        var path = parentPath.concat(index);
        if (task.type == "pipeline") {
          element = <Pipeline pipeline={task} onUpdate={onUpdate} path={path} index={index} />;
        } else {
          element = <Task task={task} path={path} onUpdate={onUpdate} index={index} />;
        }
        index = index + 1;
        return element;
      });
      var addTaskPath = parentPath.concat(index);
      var newTask = {};
      return (
        <div className="pipeline">
        <h2 className="pipelineName">
        {this.props.index} {this.props.pipeline.name}
        </h2>
        <AddTask task={this.props.pipeline} path={this.props.path} onUpdate={this.props.onUpdate} text="Edit"/>
        <AddTask task={newTask} path={addTaskPath} onUpdate={this.props.onUpdate} text="Add task"/>
        <div className="taskList">
        {taskNodes}
        </div>
        </div>
      );
    }
  });
  app.Pipeline = Pipeline;
})();
