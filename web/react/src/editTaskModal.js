/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  app.EditTaskModal = React.createClass({
    handleSubmit: function() {
      var name = this.refs.name.getDOMNode().value.trim();
      var type = jQuery("input[name=typeSelector]:checked").val()
      var task = {name: name, type: type}
      if (type == "pipeline") {
        task.tasks = []; //{0: {type: "task", name: "New task"}};
      }
      this.createTask(task);
      this.props.onRequestHide();
    },
    createTask: function(task) {
      this.props.onUpdate(task, this.props.path);
    },
    render: function() {
      return this.transferPropsTo(
        <Modal title="Modal heading" animation={false}>
        <div className="modal-body form-group">
        <input type="text" placeholder="A task" ref="name" />
        <label>
        <input type="radio" name="typeSelector" value="task" defaultChecked={true}/>
        Task
        </label>
        <label>
        <input type="radio" id="pipelineSelector" name="typeSelector" value="pipeline"/>
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
