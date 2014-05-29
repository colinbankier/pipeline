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
      <div className="taskList" class="task-list">
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

React.renderComponent(
  <PipelineView url="pipeline.json"/>,
  document.getElementById('content')
);

