/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  app.TaskStatus = React.createClass({
    render: function() {
      return (
        <div className="task">
        {this.props.task.name}
        {this.props.task.status}
        </div>
      );
    }
  });
})();

