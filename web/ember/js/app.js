App = Ember.Application.create({
  LOG_TRANSITIONS: true
});

var pipeline = {
    name: 'Root Pipeline',
    tasks: [
      {
      name: 'Task 1',
      tasks: [
        {
        name: 'Task 2',
        tasks: [
          {
          name: 'Run'
        },
        {
          name: 'Shell'
        }
        ] } ] }
    ]
}

App.Router.map(function() {
  this.resource('design', function() {
    this.resource('task', { path: ':task_path' });
  });
});

App.DesignRoute = Ember.Route.extend({
  model: function() {
    return pipeline;
  }
});

App.TaskRoute = Ember.Route.extend({
  model: function(params) {
    var path = params.task_path.split('|');
    var task = this.findTask(pipeline, path);
    console.log(task);
    return pipeline;
  },
  findTask: function(pipeline, path) {
    if (path.length == 1 &&
        path.firstObject == pipeline.name) {
        return pipeline;
    } else if (path.firstObject == pipeline.name) {
      var task = pipeline.tasks.findBy('name', path[1]);
    }

    return pipeline;
  }
});

App.TreeBranchController = Ember.ObjectController.extend({
});
App.register('controller:treeBranch', App.TreeBranchController, {singleton: false});

App.TreeBranchView = Ember.View.extend({
    tagName: 'ul',
      templateName: 'tree-branch',
        classNames: ['tree-branch']
});

App.TreeNodeController = Ember.ObjectController.extend({
  isExpanded: false,
  toggle: function() {
    this.set('isExpanded', !this.get('isExpanded'));
  },
  click: function() {
    console.log('Clicked: '+this.get('text'));
  }
});
App.register('controller:treeNode', App.TreeNodeController, {singleton: false});

App.TreeNodeView = Ember.View.extend({
    tagName: 'li',
      templateName: 'tree-node',
        classNames: ['tree-node']
});

App.set('pipeline', pipeline);