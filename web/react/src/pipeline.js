/**
* @jsx React.DOM
*/



var data = [
{author: "Pete Hunt", text: "This is one comment"},
{author: "Jordan Walke", text: "This is *another* comment"}
];

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
  onUpdate: function (pipeline) {
    alert("pipeline update " + pipeline.name + " " + this.props.pipeline.name);
    alert(this.props.parent);
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
    console.log("render");
    console.log(this.props.pipeline);
    console.log(this.props.path);
    return (
      <div className="pipeline">
      <h2 className="pipelineName">
      {this.props.index} {this.props.pipeline.name}
       </h2>
       <OverlayTriggerInstance pipeline={this.props.pipeline} path={this.props.path} onUpdate={this.onCreateTask}/>
       <AddTask pipeline={this.props.pipeline} onCreateTask={this.onCreateTask}/>
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
    console.log("path");
    console.log(path);
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

var MyModal = React.createClass({
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
    console.log(this.props.pipeline);
    var pipeline = this.props.pipeline
    console.log("I have pipeline ");
    console.log(pipeline);
    pipeline.tasks = pipeline.tasks.concat([task]);
    console.log("I have pipeline ");
    console.log(pipeline);
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

var OverlayTriggerInstance = React.createClass({
  render: function() {
    return (
    <ModalTrigger modal={<MyModal pipeline={this.props.pipeline} onUpdate={this.props.onUpdate} />}>
      <Button bsStyle="primary" bsSize="large">Launch demo modal</Button>
    </ModalTrigger>
    );
  }
});

var BootstrapButton = React.createClass({
  render: function() {
    // transferPropsTo() is smart enough to merge classes provided
    // to this component.
    return this.transferPropsTo(
      <a href="javascript:;" role="button" className="btn">
        {this.props.children}
      </a>
    );
  }
});

var BootstrapModal = React.createClass({
  // The following two methods are the only places we need to
  // integrate with Bootstrap or jQuery!
  componentDidMount: function() {
    // When the component is added, turn it into a modal
    $(this.getDOMNode())
      .modal({backdrop: 'static', keyboard: false, show: false})
  },
  componentWillUnmount: function() {
    $(this.getDOMNode()).off('hidden', this.handleHidden);
  },
  close: function() {
    $(this.getDOMNode()).modal('hide');
  },
  open: function() {
    $(this.getDOMNode()).modal('show');
  },
  render: function() {
    var confirmButton = null;
    var cancelButton = null;

    if (this.props.confirm) {
      confirmButton = (
        <BootstrapButton
          onClick={this.handleConfirm}
          className="btn-primary">
          {this.props.confirm}
        </BootstrapButton>
      );
    }
    if (this.props.cancel) {
      cancelButton = (
        <BootstrapButton onClick={this.handleCancel}>
          {this.props.cancel}
        </BootstrapButton>
      );
    }

    return (
      <div className="modal fade">
        <div className="modal-header">
          <button
            type="button"
            className="close"
            onClick={this.handleCancel}
            dangerouslySetInnerHTML={{__html: '&times'}}
          />
          <h3>{this.props.title}</h3>
        </div>
        <div className="modal-body">
          {this.props.children}
        </div>
        <div className="modal-footer">
          {cancelButton}
          {confirmButton}
        </div>
      </div>
    );
  },
  handleCancel: function() {
    if (this.props.onCancel) {
      this.props.onCancel();
    }
  },
  handleConfirm: function() {
    if (this.props.onConfirm) {
      this.props.onConfirm();
    }
  }
});

// Not used - just reference
var TaskForm = React.createClass({
  handleSubmit: function() {
    var name = this.refs.name.getDOMNode().value.trim();
    this.props.onCreateTask({name: name});
    if (!name) {
      return false;
    }
  },
  render: function() {
    return (
      <div className="taskForm">
      <form className="taskForm" onSubmit={this.handleSubmit}>
      <input type="text" placeholder="A task" ref="name" />
      </form>
      </div>
    );
  }
});

var AddTask = React.createClass({
  handleCancel: function() {
    if (confirm('Are you sure you want to cancel?')) {
      this.refs.modal.close();
    }
  },
  handleSubmit: function() {
    var name = this.refs.name.getDOMNode().value.trim();
    var type = jQuery("input[name=typeSelector]:checked").val()
    var task = {name: name, type: type}
    if (type == "pipeline") {
      task.tasks = [];
    }
    this.props.onCreateTask(task);
    this.refs.modal.close();
  },
  render: function() {
    var modal = null;
    modal = (
      <BootstrapModal
        ref="modal"
        confirm="OK"
        cancel="Cancel"
        onCancel={this.handleCancel}
        onConfirm={this.handleSubmit}
        title="Hello, Bootstrap!">
      <div className="thistaskForm">
      <form class="newTaskthing" name="newTask">
      <input type="text" placeholder="A task" ref="name" />
      <div>I am here</div>
      </form>
      </div>
      </BootstrapModal>
    );
    return (
      <div className="addTask">
        {modal}
        <BootstrapButton onClick={this.openModal}>Add task</BootstrapButton>
      </div>
    );
  },
  openModal: function() {
    this.refs.modal.open();
  },
  closeModal: function() {
    this.refs.modal.close();
  }
});
      // <div>I am here</div>
      // <div>I am here</div>
      // <div>I am here</div>
      // <div>I am here</div>
      // <div>I am here</div>
      // <div>I am here</div>
      // <div>I am here</div>
      // <div>I am here</div>
      // <div>I am here</div>

      // <label for="taskSelector">Task</label>
      // <label for="pipelineSelector">Pipeline</label>
      // <div className="typeSelector">
      // <input type="radio" id="taskSelector" name="typeSelector" value="task" defaultChecked={true}/><label for="taskSelector">Task</label>
      // <input type="radio" id="pipelineSelector" name="typeSelector" value="pipeline"/><label for="pipelineSelector">Pipeline</label>
      //   </div>
React.renderComponent(
  <PipelineView url="pipeline.json"/>,
  document.getElementById('content')
);
// React.renderComponent(OverlayTriggerInstance, document.getElementById('jqueryexample'));
