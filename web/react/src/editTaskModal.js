/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  var AddTask = app.AddTask;

  app.EditTaskModal = React.createClass({
    handleSubmit: function() {
      var name = this.refs.name.getDOMNode().value.trim();
      var type = jQuery("input[name=typeSelector]:checked").val();
      var task = this.state.task;
      task.name = name;
      task.type = type;
      // var task = {name: name, type: type}
      if (type == "pipeline" && typeof task.tasks === "undefined") {
        task.tasks = [];
      }
      this.createTask(task);
      this.props.onRequestHide();
    },
    createTask: function(task) {
      this.props.onUpdate(task, this.props.path);
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
    render: function() {
      return this.transferPropsTo(
        <Modal title="Modal heading" animation={false}>
        <div className="modal-body form-group">
        <input type="text" placeholder="A task" ref="name" defaultValue={this.state.task.name} onChange={this.handleChange}/>
        <label>
        <input type="radio" name="typeSelector" value="task" defaultChecked={this.state.task.type == 'task' || typeof this.state.task.type === "undefined"}/>
        Task
        </label>
        <label>
        <input type="radio" id="pipelineSelector" name="typeSelector" value="pipeline" defaultChecked={this.state.task.type == 'pipeline'}/>
        Pipeline
        </label>
        <div>I am here</div>
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
