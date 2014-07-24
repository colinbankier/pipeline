/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  var EditTaskModal = app.EditTaskModal;
  app.AddTask = React.createClass({
    render: function() {
      return (
        <ModalTrigger modal={<EditTaskModal task={this.props.task} path={this.props.path} onUpdate={this.props.onUpdate} />}>
        <Button bsStyle="link" bsSize="small">{this.props.text}</Button>
        </ModalTrigger>
      );
    }
  });
})();
