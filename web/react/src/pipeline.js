/**
* @jsx React.DOM
*/

var Task = React.createClass({
  render: function() {
    return (
      <div className="task">
      {this.props.index} {this.props.name}
      </div>
    );
  }
});

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
      element = <Task name={task.name} path={path} index={index} />;
      }
      index = index + 1;
      return element;
    });
    var addTaskPath = parentPath.concat(index);
    return (
      <div className="pipeline">
      <h2 className="pipelineName">
      {this.props.index} {this.props.pipeline.name}
       </h2>
       <AddTask pipeline={this.props.pipeline} path={addTaskPath} onUpdate={this.props.onUpdate}/>
      <div className="taskList">
        {taskNodes}
      </div>
      </div>
    );
  }
});

var PipelineView = React.createClass({
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

var EditTaskModal = React.createClass({
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

var AddTask = React.createClass({
  render: function() {
    return (
    <ModalTrigger modal={<EditTaskModal pipeline={this.props.pipeline} path={this.props.path} onUpdate={this.props.onUpdate} />}>
      <Button>Add task</Button>
    </ModalTrigger>
    );
  }
});

React.renderComponent(
  <PipelineView url="pipeline.json"/>,
  document.getElementById('content')
);
