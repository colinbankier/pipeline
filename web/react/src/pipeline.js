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
  onCreateTask: function(task) {
    var pipeline = this.props.pipeline
    this.props.onUpdate(pipeline, this.props.path);
  },
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
    return (
      <div className="pipeline">
      <h2 className="pipelineName">
      {this.props.index} {this.props.pipeline.name}
       </h2>
       <AddTask pipeline={this.props.pipeline} path={this.props.path} onUpdate={this.onCreateTask}/>
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
  updatePipeline: function(pipeline, path) {
    var patchMap = path.reduceRight(function(acc, index) {
      var tasks = {};
      tasks[index] = acc;
      return { tasks: tasks};
    }, pipeline);
    console.log("patchMap");
    console.log(patchMap);
    var newState = I(this.state.data).patch(patchMap);
    console.log(newState.dump());
    this.setState({data: newState.dump()});
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
      task.tasks = [];
    }
    this.createTask(task);
    this.props.onRequestHide();
  },
  createTask: function(task) {
    var pipeline = this.props.pipeline
    pipeline.tasks = pipeline.tasks.concat([task]);
    this.props.onUpdate(pipeline, this.props.path);
  },
  render: function() {
    return this.transferPropsTo(
        <Modal title="Modal heading" animation={false}>
          <div className="modal-body">
      <input type="text" placeholder="A task" ref="name" />
      <div className="typeSelector">
      <input type="radio" id="taskSelector" name="typeSelector" value="task" defaultChecked={true}/><label for="taskSelector">Task</label>
      <input type="radio" id="pipelineSelector" name="typeSelector" value="pipeline"/><label for="pipelineSelector">Pipeline</label>
        </div>
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
    <ModalTrigger modal={<EditTaskModal pipeline={this.props.pipeline} onUpdate={this.props.onUpdate} />}>
      <Button>Add task</Button>
    </ModalTrigger>
    );
  }
});

React.renderComponent(
  <PipelineView url="pipeline.json"/>,
  document.getElementById('content')
);
