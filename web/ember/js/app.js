App = Ember.Application.create();

App.Router.map(function() {
  // put your routes here
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

App.set('pipeline', {
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
                    ]
                }
            ]
        }
    ]
});
