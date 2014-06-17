/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  var AddTask = app.AddTask;

  app.Task = React.createClass({
    render: function() {
      return (
        <div className="task">
        {this.props.index} {this.props.task.name}
        <AddTask task={this.props.task} path={this.props.path} onUpdate={this.props.onUpdate} text="Edit"/>
        </div>
      );
    }
  });
})();

