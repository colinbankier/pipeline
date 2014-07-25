/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  var EditTaskModal = app.EditTaskModal;
  app.NewPipeline = React.createClass({
    create: function() {
      console.write("new pipeline");
    },
    emptyPipeline: {name: "", type: "pipeline"},
    render: function() {
      return (
        <ModalTrigger modal={<EditTaskModal task={this.emptyPipeline} path={[]} onUpdate={this.create} />}>
        <Button bsStyle="link" bsSize="small">{this.props.text}</Button>
        </ModalTrigger>
      );
    }
  });
})();
