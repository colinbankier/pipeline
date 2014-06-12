/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  var EditTaskModal = app.EditTaskModal;
  app.AddTask = React.createClass({
    render: function() {
      return (
        <ModalTrigger modal={<EditTaskModal pipeline={this.props.pipeline} path={this.props.path} onUpdate={this.props.onUpdate} />}>
        <Button>Add task</Button>
        </ModalTrigger>
      );
    }
  });
})();
