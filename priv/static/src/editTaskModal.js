/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  var AddTask = app.AddTask;

  app.EditTaskModal = React.createClass({
    handleSubmit: function() {
      var task = this.state.task;
      if (task.type == "task") {
        delete task.tasks;
      } else if (task.type == "pipeline") {
        if (typeof task.tasks === "undefined") {
          task.tasks = [];
        }
        delete task.command;
      }
      this.props.onUpdate(task, this.props.path);
      this.props.onRequestHide();
    },
    getInitialState: function() {
      return {task: {name: ""}};
    },
    componentWillMount: function() {
      this.setState({task: this.props.task});
    },
    handleNameChange: function(event) {
      var task = this.state.task;
      task.name = event.target.value;
      this.setState({task: task});
    },
    handleTypeChange: function(event) {
      var task = this.state.task;
      task.type = event.target.value;
      this.setState({task: task});
    },
    handleCommandChange: function(event) {
      var task = this.state.task;
      task.command = event.target.value;
      this.setState({task: task});
    },
    render: function() {
      return this.transferPropsTo(
        <Modal title="Modal heading" animation={false}>
        <div className="modal-body form-group">
        <input type="text" placeholder="A task" ref="name" defaultValue={this.state.task.name} onChange={this.handleNameChange}/>
        <label>
        <input type="radio" name="typeSelector" value="task" defaultChecked={this.state.task.type == 'task' || typeof this.state.task.type === "undefined"} onChange={this.handleTypeChange}/>
        Task
        </label>
        <label>
        <input type="radio" id="pipelineSelector" name="typeSelector" value="pipeline" defaultChecked={this.state.task.type == 'pipeline'} onChange={this.handleTypeChange}/>
        Pipeline
        </label>
        { this.state.task.type == 'task' ?
      <label>
      Command
        <input type="text" placeholder="Shell command to execute" ref="command" defaultValue={this.state.task.command} onChange={this.handleCommandChange}/>
      </label> :
        <span></span>
        }
        </div>
        <div className="modal-footer">
        <Button
        onClick={this.handleSubmit}
        className="btn-primary">
        Ok
        </Button>
        <Button onClick={this.props.onRequestHide}>
        Cancel
        </Button>
        </div>
        </Modal>
      );
    }
  });
})();
