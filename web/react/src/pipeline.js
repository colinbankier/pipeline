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
  loadFromServer: function() {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      success: function(data) {
        this.setState({data: data});
        console.log("Hello");
        console.log(data);
        console.log(this.props);
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
    console.log(this.state.data);
    var taskNodes = this.state.data.tasks.map(function (task) {
      return <Task name={task.name} />;
    });
    return (
      <div className="pipeline">
      <h2 className="pipelineName">
       {this.state.data.name}
       </h2>
      <div className="taskList">
        {taskNodes}
      </div>
      </div>
    );
  }
});

var Comment = React.createClass({
render: function() {
return (
  <div className="comment">
  <h2 className="commentAuthor">
  {this.props.author}
  </h2>
  {this.props.children}
  </div>
  );
}
});
var CommentList = React.createClass({
render: function() {
var commentNodes = this.props.data.map(function (comment) {
  return <Comment author={comment.author}>{comment.text}</Comment>;
  });
return (
  <div className="commentList">
  {commentNodes}
  </div>
  );
}
});

var CommentForm = React.createClass({
  handleSubmit: function() {
    var author = this.refs.author.getDOMNode().value.trim();
    var text = this.refs.text.getDOMNode().value.trim();
    this.props.onCommentSubmit({author: author, text: text});
    if (!text || !author) {
      return false;
    }
    // TODO: send request to the server
    this.refs.author.getDOMNode().value = '';
    this.refs.text.getDOMNode().value = '';
    return false;
  },
  render: function() {
    return (
      <div className="commentForm">
      <form className="commentForm" onSubmit={this.handleSubmit}>
      <input type="text" placeholder="Your name" ref="author" />
      <input type="text" placeholder="Say something..." ref="text" />
      <input type="submit" value="Post" />
      </form>
      </div>
    );
  }
});
var CommentBox = React.createClass({
  loadCommentsFromServer: function() {
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
  handleCommentSubmit: function(comment) {
    var comments = this.state.data;
    var newComments = comments.concat([comment]);
    this.setState({data: newComments});
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      type: 'POST',
      data: comment,
      success: function(data) {
        this.setState({data: data});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  getInitialState: function() {
    return {data: []};
  },
  componentWillMount: function() {
    this.loadCommentsFromServer();
    //setInterval(this.loadCommentsFromServer, this.props.pollInterval);
  },
  render: function() {
    return (
      <div className="commentBox">
      <h1>Comments</h1>
      <CommentList data={this.state.data} />
      <CommentForm onCommentSubmit={this.handleCommentSubmit} />
      </div>
    );
  }
});
React.renderComponent(
  <Pipeline url="pipeline.json"/>,
  document.getElementById('content')
);

