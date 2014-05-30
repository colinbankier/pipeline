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
      {this.props.name}
      </div>
    );
  }
});

var Pipeline = React.createClass({
  render: function() {
    var taskNodes = this.props.tasks.map(function (task) {
      if (task.type == "pipeline") {
      return <Pipeline name={task.name} tasks={task.tasks} />;
      } else {
      return <Task name={task.name} />;
      }
    });
    return (
      <div className="pipeline">
      <h2 className="pipelineName">
       {this.props.name}
       </h2>
       <AddTask/>
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
  getInitialState: function() {
    return {data: {name: "", tasks: []}};
  },
  componentWillMount: function() {
    this.loadFromServer();
  },
  render: function() {
    return (
      <Pipeline name={this.state.data.name} tasks={this.state.data.tasks} />
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

var AddTask = React.createClass({
  handleCancel: function() {
    if (confirm('Are you sure you want to cancel?')) {
      this.refs.modal.close();
    }
  },
  createTask: function() {
  },
  render: function() {
    var modal = null;
    modal = (
      <BootstrapModal
        ref="modal"
        confirm="OK"
        cancel="Cancel"
        onCancel={this.handleCancel}
        onConfirm={this.closeModal}
        title="Hello, Bootstrap!">
          This is a React component powered by jQuery and Bootstrap!
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

React.renderComponent(
  <PipelineView url="pipeline.json"/>,
  document.getElementById('content')
);
