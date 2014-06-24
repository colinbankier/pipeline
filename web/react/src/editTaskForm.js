/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  app.EditTaskForm = React.createClass({
    render: function() {
      <label>
      Command
        <input type="text" placeholder="Shell command to execute" ref="command" defaultValue={this.state.task.command} onChange={this.handleChange}/>
      </label>
    }
  });
})();
